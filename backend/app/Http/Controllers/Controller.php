<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;

abstract class Controller
{
    protected function success(string $message, mixed $data = [], int $status = 200): JsonResponse
    {
        return response()->json([
            'status'  => true,
            'message' => $message,
            'data'    => $data,
        ], $status);
    }

    protected function error(string $message, mixed $error = [], int $status = 400): JsonResponse
    {
        return response()->json([
            'status'  => false,
            'message' => $message,
            'error'    => $error,
        ], $status);
    }

    protected function created(string $message, mixed $data = []): JsonResponse
    {
        return response()->json([
            'status'  => true,
            'message' => $message,
            'data'    => $data,
        ], 201);
    }
}
