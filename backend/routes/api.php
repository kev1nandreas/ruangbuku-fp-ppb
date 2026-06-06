<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\BukuController;
use App\Http\Controllers\GenreController;
use App\Http\Controllers\PeminjamanController;
use App\Http\Controllers\StorageController;
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
        Route::post('/buku/{buku}/verify', [BukuController::class, 'verifyBuku'])->middleware('role:admin');

        // Peminjaman (borrowing lifecycle)
        Route::apiResource('/peminjaman', PeminjamanController::class)
            ->only(['index', 'store', 'show']);

        // Borrower actions
        Route::post('/peminjaman/{peminjaman}/deposit', [PeminjamanController::class, 'submitDeposit']);
        Route::post('/peminjaman/{peminjaman}/cancel', [PeminjamanController::class, 'cancel']);

        // Owner actions
        Route::post('/peminjaman/{peminjaman}/approve', [PeminjamanController::class, 'approve']);
        Route::post('/peminjaman/{peminjaman}/reject', [PeminjamanController::class, 'reject']);
        Route::post('/peminjaman/{peminjaman}/confirm-deposit', [PeminjamanController::class, 'confirmDeposit'])->middleware('role:admin');
        Route::post('/peminjaman/{peminjaman}/hand-over', [PeminjamanController::class, 'handOver']);
        Route::post('/peminjaman/{peminjaman}/confirm-return', [PeminjamanController::class, 'confirmReturn']);

        // Storage (MinIO)
        Route::post('/storage/presigned-url', [StorageController::class, 'presignedUrl']);
    });
});
