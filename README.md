# Final Project Pemrograman Perangkat Bergerak - RuangBuku

**Kelompok 5**

| Nama | NRP |
| :--- | :--- |
| [Isi Nama Anggota 1 di sini] | [Isi NRP Anggota 1 di sini] |
| [Isi Nama Anggota 2 di sini] | [Isi NRP Anggota 2 di sini] |
| [Isi Nama Anggota 3 di sini] | [Isi NRP Anggota 3 di sini] |

---

# Dokumen Spesifikasi Bisnis, Fungsional, dan Teknikal
## Sistem Manajemen Perpustakaan Komunitas (P2P Book Sharing Platform)

Dokumen ini memberikan penjelasan mendalam mengenai aspek bisnis, fungsional, dan teknikal dari sistem berdasarkan tiga alur utama: Pendaftaran Buku, Peminjaman Buku, dan Pengembalian Buku.

---

## 1. PENJELASAN BISNIS (BUSINESS ARCHITECTURE)

### 1.1 Latar Belakang & Nilai Bisnis (Value Proposition)
Sistem ini dirancang sebagai platform berbagi buku berbasis komunitas (*Peer-to-Peer Book Sharing*). Platform ini mempertemukan pemilik buku (Pemilik) dengan orang yang ingin membaca buku (Peminjam) dengan difasilitasi oleh Admin komunitas sebagai penengah pihak ketiga yang tepercaya (*trusted third-party*). 

Nilai bisnis utama meliputi:
* **Optimalisasi Aset:** Mengubah koleksi buku pribadi yang menganggur menjadi utilitas sosial/komunitas.
* **Keamanan Transaksi:** Mekanisme deposit finansial yang dikelola Admin memastikan Pemilik buku mendapatkan kompensasi jika terjadi kerusakan atau kehilangan.
* **Kepercayaan Komunitas:** Integrasi dengan WhatsApp untuk diskusi dan validasi manual memastikan adanya interaksi sosial yang sehat antar anggota.

### 1.2 Aturan Bisnis (Business Rules)
Berikut adalah aturan bisnis ketat (*hard rules*) yang diterapkan dalam sistem:
1.  **Batasan Peminjaman:** Seorang peminjam hanya diperbolehkan meminjam **maksimal 1 buku** dalam satu waktu aktif. Peminjaman baru hanya dapat diajukan jika transaksi sebelumnya berstatus *Selesai* atau *Dibatalkan*.
2.  **Validasi Ketersediaan Tanggal:** Tanggal peminjaman yang diajukan tidak boleh tumpang tindih (*overlap*) dengan jadwal peminjaman pengguna lain untuk buku yang sama.
3.  **SLA Pembayaran Deposit:** Peminjam wajib melakukan pembayaran deposit dalam waktu **maksimal 24 jam (< 1 hari)** setelah pemilik menyetujui peminjaman. Jika terlewati, sistem secara otomatis membatalkan pengajuan.
4.  **SLA Penyerahan Buku:** Pemilik wajib menyerahkan buku kepada peminjam dalam waktu **maksimal 3 hari** setelah deposit diverifikasi oleh Admin.
5.  **Perlindungan Aset (Deposit):** Deposit akan dikembalikan 100% jika buku kembali dalam kondisi baik. Jika buku cacat/rusak, deposit akan dipotong berdasarkan tingkat kerusakan yang diverifikasi oleh Admin, dan sisanya baru dikembalikan ke Peminjam.

---

## 2. PENJELASAN FUNGSIONAL (FUNCTIONAL SPECIFICATION)

### 2.1 Matriks Peran dan Hak Akses (Role-Permission Matrix)
| Peran (Actor) | Deskripsi Fungsional |
| :--- | :--- |
| **Pengaju / Pemilik** | Mendaftarkan buku, mengelola koleksi pribadi/publik, menyetujui/menolak peminjaman, memeriksa kondisi buku saat kembali, mengisi form kerusakan. |
| **Peminjam** | Mencari buku, mengajukan peminjaman, membayar deposit, melakukan konfirmasi penerimaan, mengembalikan buku. |
| **Admin** | Memverifikasi kelayakan buku untuk publik, memverifikasi pembayaran deposit, memverifikasi kompensasi kerusakan buku, melakukan transfer pengembalian deposit. |

### 2.2 Detail Alur Kerja Fungsional (Functional Workflow)

