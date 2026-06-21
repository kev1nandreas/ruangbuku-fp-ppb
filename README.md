# Final Project Pemrograman Perangkat Bergerak - RuangBuku

**Kelompok 5**

| Nama | NRP |
| :--- | :--- |
| Kevin Andreas | 5025231168 |
| Ryan Marvin Sirait | 5025231215 |
| Muhammad Aditya Handrian | 5025231292 |

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