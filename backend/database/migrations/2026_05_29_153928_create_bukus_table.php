<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('bukus', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('isbn', 30);
            $table->string('title', 255);
            $table->string('author', 255);
            $table->string('description', 2000)->nullable();
            $table->string('statusVerifikasi', 20)->default('private');
            $table->string('coverImageUrl', 255)->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('bukus');
    }
};
