<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Validation\ValidationException;
use Illuminate\Auth\Access\AuthorizationException;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__ . '/../routes/web.php',
        api: __DIR__ . '/../routes/api.php',
        commands: __DIR__ . '/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        $middleware->alias([
            'role' => \Spatie\Permission\Middleware\RoleMiddleware::class,
            'permission' => \Spatie\Permission\Middleware\PermissionMiddleware::class,
            'role_or_permission' => \Spatie\Permission\Middleware\RoleOrPermissionMiddleware::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        $exceptions->render(function (AuthenticationException $e) {
            return response()->json([
                'status' => false,
                'message' => 'Unauthenticated.',
                'errors' => $e->getMessage(),
            ], status: 401);
        });

        $exceptions->render(function (AuthorizationException $e) {
            return response()->json([
                'status' => false,
                'message' => 'Unauthorized.',
                'errors' => $e->getMessage(),
            ], status: 403);
        });

        $exceptions->render(function (ValidationException $e) {
            return response()->json([
                'status' => false,
                'message' => 'Validation failed.',
                'errors' => $e->errors(),
            ], status: 422);
        });

        $exceptions->render(function (Throwable $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
            ], status: 500);
        });
    })->create();
