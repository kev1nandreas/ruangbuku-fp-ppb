<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\BukuController;
use App\Http\Controllers\DeviceTokenController;
use App\Http\Controllers\GenreController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\PeminjamanController;
use App\Http\Controllers\StorageController;
use App\Http\Controllers\TestNotificationController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {

    // Auth
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/me', [AuthController::class, 'me']);

        // Push notifications (FCM device token registration)
        Route::post('/device-token', [DeviceTokenController::class, 'store']);
        Route::delete('/device-token', [DeviceTokenController::class, 'destroy']);

        Route::post('/test-notification', [TestNotificationController::class, 'send']);

        // In-app notification feed (persisted, per-user, filterable by category)
        Route::get('/notifications', [NotificationController::class, 'index']);
        Route::get('/notifications/unread-count', [NotificationController::class, 'unreadCount']);
        Route::post('/notifications/read-all', [NotificationController::class, 'markAllRead']);
        Route::post('/notifications/{id}/read', [NotificationController::class, 'markRead']);

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

        // Owner actions
        Route::post('/peminjaman/{peminjaman}/approve', [PeminjamanController::class, 'approve']);
        Route::post('/peminjaman/{peminjaman}/reject', [PeminjamanController::class, 'reject']);
        Route::post('/peminjaman/{peminjaman}/confirm-deposit', [PeminjamanController::class, 'confirmDeposit'])->middleware('role:admin');
        Route::post('/peminjaman/{peminjaman}/hand-over', [PeminjamanController::class, 'handOver']);
        Route::post('/peminjaman/{peminjaman}/confirm-return', [PeminjamanController::class, 'confirmReturn']);
        Route::post('/peminjaman/{peminjaman}/report-damage', [PeminjamanController::class, 'reportDamage']);

        // Deposit settlement (admin)
        Route::post('/peminjaman/{peminjaman}/return-deposit', [PeminjamanController::class, 'returnDeposit'])->middleware('role:admin');
        Route::post('/peminjaman/{peminjaman}/resolve-damage', [PeminjamanController::class, 'resolveDamage'])->middleware('role:admin');

        // Storage (MinIO)
        Route::post('/storage/presigned-url', [StorageController::class, 'presignedUrl']);
    });
});
