<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\BukuController;
use App\Http\Controllers\GenreController;
use App\Http\Controllers\PeminjamanController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {

    // Auth
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/me', [AuthController::class, 'me']);

        // Genre
        Route::apiResource('/genres', GenreController::class);

        // Buku
        Route::apiResource('/buku', BukuController::class);
        Route::get("/isbn-check/{id}", [BukuController::class, 'isbnCheck']);
        Route::patch('/buku/{buku}/verify', [BukuController::class, 'verifyBuku'])->middleware('role:admin');

        // Peminjaman
        Route::apiResource('/peminjaman', PeminjamanController::class);
    });
});
