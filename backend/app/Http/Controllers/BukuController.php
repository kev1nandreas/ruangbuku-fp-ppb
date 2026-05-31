<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreBukuRequest;
use App\Http\Requests\UpdateBukuRequest;
use App\Models\Buku;
use Illuminate\Support\Facades\Http;

class BukuController extends Controller
{
    public function index()
    {
        //
    }

    public function store(StoreBukuRequest $request)
    {
        $validated = $request->validated();
        $genreIds  = $validated['genre_ids'] ?? [];
        $isPublic  = $validated['isPublic'] ?? false;
        $userId    = $request->user()->id;

        $existing = Buku::query()->where('isbn', $validated['isbn'])->first();

        if ($existing) {
            $existing->users()->syncWithoutDetaching([
                $userId => ['isPublic' => $isPublic],
            ]);

            return $this->success('Buku sudah ada, kamu ditambahkan sebagai pemilik', $existing->load('genres:id,name'));
        }

        $statusVerifikasi = $isPublic ? 'need_verification' : 'private';

        $buku = Buku::create(array_diff_key($validated, ['genre_ids' => null, 'isPublic' => null]) + [
            'statusVerifikasi' => $statusVerifikasi,
        ]);

        if (!empty($genreIds)) {
            $buku->genres()->sync($genreIds);
        }

        $buku->users()->attach($userId, ['isPublic' => $isPublic]);

        return $this->created('Buku berhasil dibuat', $buku->load('genres:id,name'));
    }

    public function show(Buku $buku)
    {
        //
    }

    public function update(UpdateBukuRequest $request, Buku $buku)
    {
        //
    }

    public function destroy(Buku $buku)
    {
        //
    }

    public function isbnCheck(string $id)
    {
        $buku = Buku::query()->where('isbn', '=', $id)->first();

        if ($buku) {
            return $this->success('Buku ditemukan di database', [
                'isbn'        => $buku->isbn,
                'title'       => $buku->title,
                'author'      => $buku->author,
                'description' => $buku->description,
            ]);
        }

        $response = Http::get('https://www.googleapis.com/books/v1/volumes', [
            'q' => 'isbn:' . $id,
            'key' => config('google-book.google_books_api_key'),
        ]);

        if ($response->failed() || empty($response->json('items'))) {
            return $this->error('Book not found', 404);
        }

        $info = $response->json('items.0.volumeInfo');

        return $this->success('Buku ditemukan di Google Books API', [
            'isbn'        => $id,
            'title'       => $info['title'] ?? null,
            'author'      => $info['authors'][0] ?? null,
            'description' => $info['description'] ?? null,
            'coverImageUrl' => $info['imageLinks']['thumbnail'] ?? null,
        ]);
    }

    public function verifyBuku(Buku $buku)
    {
        $buku->update(['statusVerifikasi' => 'approved']);

        return $this->success('Buku berhasil diverifikasi', $buku->load('genres:id,name'));
    }
}
