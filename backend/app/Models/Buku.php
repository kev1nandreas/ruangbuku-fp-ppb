<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

class Buku extends Model
{
    use HasUuids;

    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'isbn',
        'title',
        'author',
        'description',
        'coverImageUrl',
        'statusVerifikasi',
    ];

    public function genres()
    {
        return $this->belongsToMany(Genre::class, 'genre_buku', 'buku_id', 'genre_id');
    }

    public function users()
    {
        return $this->belongsToMany(User::class, 'user_buku', 'buku_id', 'user_id')
                    ->withPivot('isPublic');
    }

    public function peminjaman()
    {
        return $this->hasMany(Peminjaman::class, 'buku_id');
    }
}
