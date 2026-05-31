<?php

namespace App\Http\Controllers;

use App\Http\Requests\Auth\LoginRequest;
use App\Http\Requests\Auth\RegisterRequest;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function register(RegisterRequest $request): JsonResponse
    {
        $user = User::create([
            'name'     => $request->name,
            'email'    => $request->email,
            'password' => Hash::make($request->password),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return $this->created('Registrasi berhasil', [
            'user'  => $user,
            'token' => $token,
        ]);
    }

    public function login(LoginRequest $request): JsonResponse
    {
        if (!Auth::attempt($request->only('email', 'password'))) {
            return $this->error("Email atau password salah");
        }

        $user  = Auth::user();
        $token = $user->createToken('auth_token')->plainTextToken;

        return $this->success('Login berhasil', [
            'token' => $token,
            'user'  => $user,
        ]);
    }

    public function logout(): JsonResponse
    {
        Auth::user()->tokens()->delete();

        return $this->success('Logout berhasil');
    }

    public function me(): JsonResponse
    {
        return $this->success('Berhasil mengambil data pengguna', Auth::user()->load('roles'));
    }
}
