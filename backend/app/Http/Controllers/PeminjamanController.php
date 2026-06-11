<?php

namespace App\Http\Controllers;

use App\Http\Requests\ReportDamageRequest;
use App\Http\Requests\ResolveDamageRequest;
use App\Http\Requests\ReturnDepositRequest;
use App\Http\Requests\StorePeminjamanRequest;
use App\Http\Requests\SubmitDepositRequest;
use App\Models\Buku;
use App\Models\Peminjaman;
use App\Services\PeminjamanNotifier;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PeminjamanController extends Controller
{
    public function __construct(
        private readonly PeminjamanNotifier $notifier,
    ) {}

    public function index(Request $request): JsonResponse
    {
        $userId = Auth::id();

        $query = Peminjaman::query()
            ->with(['buku:id,title,author,coverImageUrl', 'user:id,name,email'])
            ->latest('created_at');

        if ($request->query('as') === 'owner') {
            $query->whereHas('buku.users', fn($q) => $q->whereKey($userId));
        } else {
            $query->where('user_id', $userId);
        }

        if ($status = $request->query('status')) {
            $query->where('status', $status);
        }

        return $this->success('Daftar peminjaman berhasil dimuat', $query->get());
    }

    public function store(StorePeminjamanRequest $request): JsonResponse
    {
        $validated = $request->validated();
        $userId    = Auth::id();

        $buku = Buku::query()->findOrFail($validated['buku_id']);

        // A user cannot borrow their own book.
        if ($buku->users()->whereKey($userId)->exists()) {
            return $this->error('Kamu tidak bisa meminjam bukumu sendiri', [], 422);
        }

        // Rule: user may not have more than one active borrow.
        $activeCount = Peminjaman::query()
            ->where('user_id', $userId)
            ->where('status', Peminjaman::ACTIVE_STATUSES)
            ->count('id');

        if ($activeCount >= 1) {
            return $this->error('Kamu masih memiliki peminjaman aktif, selesaikan terlebih dahulu', [], 422);
        }

        // Rule: requested dates must not overlap another active borrow of this book.
        if ($this->hasDateOverlap($buku->id, $validated['start_date'], $validated['end_date'])) {
            return $this->error('Tanggal yang dipilih bertabrakan dengan peminjaman lain', [], 422);
        }

        $peminjaman = Peminjaman::create([
            'buku_id'    => $buku->id,
            'user_id'    => $userId,
            'start_date' => $validated['start_date'],
            'end_date'   => $validated['end_date'],
            'status'     => Peminjaman::STATUS_PENDING,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return $this->created('Pengajuan peminjaman berhasil dibuat', $peminjaman->load('buku:id,title,author'));
    }

    public function show(Peminjaman $peminjaman): JsonResponse
    {
        $this->authorizeParticipant($peminjaman);

        return $this->success('Detail peminjaman', $peminjaman->load([
            'buku:id,title,author,coverImageUrl',
            'user:id,name,email',
            'kerusakan',
        ]));
    }

    public function approve(Peminjaman $peminjaman): JsonResponse
    {
        $this->authorizeOwner($peminjaman);
        $this->assertStatus($peminjaman, Peminjaman::STATUS_PENDING);

        $peminjaman->update([
            'status'      => Peminjaman::STATUS_WAITING_DEPOSIT,
            'verified_at' => now(),
            'updated_at'  => now(),
        ]);

        $this->notifier->notifyBorrower(
            $peminjaman,
            'Peminjaman disetujui',
            'Pengajuanmu disetujui. Silakan kirim bukti deposit untuk melanjutkan.',
        );

        return $this->success('Peminjaman disetujui, menunggu deposit', $peminjaman);
    }

    public function reject(Peminjaman $peminjaman): JsonResponse
    {
        $this->authorizeOwner($peminjaman);
        $this->assertStatus($peminjaman, Peminjaman::STATUS_PENDING);

        $peminjaman->update([
            'status'     => Peminjaman::STATUS_REJECTED,
            'updated_at' => now(),
        ]);

        $this->notifier->notifyBorrower(
            $peminjaman,
            'Peminjaman ditolak',
            'Maaf, pengajuan peminjamanmu ditolak oleh pemilik buku.',
        );

        return $this->success('Peminjaman ditolak', $peminjaman);
    }

    public function submitDeposit(SubmitDepositRequest $request, Peminjaman $peminjaman): JsonResponse
    {
        $this->authorizeBorrower($peminjaman);
        $this->assertStatus($peminjaman, Peminjaman::STATUS_WAITING_DEPOSIT);

        $peminjaman->update([
            'buktiDeposit' => $request->validated()['buktiDeposit'],
            'updated_at'   => now(),
        ]);

        $this->notifier->notifyOwner(
            $peminjaman,
            'Bukti deposit dikirim',
            'Peminjam telah mengirim bukti deposit dan menunggu konfirmasi admin.',
        );

        return $this->success('Deposit dikirim, menunggu konfirmasi admin', $peminjaman);
    }

    public function confirmDeposit(Peminjaman $peminjaman): JsonResponse
    {
        $this->assertStatus($peminjaman, Peminjaman::STATUS_WAITING_DEPOSIT);

        if (is_null($peminjaman->buktiDeposit)) {
            return $this->error('Borrower belum mengirim deposit', [], 422);
        }

        $peminjaman->update([
            'status'              => Peminjaman::STATUS_DEPOSIT_RECEIVED,
            'deposit_received_at' => now(),
            'updated_at'          => now(),
        ]);

        $this->notifier->notifyBorrower(
            $peminjaman,
            'Deposit dikonfirmasi',
            'Depositmu telah dikonfirmasi admin. Silakan koordinasi pengambilan buku.',
        );

        return $this->success('Deposit diterima', $peminjaman);
    }

    public function handOver(Peminjaman $peminjaman): JsonResponse
    {
        $this->authorizeBorrower($peminjaman);
        $this->assertStatus($peminjaman, Peminjaman::STATUS_DEPOSIT_RECEIVED);

        $peminjaman->update([
            'status'         => Peminjaman::STATUS_BOOK_RECEIVED,
            'handed_over_at' => now(),
            'updated_at'     => now(),
        ]);

        $this->notifier->notifyOwner(
            $peminjaman,
            'Buku telah diterima peminjam',
            'Peminjam mengonfirmasi telah menerima bukumu.',
        );

        return $this->success('Buku diterima oleh peminjam', $peminjaman);
    }

    public function confirmReturn(Peminjaman $peminjaman): JsonResponse
    {
        $this->authorizeOwner($peminjaman);
        $this->assertStatus($peminjaman, Peminjaman::STATUS_BOOK_RECEIVED);

        $peminjaman->update([
            'status'      => Peminjaman::STATUS_RETURNED,
            'returned_at' => now(),
            'updated_at'  => now(),
        ]);

        $this->notifier->notifyBorrower(
            $peminjaman,
            'Pengembalian buku dikonfirmasi',
            'Pemilik mengonfirmasi buku kembali dalam kondisi baik. Deposit akan dikembalikan admin.',
        );

        return $this->success('Buku dikembalikan dalam kondisi baik, menunggu pengembalian deposit oleh admin', $peminjaman);
    }

    public function reportDamage(ReportDamageRequest $request, Peminjaman $peminjaman): JsonResponse
    {
        $this->authorizeOwner($peminjaman);
        $this->assertStatus($peminjaman, Peminjaman::STATUS_BOOK_RECEIVED);

        $validated = $request->validated();

        $peminjaman->kerusakan()->create([
            'description' => $validated['damage_description'],
            'photos'      => $validated['damage_photos'],
            'reported_at' => now(),
        ]);

        $peminjaman->update([
            'status'      => Peminjaman::STATUS_DAMAGED,
            'returned_at' => now(),
            'updated_at'  => now(),
        ]);

        $this->notifier->notifyBorrower(
            $peminjaman,
            'Kerusakan buku dilaporkan',
            'Pemilik melaporkan buku dalam kondisi rusak. Admin akan meninjau dan menyelesaikan deposit.',
        );

        return $this->success('Kerusakan buku dilaporkan, menunggu verifikasi admin', $peminjaman->load('kerusakan'));
    }

    public function returnDeposit(ReturnDepositRequest $request, Peminjaman $peminjaman): JsonResponse
    {
        $this->assertStatus($peminjaman, Peminjaman::STATUS_RETURNED);

        $validated = $request->validated();

        $peminjaman->update([
            'status'              => Peminjaman::STATUS_COMPLETED,
            'deposit_returned_to' => Peminjaman::DEPOSIT_TO_BORROWER,
            'deposit_proof_url'   => $validated['deposit_proof_url'] ?? null,
            'resolution_note'     => $validated['resolution_note'] ?? null,
            'deposit_returned_at' => now(),
            'resolved_by'         => Auth::id(),
            'updated_at'          => now(),
        ]);

        $this->notifier->notifyBorrower(
            $peminjaman,
            'Deposit dikembalikan',
            'Depositmu telah dikembalikan. Peminjaman selesai. Terima kasih!',
        );

        return $this->success('Deposit dikembalikan ke peminjam, peminjaman selesai', $peminjaman);
    }

    public function resolveDamage(ResolveDamageRequest $request, Peminjaman $peminjaman): JsonResponse
    {
        $this->assertStatus($peminjaman, Peminjaman::STATUS_DAMAGED);

        $validated = $request->validated();

        $peminjaman->update([
            'status'              => Peminjaman::STATUS_COMPLETED,
            'deposit_returned_to' => $validated['resolution'],
            'deposit_proof_url'   => $validated['deposit_proof_url'] ?? null,
            'resolution_note'     => $validated['resolution_note'],
            'deposit_returned_at' => now(),
            'resolved_by'         => Auth::id(),
            'updated_at'          => now(),
        ]);

        $recipient = $validated['resolution'] === Peminjaman::DEPOSIT_TO_OWNER ? 'pemilik' : 'peminjam';

        $this->notifier->notifyBorrower(
            $peminjaman,
            'Kerusakan diselesaikan',
            "Laporan kerusakan diselesaikan. Deposit dikembalikan ke {$recipient}. Peminjaman selesai.",
        );
        $this->notifier->notifyOwner(
            $peminjaman,
            'Kerusakan diselesaikan',
            "Laporan kerusakan diselesaikan. Deposit dikembalikan ke {$recipient}. Peminjaman selesai.",
        );

        return $this->success(
            "Kerusakan diselesaikan, deposit dikembalikan ke {$recipient}, peminjaman selesai",
            $peminjaman->load('kerusakan'),
        );
    }

    // --- helpers ---------------------------------------------------------

    private function hasDateOverlap(string $bukuId, string $start, string $end): bool
    {
        return Peminjaman::query()
            ->where('buku_id', $bukuId)
            ->where('status', Peminjaman::ACTIVE_STATUSES)
            ->where('start_date', '<=', $end)
            ->where('end_date', '>=', $start)
            ->exists();
    }

    private function assertStatus(Peminjaman $peminjaman, string $expected): void
    {
        if ($peminjaman->status !== $expected) {
            abort(response()->json([
                'status'  => false,
                'message' => "Aksi tidak valid untuk status \"{$peminjaman->status}\"",
                'error'   => ['expected_status' => $expected],
            ], 422));
        }
    }

    private function authorizeOwner(Peminjaman $peminjaman): void
    {
        if (!$peminjaman->isOwnedBy(Auth::id())) {
            abort(403, 'Hanya pemilik buku yang dapat melakukan aksi ini.');
        }
    }

    private function authorizeBorrower(Peminjaman $peminjaman): void
    {
        if ($peminjaman->user_id !== Auth::id()) {
            abort(403, 'Hanya peminjam yang dapat melakukan aksi ini.');
        }
    }

    private function authorizeParticipant(Peminjaman $peminjaman): void
    {
        if ($peminjaman->user_id !== Auth::id() || !$peminjaman->isOwnedBy(Auth::id())) {
            abort(403, 'Kamu tidak memiliki akses ke peminjaman ini.');
        }
    }
}
