<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Peminjaman extends Model
{
    public $timestamps = false;

    protected $table = 'peminjaman';

    protected $fillable = [
        'start_date',
        'end_date',
        'status',
        'created_at',
        'verified_at',
        'returned_at',
        'buktiDeposit',
        'user_id',
        'buku_id',
    ];

    protected function casts(): array
    {
        return [
            'start_date'   => 'datetime',
            'end_date'     => 'datetime',
            'created_at'   => 'datetime',
            'verified_at'  => 'datetime',
            'returned_at'  => 'datetime',
        ];
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function buku()
    {
        return $this->belongsTo(Buku::class, 'buku_id');
    }
}
