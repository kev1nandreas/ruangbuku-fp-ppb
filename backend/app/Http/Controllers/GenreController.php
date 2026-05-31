<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreGenreRequest;
use App\Http\Requests\UpdateGenreRequest;
use App\Models\Genre;

class GenreController extends Controller
{
    public function index()
    {
        //
    }

    public function store(StoreGenreRequest $request)
    {
        //
    }

    public function show(Genre $genre)
    {
        //
    }

    public function update(UpdateGenreRequest $request, Genre $genre)
    {
        //
    }

    public function destroy(Genre $genre)
    {
        //
    }
}
