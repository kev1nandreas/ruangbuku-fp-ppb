<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

/**
 * Persisted in-app notification. Named AppNotification (not Notification) to
 * avoid clashing with Laravel's own notification machinery, and backed by the
 * `app_notifications` table rather than the framework's `notifications` table.
 */
class AppNotification extends Model
{
    use HasUuids;

    public $incrementing = false;
    protected $keyType = 'string';

    protected $table = 'app_notifications';

    // --- categories ------------------------------------------------------

    public const CATEGORY_PEMINJAMAN = 'peminjaman_status';
    public const CATEGORY_TEST       = 'test';
    public const CATEGORY_SYSTEM     = 'system';

    public const CATEGORIES = [
        self::CATEGORY_PEMINJAMAN,
        self::CATEGORY_TEST,
        self::CATEGORY_SYSTEM,
    ];

    protected $fillable = [
        'user_id',
        'category',
        'title',
        'body',
        'data',
        'peminjaman_id',
        'read_at',
    ];

    protected function casts(): array
    {
        return [
            'data'    => 'array',
            'read_at' => 'datetime',
        ];
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function peminjaman()
    {
        return $this->belongsTo(Peminjaman::class, 'peminjaman_id');
    }

    /** Restrict to a single recipient's feed. */
    public function scopeForUser(Builder $query, string $userId): Builder
    {
        return $query->where('user_id', $userId);
    }

    /** Filter by category (no-op when null). */
    public function scopeCategory(Builder $query, ?string $category): Builder
    {
        return $query->when($category, fn (Builder $q) => $q->where('category', $category));
    }

    /** Only unread rows. */
    public function scopeUnread(Builder $query): Builder
    {
        return $query->whereNull('read_at');
    }
}
