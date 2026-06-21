<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

class Kerusakan extends Model
{
    use HasUuids;

    public $incrementing = false;
    protected $keyType = 'string';

    protected $table = 'kerusakan';

    protected $fillable = [
        'peminjaman_id',
        'description',
        'photos',
        'reported_at',
    ];

    protected function casts(): array
    {
        return [
            'photos'      => 'array',
            'reported_at' => 'datetime',
        ];
    }

    public function peminjaman()
    {
        return $this->belongsTo(Peminjaman::class, 'peminjaman_id');
    }
}
