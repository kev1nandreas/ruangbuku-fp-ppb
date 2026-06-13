<?php

namespace App\Services;

use App\Models\AppNotification;
use App\Models\Peminjaman;
use App\Models\User;
use App\Notifications\PeminjamanStatusChanged;
use Illuminate\Notifications\Notification as BaseNotification;
use Illuminate\Support\Facades\Notification;

/**
 * Sends FCM push notifications tied to the borrowing (peminjaman) lifecycle,
 * and persists an in-app notification row per recipient so the app has a
 * notification feed independent of push delivery.
 *
 * Extracted from the controller so any controller that mutates a peminjaman
 * status can reuse the same borrower/owner targeting and the same
 * fire-and-forget delivery guarantee.
 */
class PeminjamanNotifier
{
    /**
     * Push a status-change notification to the borrower of this peminjaman.
     */
    public function notifyBorrower(Peminjaman $peminjaman, string $title, string $body): void
    {
        $borrower = $peminjaman->user()->first();
        $this->record($borrower, AppNotification::CATEGORY_PEMINJAMAN, $title, $body, $peminjaman);
        $this->pushTo($borrower, new PeminjamanStatusChanged($this->withBook($peminjaman), $title, $body));
    }

    /**
     * Push a status-change notification to every owner of the borrowed book.
     */
    public function notifyOwner(Peminjaman $peminjaman, string $title, string $body): void
    {
        $owners = $peminjaman->buku()->first()?->users()->get() ?? collect();
        foreach ($owners as $owner) {
            $this->record($owner, AppNotification::CATEGORY_PEMINJAMAN, $title, $body, $peminjaman);
            $this->pushTo($owner, new PeminjamanStatusChanged($this->withBook($peminjaman), $title, $body));
        }
    }

    /**
     * Send any notification to a single user. Delivery failures (e.g. missing
     * service account, dead token) must never break the calling request, so
     * they are reported and swallowed.
     *
     * Public + generic so other controllers can reuse it for their own
     * notifications, not just peminjaman ones.
     */
    public function pushTo(?User $user, BaseNotification $notification): void
    {
        if ($user === null) {
            return;
        }

        try {
            Notification::send($user, $notification);
        } catch (\Throwable $e) {
            report($e);
        }
    }

    /**
     * Persist an in-app notification row for one recipient. Failures must never
     * break the calling request (same guarantee as push delivery), so they are
     * reported and swallowed.
     *
     * Public so callers outside the peminjaman flow (test/system notifications)
     * can record a feed entry alongside their own push.
     */
    public function record(
        ?User $user,
        string $category,
        string $title,
        string $body,
        ?Peminjaman $peminjaman = null,
        array $data = [],
    ): void {
        if ($user === null) {
            return;
        }

        try {
            AppNotification::create([
                'user_id'       => $user->id,
                'category'      => $category,
                'title'         => $title,
                'body'          => $body,
                'peminjaman_id' => $peminjaman?->id,
                'data'          => $this->payload($peminjaman, $data),
            ]);
        } catch (\Throwable $e) {
            report($e);
        }
    }

    /**
     * Build the stored `data` payload, mirroring the FCM data block so the app
     * can deep-link from a feed item the same way it does from a push tap.
     */
    private function payload(?Peminjaman $peminjaman, array $extra): array
    {
        if ($peminjaman === null) {
            return $extra;
        }

        $peminjaman->loadMissing('buku:id,title');

        return array_merge([
            'type'          => 'peminjaman_status',
            'peminjaman_id' => (string) $peminjaman->id,
            'status'        => (string) $peminjaman->status,
            'book_title'    => (string) ($peminjaman->buku?->title ?? 'Buku'),
        ], $extra);
    }

    /**
     * Ensure the buku relation is loaded so the notification payload can
     * include the book title without an extra query per send.
     */
    private function withBook(Peminjaman $peminjaman): Peminjaman
    {
        $peminjaman->loadMissing('buku:id,title');

        return $peminjaman;
    }
}
