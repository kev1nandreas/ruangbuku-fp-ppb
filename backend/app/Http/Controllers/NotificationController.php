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
}
