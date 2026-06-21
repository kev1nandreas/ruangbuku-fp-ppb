<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Notifications\TestNotification;
use App\Services\PeminjamanNotifier;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class TestNotificationController extends Controller
{
    public function __construct(
        private readonly PeminjamanNotifier $notifier,
    ) {}

    /**
     * Fire a test FCM push to the authenticated user's own registered devices.
     *
     * Exists to verify the notification pipeline (Firebase credentials, device
     * token, channel, OS rendering) without driving a real peminjaman status
     * change. Optional `title`/`body` let the caller customise the payload.
     */
    public function send(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'title' => ['nullable', 'string', 'max:120'],
            'body'  => ['nullable', 'string', 'max:240'],
        ]);

        /** @var User $user */
        $user = Auth::user();

        $tokenCount = $user->deviceTokens()->count();
        if ($tokenCount === 0) {
            return $this->error(
                'Tidak ada device token terdaftar untuk user ini. Login di aplikasi dulu agar token tersimpan.',
                ['device_tokens' => 0],
                422,
            );
        }

        $title = $validated['title'] ?? 'Test Notifikasi';
        $body  = $validated['body'] ?? 'Halo! Ini notifikasi percobaan dari RuangBuku.';

        $this->notifier->record($user, \App\Models\AppNotification::CATEGORY_TEST, $title, $body);
        $this->notifier->pushTo(
            $user,
            new TestNotification(title: $title, body: $body),
        );

        return $this->success('Notifikasi percobaan dikirim', [
            'device_tokens' => $tokenCount,
        ]);
    }
}
