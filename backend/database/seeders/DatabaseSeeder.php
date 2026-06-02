<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Spatie\Permission\Models\Role;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call(GenreSeeder::class);

        $adminRole = Role::firstOrCreate(['name' => 'admin']);
        $userRole  = Role::firstOrCreate(['name' => 'user']);

        $admin = User::firstOrCreate(
            ['email' => 'admin@ruangbuku.com'],
            [
                'name'     => 'Admin',
                'password' => Hash::make('password'),
            ]
        );
        $admin->assignRole($adminRole);

        $user = User::firstOrCreate(
            ['email' => 'user@ruangbuku.com'],
            [
                'name'     => 'User',
                'password' => Hash::make('password'),
            ]
        );
        $user->assignRole($userRole);
    }
}
