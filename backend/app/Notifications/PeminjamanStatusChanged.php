<?php

namespace App\Notifications;

use App\Models\Peminjaman;
use Illuminate\Notifications\Notification;
use NotificationChannels\Fcm\FcmChannel;
use NotificationChannels\Fcm\FcmMessage;
use NotificationChannels\Fcm\Resources\Notification as FcmNotification;

/**
 * Sent to a peminjaman participant whenever its status moves to a new state.
 * The same notification class serves both parties; the caller picks who the
 * notifiable is (borrower or book owner) for each transition.
 */
class PeminjamanStatusChanged extends Notification
{
    public function __construct(
        public Peminjaman $peminjaman,
        public string $title,
        public string $body,
    ) {}

    /**
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return [FcmChannel::class];
    }

    public function toFcm(object $notifiable): FcmMessage
    {
        $bookTitle = $this->peminjaman->buku?->title ?? 'Buku';

        return FcmMessage::create()
            ->notification(new FcmNotification(
                title: $this->title,
                body: $this->body,
            ))
            ->data([
                'type'          => 'peminjaman_status',
                'peminjaman_id' => (string) $this->peminjaman->id,
                'status'        => (string) $this->peminjaman->status,
                'book_title'    => (string) $bookTitle,
            ])
            // Android-specific options merged into the v1 `android` block.
            // click_action lets the Flutter app route taps to the borrow detail.
            ->android([
                'notification' => [
                    'sound'        => 'default',
                    'click_action' => 'FLUTTER_NOTIFICATION_CLICK',
                    'channel_id'   => 'ruangbuku_status',
                ],
            ]);
    }
}
