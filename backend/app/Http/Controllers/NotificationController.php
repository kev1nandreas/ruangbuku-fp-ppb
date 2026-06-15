<?php

namespace App\Http\Controllers;

use App\Models\AppNotification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\Rule;

class NotificationController extends Controller
{
    /**
     * Paginated notification feed for the authenticated user.
     *
     * Filters: `category` (one of AppNotification::CATEGORIES) and
     * `unread=1` (only unread). Newest first. Also returns the unread count
     * so the client can render a badge from a single request.
     */
    public function index(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'category' => ['nullable', 'string', Rule::in(AppNotification::CATEGORIES)],
            'unread'   => ['nullable', 'boolean'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:100'],
        ]);

        $userId = Auth::id();

        $notifications = AppNotification::query()
            ->forUser($userId)
            ->category($validated['category'] ?? null)
            ->when($request->boolean('unread'), fn ($q) => $q->unread())
            ->latest('created_at')
            ->paginate($validated['per_page'] ?? 20);

        $unreadCount = AppNotification::query()
            ->forUser($userId)
            ->unread()
            ->count();

        return $this->success('Daftar notifikasi', [
            'notifications' => $notifications,
            'unread_count'  => $unreadCount,
        ]);
    }

    /**
     * Unread count only (cheap badge refresh without fetching the feed).
     */
    public function unreadCount(): JsonResponse
    {
        $count = AppNotification::query()
            ->forUser(Auth::id())
            ->unread()
            ->count();

        return $this->success('Jumlah notifikasi belum dibaca', ['unread_count' => $count]);
    }

    /**
     * Mark a single notification (owned by the caller) as read.
     */
    public function markRead(string $id): JsonResponse
    {
        $notification = AppNotification::query()
            ->forUser(Auth::id())
            ->findOrFail($id);

        if ($notification->read_at === null) {
            $notification->update(['read_at' => now()]);
        }

        return $this->success('Notifikasi ditandai dibaca', $notification);
    }

    /**
     * Mark every unread notification of the caller as read.
     */
    public function markAllRead(): JsonResponse
    {
        $updated = AppNotification::query()
            ->forUser(Auth::id())
            ->unread()
            ->update(['read_at' => now()]);

        return $this->success('Semua notifikasi ditandai dibaca', ['updated' => $updated]);
    }

    /**
     * Delete a single notification (owned by the caller).
     */
    public function destroy(string $id): JsonResponse
    {
        $notification = AppNotification::query()
            ->forUser(Auth::id())
            ->findOrFail($id);

        $notification->delete();

        return $this->success('Notifikasi berhasil dihapus');
    }

    /**
     * Delete all notifications of the caller.
     */
    public function clearAll(): JsonResponse
    {
        $deleted = AppNotification::query()
            ->forUser(Auth::id())
            ->delete();

        return $this->success('Semua notifikasi berhasil dihapus', ['deleted_count' => $deleted]);
    }

    /**
     * Broadcast a system notification to all users (Admin only).
     */
    public function broadcast(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'body'  => 'required|string',
        ]);

        $users = \App\Models\User::all();
        $notifications = [];

        foreach ($users as $user) {
            $notifications[] = [
                'id' => \Illuminate\Support\Str::uuid(),
                'user_id' => $user->id,
                'category' => AppNotification::CATEGORY_SYSTEM,
                'title' => $validated['title'],
                'body' => $validated['body'],
                'data' => json_encode([]),
                'created_at' => now(),
                'updated_at' => now(),
            ];
        }

        foreach (array_chunk($notifications, 500) as $chunk) {
        // Send FCM push notifications one by one to avoid one failure breaking the rest
        foreach ($users as $user) {
            try {
                \Illuminate\Support\Facades\Notification::send($user, new \App\Notifications\AnnouncementBroadcast($validated['title'], $validated['body']));
            } catch (\Throwable $e) {
                // Ignore delivery errors for individual users
            }
        }

        return $this->success('Pengumuman berhasil dikirim ke seluruh pengguna');
    }
}
