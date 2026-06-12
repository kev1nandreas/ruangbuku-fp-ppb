<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreBukuRequest;
use App\Http\Requests\UpdateBukuRequest;
use App\Models\Buku;
use App\Models\Peminjaman;
use Illuminate\Support\Facades\Http;

class BukuController extends Controller
{
    public function index()
    {
        $startDate = request()->query('start_date');
        $endDate   = request()->query('end_date');
        $userId    = request()->query('user_id');
        $statusVerifikasi = request()->query('status_verifikasi');
        $isPublic    = request()->query('is_public');

        $query = Buku::query()
            ->with(['genres:id,name', 'users:id,name']);

        if ($statusVerifikasi) {
            $query->where('statusVerifikasi', $statusVerifikasi);
        }

        if (isset($isPublic)) {
            $query->whereHas('users', fn($q) => $q->wherePivot('isPublic', filter_var($isPublic, FILTER_VALIDATE_BOOLEAN)));
        }

        // Check the book's availability for the given date range if both dates are provided.
        if ($startDate && $endDate) {
            $query->whereDoesntHave('peminjamans', fn($q) =>
                $q->where('status', Peminjaman::ACTIVE_STATUSES)
                    ->where('start_date', '<=', $endDate)
                    ->where('end_date', '>=', $startDate)
            );
        }

        if ($userId) {
            $query->whereHas('users', fn($q) => $q->whereKey($userId));
        }

        return $this->success('Daftar buku berhasil dimuat', $query->get());
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
        $validated = $request->validated();
        $userId    = $request->user()->id;

        // Verify user owns the book before updating
        if (!$buku->users()->wherePivot('user_id', $userId)->exists()) {
            return $this->error('Buku ini tidak berada di koleksi Anda', 403);
        }

        if (isset($validated['isPublic'])) {
            $isPublic = $validated['isPublic'];
            $buku->users()->updateExistingPivot($userId, ['isPublic' => $isPublic]);
            
            // If they are making it public and it was private, it needs verification
            if ($isPublic && $buku->statusVerifikasi === 'private') {
                $buku->update(['statusVerifikasi' => 'need_verification']);
            } elseif (!$isPublic) {
                // If they make it private, maybe we don't change verification status, or we revert it to private
                $buku->update(['statusVerifikasi' => 'private']);
            }
        }

        $buku->update(array_diff_key($validated, ['isPublic' => null, 'genre_ids' => null]));

        if (isset($validated['genre_ids'])) {
            $buku->genres()->sync($validated['genre_ids']);
        }

        return $this->success('Buku berhasil diperbarui', $buku->load('genres:id,name'));
    }

    public function destroy(Buku $buku)
    {
        $userId = request()->user()->id;

        // Verify user owns the book
        if (!$buku->users()->wherePivot('user_id', $userId)->exists()) {
            return $this->error('Buku ini tidak berada di koleksi Anda', 403);
        }

        // Detach the user from the book
        $buku->users()->detach($userId);

        // If no one owns the book anymore, delete it physically
        if ($buku->users()->count() === 0) {
            $buku->delete();
        }

        return $this->success('Buku berhasil dihapus dari koleksi Anda');
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
