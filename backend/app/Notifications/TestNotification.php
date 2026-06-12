<?php

namespace App\Notifications;

use Illuminate\Notifications\Notification;
use NotificationChannels\Fcm\FcmChannel;
use NotificationChannels\Fcm\FcmMessage;
use NotificationChannels\Fcm\Resources\Notification as FcmNotification;

/**
 * Throwaway notification used only to verify the FCM pipeline end to end
 * (credentials, device token, channel, OS rendering) without needing a real
 * peminjaman to exist or change status.
 */
class TestNotification extends Notification
{
    public function __construct(
        public string $title = 'Test Notifikasi',
        public string $body = 'Halo! Ini notifikasi percobaan dari RuangBuku.',
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
        return FcmMessage::create()
            ->notification(new FcmNotification(
                title: $this->title,
                body: $this->body,
            ))
            ->data([
                'type' => 'test',
            ])
            // Same channel/options as PeminjamanStatusChanged so the test
            // exercises the real delivery path the app is configured for.
            ->android([
                'notification' => [
                    'sound'        => 'default',
                    'click_action' => 'FLUTTER_NOTIFICATION_CLICK',
                    'channel_id'   => 'ruangbuku_status',
                ],
            ]);
    }
}
