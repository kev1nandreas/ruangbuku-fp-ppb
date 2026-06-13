<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * In-app notification feed, persisted separately from FCM delivery.
     *
     * One row per recipient per event: when a borrowing status change fans out
     * to several owners, each owner gets their own row so read state is
     * per-user. `category` lets the client filter the feed (e.g. only
     * peminjaman events), `data` mirrors the FCM payload for deep-linking, and
     * `read_at` drives the unread badge.
     */
    public function up(): void
    {
        Schema::create('app_notifications', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id');
            $table->string('category', 40);
            $table->string('title');
            $table->text('body')->nullable();
            $table->json('data')->nullable();
            $table->uuid('peminjaman_id')->nullable();
            $table->timestamp('read_at')->nullable();
            $table->timestamp('created_at')->nullable();
            $table->timestamp('updated_at')->nullable();

            $table->index(['user_id', 'created_at']);
            $table->index(['user_id', 'category']);
            $table->index(['user_id', 'read_at']);
            $table->foreign('user_id')->references('id')->on('users')->cascadeOnDelete();
            $table->foreign('peminjaman_id')->references('id')->on('peminjaman')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('app_notifications');
    }
};
