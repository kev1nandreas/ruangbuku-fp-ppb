<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('kerusakan', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('peminjaman_id')->unique();
            $table->text('description');
            $table->json('photos');
            $table->timestamp('reported_at');
            $table->timestamp('created_at')->nullable();
            $table->timestamp('updated_at')->nullable();

            $table->foreign('peminjaman_id')->references('id')->on('peminjaman')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('kerusakan');
    }
};
