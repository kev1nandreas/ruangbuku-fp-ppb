<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

class Peminjaman extends Model
{
    use HasUuids;

    public $incrementing = false;
    protected $keyType = 'string';

    public $timestamps = false;

    protected $table = 'peminjaman';

    // --- status workflow -------------------------------------------------

    public const STATUS_PENDING          = 'pending';
    public const STATUS_WAITING_DEPOSIT  = 'waiting_deposit';
    public const STATUS_DEPOSIT_RECEIVED = 'deposit_received';
    public const STATUS_BOOK_RECEIVED    = 'book_received';
    public const STATUS_RETURNED         = 'returned';
    public const STATUS_DAMAGED          = 'damaged';
    public const STATUS_COMPLETED        = 'completed';
    public const STATUS_REJECTED         = 'rejected';
    public const STATUS_CANCELLED        = 'cancelled';

    // Who the admin returned the deposit to when settling a borrow.
    public const DEPOSIT_TO_BORROWER = 'borrower';
    public const DEPOSIT_TO_OWNER    = 'owner';

    /**
     * Statuses that count as an in-flight borrow: the book is reserved/held
     * and neither party has finished or backed out.
     */
    public const ACTIVE_STATUSES = [
        self::STATUS_PENDING,
        self::STATUS_WAITING_DEPOSIT,
        self::STATUS_DEPOSIT_RECEIVED,
        self::STATUS_BOOK_RECEIVED,
    ];

    protected $fillable = [
        'start_date',
        'end_date',
        'status',
        'created_at',
        'updated_at',
        'verified_at',
        'deposit_received_at',
        'handed_over_at',
        'returned_at',
        'buktiDeposit',
        'deposit_returned_to',
        'deposit_proof_url',
        'resolution_note',
        'deposit_returned_at',
        'resolved_by',
        'user_id',
        'buku_id',
    ];

    protected function casts(): array
    {
        return [
            'start_date'          => 'datetime',
            'end_date'            => 'datetime',
            'created_at'          => 'datetime',
            'updated_at'          => 'datetime',
            'verified_at'         => 'datetime',
            'deposit_received_at' => 'datetime',
            'handed_over_at'      => 'datetime',
            'returned_at'         => 'datetime',
            'deposit_returned_at' => 'datetime',
        ];
    }

    public function resolver()
    {
        return $this->belongsTo(User::class, 'resolved_by');
    }

    public function kerusakan()
    {
        return $this->hasOne(Kerusakan::class, 'peminjaman_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function buku()
    {
        return $this->belongsTo(Buku::class, 'buku_id');
    }

    public function isOwnedBy(?string $userId): bool
    {
        if ($userId === null) {
            return false;
        }

        return $this->buku()
            ->whereHas('users', fn($q) => $q->whereKey($userId))
            ->exists();
    }
}