#### F-01: Alur Pendaftaran Buku
* **Pemicu (*Trigger*):** Pengaju ingin memasukkan data buku ke dalam sistem.
* **Langkah Fungsional:**
    1.  Sistem menyediakan input berbasis nomor **ISBN**. Sistem dapat mengintegrasikan API pihak ketiga (misal: Google Books API) untuk otomatis mengisi *metadata* buku (Judul, Penulis, Penerbit, Cover).
    2.  Pengaju memilih opsi visibilitas: **Koleksi Pribadi** atau **Dipinjamkan ke Publik**.
    3.  Jika dipilih "Koleksi Pribadi", buku langsung masuk ke katalog privat pengguna tanpa moderasi.
    4.  Jika dipilih "Dipinjamkan ke Publik", status buku menjadi *Menunggu Verifikasi*. Admin akan menerima notifikasi di dashboard untuk melakukan kurasi fisik/konten.
    5.  Jika Admin menyetujui, status berubah menjadi *Koleksi Publik* (dapat dicari oleh user lain). Jika ditolak, otomatis turun status menjadi *Koleksi Pribadi*.

#### F-02: Alur Peminjaman Buku
* **Pemicu (*Trigger*):** Peminjam mencari dan menemukan buku yang ingin dibaca.
* **Langkah Fungsional:**
    1.  Peminjam melakukan pencarian kata kunci. Sistem memvalidasi parameter: status peminjaman aktif user == 0, dan tanggal booking bebas konflik.
    2.  Peminjam menekan tombol "Ajukan Peminjaman". Pemilik mendapatkan notifikasi.
    3.  Jika Pemilik menolak, alur berakhir. Jika menyetujui, sistem membuka *deep-link* ke WhatsApp untuk diskusi logistik (metode penyerahan, lokasi, dll).
    4.  Pemilik menandai "Setuju di WA" pada sistem, merubah status transaksi menjadi `Menunggu Deposit`.
    5.  Peminjam mengunggah bukti transfer deposit melalui sistem (SLA 24 jam).
    6.  Admin memvalidasi mutasi rekening. Jika valid, status diubah menjadi `Deposit Diterima`.
    7.  Pemilik menyerahkan buku (SLA 3 hari). Setelah peminjam menerima fisik buku, peminjam menekan tombol "Buku Diterima" di aplikasi. Status berubah menjadi `Sedang Dipinjam`.

#### F-03: Alur Pengembalian Buku
* **Pemicu (*Trigger*):** Masa pinjam berakhir atau peminjam ingin mengembalikan buku.
* **Langkah Fungsional:**
    1.  Peminjam berkoordinasi via WhatsApp untuk mengembalikan fisik buku ke Pemilik.
    2.  Pemilik menerima buku dan melakukan inspeksi visual.
    3.  **Skenario A (Kondisi Baik):** Pemilik memilih opsi "Kondisi Baik". Status berubah menjadi `Sudah Dikembalikan`. Admin mendapatkan perintah untuk *refund* deposit penuh.
    4.  **Skenario B (Kondisi Cacat):** Pemilik memilih opsi "Buku Cacat" dan wajib mengisi **Form Kerusakan Buku** (deskripsi kerusakan dan unggah foto bukti). Admin melakukan investigasi, menentukan nilai denda, memotong deposit, dan mentransfer sisanya ke Peminjam.

---

## 3. PENJELASAN TEKNIKAL (TECHNICAL ARCHITECTURE)

### 3.1 Skema Model Data / Entitas (Database Schema)
Berikut adalah rancangan basis data relasional logis untuk mendukung alur di atas:

~~~sql
-- Tabel Pengguna (Aktor)
CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    whatsapp_number VARCHAR(20) NOT NULL,
    role ENUM('USER', 'ADMIN') DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel Buku
CREATE TABLE books (
    book_id VARCHAR(50) PRIMARY KEY,
    owner_id VARCHAR(50),
    isbn VARCHAR(13) NOT NULL,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100),
    visibility ENUM('PRIVATE', 'PUBLIC') DEFAULT 'PRIVATE',
    verification_status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    FOREIGN KEY (owner_id) REFERENCES users(user_id)
);

-- Tabel Transaksi Peminjaman
CREATE TABLE borrowings (
    borrowing_id VARCHAR(50) PRIMARY KEY,
    book_id VARCHAR(50),
    borrower_id VARCHAR(50),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM(
        'REQUESTED', 'WAITING_DEPOSIT', 'DEPOSIT_RECEIVED', 
        'BOOK_RECEIVED', 'RETURNED_GOOD', 'RETURNED_DAMAGED', 
        'COMPLETED', 'CANCELLED'
    ) DEFAULT 'REQUESTED',
    deposit_amount DECIMAL(10,2) NOT NULL,
    payment_proof_url VARCHAR(255),
    deposit_status ENUM('UNPAID', 'PAID', 'REFUNDED', 'PARTIALLY_REFUNDED') DEFAULT 'UNPAID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (borrower_id) REFERENCES users(user_id)
);

