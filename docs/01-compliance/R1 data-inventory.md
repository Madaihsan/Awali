# R1 · Inventaris Data Pribadi
**Aplikasi:** AWALI (Absensi WAjah dan LokasI)  
**Topik:** Presensi Pegawai  
**Kelompok:** Kelompok 2 · Pemrograman Mobile SI UAD  

---

## 1. Tabel Inventaris Data

| Data | Kategori UU PDP (Ps. 4) | Tujuan Pemrosesan | Lokasi Simpan | Masa Retensi | Perlindungan Teknis |
|---|---|---|---|---|---|
| **Nama Pegawai** | Data Umum | Identifikasi profil pengguna pada antarmuka dan laporan kehadiran | Lokal (`AttendanceRecord`) / Cloud di M05 | Selama berstatus pegawai aktif | Pembatasan akses berbasis peran (*RBAC*) |
| **Nomor Induk Pegawai (NIP)** | Data Umum | Kredensial unik autentikasi akun kepegawaian | `FlutterSecureStorage` (Android Keystore / iOS Keychain) | Selama akun aktif | Enkripsi hardware Keystore (`SEC-01`) |
| **Foto Wajah / Fitur Biometrik** | **Data Spesifik** *(Sangat Sensitif)* | Verifikasi keabsahan identitas saat melakukan presensi masuk/pulang | Cache lokal terenkripsi / Penyimpanan aman perangkat | Maksimal 30 hari (atau diekstrak menjadi representasi nilai hash/vektor) | Enkripsi lokal, tidak diunggah sembarangan tanpa izin (`PRV-01`) |
| **Koordinat Lokasi (GPS)** | Data Umum (berkaitan dengan aktivitas) | Validasi apakah posisi fisik pegawai berada di dalam radius kantor (*geofencing*) | Tersimpan bersama catatan presensi | 1 tahun untuk audit kehadiran | Hanya diambil saat tombol presensi ditekan (*on-demand*), tanpa pelacakan latar belakang terus-menerus |
| **Waktu Presensi (*Timestamp*)** | Data Umum | Mencatat waktu kehadiran secara objektif | Basis data presensi lokal | 1 tahun ajaran | Integritas data waktu sistem |
| **PIN Aplikasi** | Kredensial Pengguna | Otorisasi pembukaan aplikasi / proteksi akses cepat | `FlutterSecureStorage` | Sampai diganti atau direset pengguna | Hashing PBKDF2 (120.000 iterasi) + salt acak 16-byte (`SEC-02`) |

---

## 2. Data yang TIDAK Dikumpulkan (Konfirmasi Eksplisit)
Untuk mencegah pengumpulan data berlebih (*data overcollection*), aplikasi AWALI secara tegas **TIDAK MENGUMPULKAN**:
- [x] **Daftar Kontak Telepon**
- [x] **Riwayat Pesan / SMS / Log Panggilan**
- [x] **Pelacakan Lokasi Latar Belakang (*Background Location*)** — Lokasi hanya diakses saat pengguna membuka layar presensi.
- [x] **File Media / Galeri Lainnya** — Kamera hanya mengambil gambar wajah baru secara instan, tidak mengakses galeri pribadi pengguna.
- [x] **Pengenal Iklan (*Advertising ID*) & Pelacak Pihak Ketiga**

---

## 3. Kebutuhan (Requirements) yang Lahir dari Register Ini
- **`PRV-01`**: Prinsip minimisasi data; aplikasi hanya mengumpulkan data yang mutlak diperlukan untuk proses verifikasi presensi.
- **`PRV-02`**: Larangan penggunaan SDK pelacak / analitik pihak ketiga yang mengirimkan data pengguna ke server eksternal tanpa persetujuan.
