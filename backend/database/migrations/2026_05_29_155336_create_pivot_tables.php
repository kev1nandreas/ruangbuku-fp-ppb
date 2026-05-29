<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('genre_buku', function (Blueprint $table) {
            $table->uuid('genre_id');
            $table->uuid('buku_id');

            $table->primary(['genre_id', 'buku_id']);

            $table->foreign('genre_id')->references('id')->on('genres')->cascadeOnDelete();
            $table->foreign('buku_id')->references('id')->on('bukus')->cascadeOnDelete();
        });

        Schema::create('user_buku', function (Blueprint $table) {
            $table->uuid('user_id');
            $table->uuid('buku_id');

            $table->primary(['user_id', 'buku_id']);

            $table->foreign('user_id')->references('id')->on('users')->cascadeOnDelete();
            $table->foreign('buku_id')->references('id')->on('bukus')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('user_buku');
        Schema::dropIfExists('genre_buku');
    }
};
