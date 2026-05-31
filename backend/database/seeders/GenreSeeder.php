<?php

namespace Database\Seeders;

use App\Models\Genre;
use Illuminate\Database\Seeder;

class GenreSeeder extends Seeder
{
    public function run(): void
    {
        $genres = [
            'Fiksi',
            'Non-Fiksi',
            'Sains & Teknologi',
            'Sejarah',
            'Biografi',
            'Filsafat',
            'Psikologi',
            'Ekonomi & Bisnis',
            'Seni & Budaya',
            'Pendidikan',
            'Petualangan',
            'Romansa',
            'Horor',
            'Komedi',
            'Politik',
        ];

        foreach ($genres as $name) {
            Genre::firstOrCreate(['name' => $name]);
        }
    }
}