-- Tabel Laporan Kerusakan Buku
CREATE TABLE damage_reports (
    report_id VARCHAR(50) PRIMARY KEY,
    borrowing_id VARCHAR(50),
    description TEXT NOT NULL,
    photo_url VARCHAR(255) NOT NULL,
    deduction_amount DECIMAL(10,2) DEFAULT 0.00,
    admin_decision TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (borrowing_id) REFERENCES borrowings(borrowing_id)
);
~~~

### 3.2 Desain API Endpoints
Seluruh komunikasi frontend-backend menggunakan arsitektur RESTful API dengan format JSON.

#### Kelompok: Manajemen Buku
* `POST /api/v1/books` (Pendaftaran Buku)
    * Payload: `{ "isbn": "9786020331607", "visibility": "PUBLIC" }`
* `PATCH /api/v1/admin/books/:id/verify` (Verifikasi Buku oleh Admin)
    * Payload: `{ "status": "APPROVED" }`

#### Kelompok: Transaksi Peminjaman
* `POST /api/v1/borrowings` (Pengajuan Peminjaman)
    * Payload: `{ "book_id": "B001", "start_date": "2026-06-05", "end_date": "2026-06-12" }`
    * *Validation logic:* Cek jika user memiliki transaksi berstatus selain `COMPLETED`/`CANCELLED`. Cek irisan tanggal di tabel `borrowings`.
* `PATCH /api/v1/borrowings/:id/owner-approval` (Persetujuan Pemilik)
    * Payload: `{ "approved": true }` (Jika true, status berubah menjadi `WAITING_DEPOSIT`).
* `PUT /api/v1/borrowings/:id/payment` (Upload Bukti Deposit oleh Peminjam)
    * Multipart Form-Data: `payment_proof_file`
* `PATCH /api/v1/admin/borrowings/:id/verify-payment` (Verifikasi Bayar oleh Admin)
    * Payload: `{ "is_valid": true }` (Mengubah status menjadi `DEPOSIT_RECEIVED`).
* `PATCH /api/v1/borrowings/:id/receive-book` (Konfirmasi Buku Diterima Peminjam)
    * Payload: `{}` (Mengubah status menjadi `BOOK_RECEIVED`).

#### Kelompok: Pengembalian Buku
* `POST /api/v1/borrowings/:id/returns` (Proses Cek Kondisi oleh Pemilik)
    * Payload Skenario Baik: `{ "condition": "GOOD" }`
    * Payload Skenario Rusak: `{ "condition": "DAMAGED", "description": "Halaman 12-15 robek", "photo_base64": "..." }`
* `PATCH /api/v1/admin/borrowings/:id/resolve-dispute` (Keputusan Finansial Admin untuk Buku Rusak)
    * Payload: `{ "deduction_amount": 50000, "decision_note": "Biaya penggantian cover" }`

### 3.3 State Machine Transaksi (Status Lifecycle)
Untuk menjaga integritas data, status peminjaman dikelola secara ketat melalui state machine berikut:

~~~text
[REQUESTED] ──(Owner Approves)──> [WAITING_DEPOSIT]
     │                                   │
(Owner Rejects)                 (SLA 24 Jam Timeout)
     │                                   │
     ▼                                   ▼
[CANCELLED]                         [CANCELLED]

[WAITING_DEPOSIT] ──(Proof Uploaded & Admin Verifies)──> [DEPOSIT_RECEIVED]

[DEPOSIT_RECEIVED] ──(Book Handed Over & User Confirms)──> [BOOK_RECEIVED]

[BOOK_RECEIVED] ──(Return Checked - Good)────> [RETURNED_GOOD] ───(Admin Refund)──> [COMPLETED]
                ──(Return Checked - Damaged)─> [RETURNED_DAMAGED] ─(Admin Deduct)─> [COMPLETED]
~~~

### 3.4 Proses Otomatisasi & Sistem Latar Belakang (Cron Jobs/Workers)
Sistem memerlukan mekanisme background worker (misalnya menggunakan Redis/BullMQ atau Celery) untuk menangani aturan berbasis waktu (SLA):

1.  **Job: `ExpiryCheckDeposit` (Berjalan setiap jam)**
    * **Query:** Mencari transaksi dengan status `WAITING_DEPOSIT` yang `created_at` telah melewati 24 jam dari waktu sekarang.
    * **Aksi:** Mengubah status transaksi menjadi `CANCELLED`, mengembalikan kuota peminjaman user, dan memperbarui status ketersediaan tanggal buku.
2.  **Job: `SLAHandoverReminder` (Berjalan setiap hari)**
    * **Query:** Mencari transaksi berstatus `DEPOSIT_RECEIVED` yang sudah berjalan lebih dari 2 hari tetapi belum diubah ke `BOOK_RECEIVED`.
    * **Aksi:** Mengirimkan notifikasi pengingat otomatis via sistem/WhatsApp gateway ke Pemilik untuk segera menyerahkan buku sebelum batas waktu 3 hari terlampaui.
