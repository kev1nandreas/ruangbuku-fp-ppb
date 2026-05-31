<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

class Genre extends Model
{
    use HasUuids;

    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = ['name'];

    public function bukus()
    {
        return $this->belongsToMany(Buku::class, 'genre_buku', 'genre_id', 'buku_id');
    }
}
