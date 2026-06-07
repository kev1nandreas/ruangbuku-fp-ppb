<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('peminjaman', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->timestamp('start_date');
            $table->timestamp('end_date');
            $table->string('status', 30)->default('pending');
            $table->timestamp('created_at')->nullable();
            $table->timestamp('updated_at')->nullable();
            $table->timestamp('verified_at')->nullable();
            $table->timestamp('deposit_received_at')->nullable();
            $table->timestamp('handed_over_at')->nullable();
            $table->timestamp('returned_at')->nullable();
            $table->string('buktiDeposit', 255)->nullable();

            // Deposit settlement — recorded by admin when the borrow is closed.
            // `deposit_returned_to`: who received the deposit (borrower | owner).
            $table->string('deposit_returned_to', 10)->nullable();
            $table->string('deposit_proof_url', 255)->nullable();
            $table->text('resolution_note')->nullable();
            $table->timestamp('deposit_returned_at')->nullable();
            $table->uuid('resolved_by')->nullable();

            $table->uuid('user_id');
            $table->uuid('buku_id');

            $table->foreign('user_id')->references('id')->on('users')->cascadeOnDelete();
            $table->foreign('buku_id')->references('id')->on('bukus')->cascadeOnDelete();
            $table->foreign('resolved_by')->references('id')->on('users')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('peminjaman');
    }
};
