<?php

namespace App\Services;

use App\Models\Peminjaman;
use App\Models\User;
use App\Notifications\PeminjamanStatusChanged;
use Illuminate\Notifications\Notification as BaseNotification;
use Illuminate\Support\Facades\Notification;

/**
 * Sends FCM push notifications tied to the borrowing (peminjaman) lifecycle.
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
        $this->pushTo($borrower, new PeminjamanStatusChanged($this->withBook($peminjaman), $title, $body));
    }

    /**
     * Push a status-change notification to every owner of the borrowed book.
     */
    public function notifyOwner(Peminjaman $peminjaman, string $title, string $body): void
    {
        $owners = $peminjaman->buku()->first()?->users()->get() ?? collect();
        foreach ($owners as $owner) {
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
     * Ensure the buku relation is loaded so the notification payload can
     * include the book title without an extra query per send.
     */
    private function withBook(Peminjaman $peminjaman): Peminjaman
    {
        $peminjaman->loadMissing('buku:id,title');

        return $peminjaman;
    }
}
