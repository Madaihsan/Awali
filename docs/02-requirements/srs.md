# Spesifikasi Kebutuhan Perangkat Lunak (SRS Ringkas)
## Software Requirements Specification — AWALI
**Aplikasi:** AWALI (Absensi WAjah dan LokasI) — Presensi Pegawai  
**Milestone:** M02 — Spesifikasi Kebutuhan & Desain Arsitektur (`m02-spec`)  
**Versi Dokumen:** 1.0 · November 2026  
**Kelompok:** Kelompok 2 · Pemrograman Mobile SI UAD  

---

## 1. Pendahuluan

### 1.1 Tujuan Dokumen
Dokumen Spesifikasi Kebutuhan Perangkat Lunak (*Software Requirements Specification* - SRS) ini bertujuan untuk mendefinisikan seluruh kebutuhan fungsional dan non-fungsional aplikasi mobile **AWALI** secara formal, terstruktur, dan dapat diuji (*testable*). Dokumen ini menjadi acuan utama bagi pengembang, perancang antarmuka (UI/UX), dan penguji perangkat lunak dalam merealisasikan Milestone M03 (Desain Figma), M04 (Frontend Flutter), dan M05 (Integrasi Data).

### 1.2 Ruang Lingkup Produk
**AWALI** adalah aplikasi presensi pegawai berbasis mobile *cross-platform* (Flutter) yang menggabungkan validasi lokasi berbasis geofencing GPS dan verifikasi biometrik wajah. Pada tahap M01–M04, aplikasi bekerja dengan arsitektur penyimpanan lokal terenkripsi (*offline-first*) yang aman, cepat, dan patuh terhadap regulasi UU No. 27 Tahun 2022 tentang Pelindungan Data Pribadi (UU PDP).

### 1.3 Definisi dan Singkatan
* **FR (*Functional Requirement*):** Kebutuhan fungsional sistem yang mendeskripsikan layanan atau perilaku spesifik yang disediakan aplikasi.
* **NFR (*Non-Functional Requirement*):** Kebutuhan non-fungsional yang mendeskripsikan batasan kualitas sistem (keamanan, privasi, performa, dan kegunaan).
* **Geofencing:** Pembatasan perimeter geografis virtual di sekitar koordinat fisik kantor dengan toleransi radius tertentu (ditetapkan sebesar 50 meter).
* **Face Embedding:** Vektor fitur numerik matematis yang merepresentasikan karakteristik wajah, bukan citra foto mentah.
* **KDF (*Key Derivation Function*):** Algoritma kriptografis (PBKDF2) untuk menghasilkan kunci hash yang aman dari input PIN pengguna.

---

## 2. Deskripsi Umum Sistem

### 2.1 Perspektif Produk & Batasan Lingkungan
Aplikasi beroperasi pada perangkat smartphone pegawai dengan sistem operasi Android (API level minimum 21). Pada Milestone M01–M04, seluruh data kehadiran dan kredensial disimpan pada basis data lokal dan penyimpanan aman hardware Keystore perangkat. Integrasi remote database (Firebase Firestore / Cloud API) disimulasikan pada Milestone M05.

### 2.2 Karakteristik dan Hak Akses Pengguna
1. **Pegawai (*Primary User*):** Memiliki hak untuk login, membuat/memasukkan PIN, melakukan presensi masuk dan pulang, melihat riwayat kehadiran pribadi, melihat kebijakan privasi, serta menghapus seluruh data lokal miliknya (*Right to Erasure*).
2. **Admin Kepegawaian / HRD (*Secondary User*):** Memiliki hak tambahan untuk memantau ringkasan statistik kehadiran harian dan mengekspor rekapitulasi data kehadiran dalam format portabel.

---

## 3. Kebutuhan Fungsional (Functional Requirements — FR)

| ID Kebutuhan | Nama Kebutuhan | Deskripsi Detail | Masukan (*Input*) | Keluaran (*Output*) | Prioritas MoSCoW | Status M02 |
|:---:|---|---|---|---|:---:|:---:|
| **`FR-01`** | **Autentikasi Akun Pegawai** | Sistem memvalidasi identitas akun pegawai berdasarkan Nomor Induk Pegawai (NIP). | NIP pegawai | Sesi aktif pengguna tersimpan di secure storage | **Must Have** | Selesai (Fondasi M01) |
| **`FR-02`** | **Proteksi PIN Aplikasi** | Sistem memverifikasi PIN lokal menggunakan algoritma hashing PBKDF2 dengan salt acak 16-byte untuk membuka kunci aplikasi. | 4–6 digit angka PIN | Akses layar terbuka / pesan penolakan PIN salah | **Must Have** | Selesai (`PinService`) |
| **`FR-03`** | **Validasi Geofencing GPS** | Sistem mengambil koordinat posisi perangkat saat presensi dan memeriksa apakah berada dalam radius $\le 50$ meter dari koordinat kantor serta memastikan posisi bukan hasil rekayasa Fake GPS. | Koordinat GPS (Latitude, Longitude) | Status lokasi valid / di luar area kantor | **Must Have** | Dirancang (M02) |
| **`FR-04`** | **Verifikasi Wajah (Face Detection)** | Sistem mengaktifkan kamera depan untuk mendeteksi keberadaan wajah valid (confidence $\ge 80\%$) dan mengekstrak representasi nilai fitur numerik secara lokal. | Tangkapan citra kamera depan | Status wajah terverifikasi / gagal deteksi | **Must Have** | Dirancang (M02) |
| **`FR-05`** | **Pencatatan Presensi Masuk & Pulang** | Sistem mencatat waktu kehadiran secara objektif, menyematkan stempel waktu (*timestamp*), metode verifikasi, dan status kehadiran (Hadir/Terlambat). | Konfirmasi tombol presensi | Objek `AttendanceRecord` tersimpan di repository | **Must Have** | Dirancang (M02) |
| **`FR-06`** | **Riwayat Presensi Pribadi** | Sistem menyajikan daftar catatan presensi milik pegawai yang sedang aktif secara kronologis dari yang terbaru. | Permintaan menu riwayat | Tampilan daftar riwayat presensi | **Must Have** | Dirancang (M02) |
| **`FR-07`** | **Monitoring Rekapitulasi (HRD)** | Sistem menyajikan ringkasan persentase kehadiran pegawai dan menyediakan opsi ekspor data kehadiran ke format dokumen portabel. | Permintaan filter periode rekap | Tampilan dashboard statistik & file rekapitulasi | **Should Have** | Dirancang (M02) |
| **`FR-08`** | **Penghapusan Data Mandiri (Right to Erasure)** | Sistem menyediakan opsi pemusnahan seluruh riwayat presensi lokal dan data kredensial dalam $\le 2$ ketukan dari menu pengaturan sesuai UU PDP Pasal 8. | Konfirmasi dialog hapus data | Data lokal terhapus total, state provider di-reset | **Must Have** | Dirancang (`PRV-03`) |

---

## 4. Kebutuhan Non-Fungsional (Non-Functional Requirements — NFR)

Seluruh kebutuhan non-fungsional diturunkan dari Register Kepatuhan M01 (`docs/01-compliance/requirements-catalog.md`) untuk memastikan aspek privasi, keamanan, dan pengalaman pengguna terpenuhi secara konsisten:

### 4.1 Kebutuhan Privasi & Etika Pengguna (PRV-xx & UX-xx)

| ID NFR | Deskripsi Kebutuhan | Kriteria Kepatuhan & Dasar Regulasi | Target Milestone | Status Kepatuhan |
|:---:|---|---|:---:|:---:|
| **`PRV-01`** | **Minimisasi Data (*Data Minimisation*)** | Aplikasi dilarang menyimpan foto wajah mentah secara persisten (hanya menyimpan vektor numerik) dan tidak melacak GPS di latar belakang. | UU PDP Ps. 4 & Prinsip Privacy by Design | M01–M04 | Terpenuhi pada dokumen R1 & arsitektur model |
| **`PRV-02`** | **Bebas SDK Pelacak Pihak Ketiga** | Aplikasi tidak menggunakan library analitik, iklan, atau tracker eksternal yang mengekstrak data identitas ke server pihak ketiga. | Kode Etik ACM 1.6 & IAII Ps. 5 | M01–M05 | Terpenuhi (pubspec bersih dari Ad/Tracker SDK) |
| **`PRV-03`** | **Hak Penghapusan Data (*Right to Erasure*)** | Pengguna dapat menghapus seluruh rekaman data pribadinya di perangkat dalam $\le 2$ ketukan melalui menu Pengaturan Privasi. | UU PDP Ps. 8 | M04 | Terdefinisi di `FR-08` dan kontrak arsitektur `clearAll()` |
| **`PRV-04`** | **Hak Akses & Portabilitas Data** | Pengguna dapat melihat dan mengekspor salinan data catatan kehadirannya dalam format portabel. | UU PDP Ps. 7 | M04 | Terdefinisi di `FR-07` |
| **`PRV-05`** | **Transparansi Kebijakan Privasi** | Teks Kebijakan Privasi berbahasa Indonesia yang formal dan transparan wajib dapat diakses langsung dari antarmuka aplikasi secara offline. | UU PDP Ps. 5 | M03–M04 | Tersedia di dokumen `R6` dan dirancang pada layar Settings |
| **`PRV-06`** | **Mekanisme Hak Koreksi** | Pengguna diberikan kanal pengajuan koreksi presensi apabila terjadi anomali teknis pada sensor GPS atau kamera. | UU PDP Ps. 6 | M04 | Terdefinisi dalam alur `US-08` |
| **`UX-01`** | **Bebas Dark Pattern** | Antarmuka pengguna wajib lulus evaluasi audit 6 pola dark pattern pada setiap rilis layar baru. | Audit R5 | M03–M05 | Terpenuhi di Register R5 |
| **`UX-02`** | **Izin Default Mati & Hak Tarik** | Seluruh sakelar fitur dan izin data berstatus default MATI sebelum diminta secara sadar oleh pengguna; izin dapat ditarik sewaktu-waktu. | UU PDP Ps. 9 | M04–M05 | Terpenuhi di spesifikasi alur izin |
| **`UX-03`** | **Standar Aksesibilitas Antarmuka** | Ukuran teks minimum 14sp, rasio kontras warna memenuhi standar WCAG AA, dan kontrol interaktif memiliki label yang jelas. | Pedoman Desain Aksesibilitas | M03–M04 | Diterapkan pada `AppTheme` token |

### 4.2 Kebutuhan Keamanan Sistem (SEC-xx)

| ID NFR | Deskripsi Kebutuhan | Standar Teknis | Target Milestone | Status Kepatuhan |
|:---:|---|---|:---:|:---:|
| **`SEC-01`** | **Penyimpanan Kredensial Terenkripsi Hardware** | Token sesi, NIP, dan vektor biometrik disimpan menggunakan `FlutterSecureStorage` berbasis Android Keystore / iOS Keychain. | OWASP Mobile M9 | M01 | Terverifikasi via screenshot bukti `SEC-01` |
| **`SEC-02`** | **Pengamanan Kriptografi KDF PBKDF2** | PIN aplikasi di-hash menggunakan algoritma PBKDF2 (120.000 iterasi, HMAC-SHA256, salt 16-byte) dengan verifikasi waktu konstan. | OWASP Mobile M1 & M10 | M01 | Terimplementasi di `PinService` |
| **`SEC-03`** | **Konfigurasi Keamanan Platform Android** | Penonaktifan backup otomatis (`android:allowBackup="false"`) dan penerapan aturan linter `avoid_print: true`. | OWASP Mobile M8 | M01 | Terverifikasi di `AndroidManifest.xml` & `sec-03-lint.txt` |
| **`SEC-04`** | **Proteksi Rantai Pasok Dependensi** | Penguncian versi paket via `pubspec.lock` dan penyaringan file rahasia melalui `.gitignore`. | OWASP Mobile M2 | M01 | Terverifikasi di Git log |
| **`SEC-05`** | **Larangan Komunikasi Cleartext HTTP** | Pemblokiran seluruh lalu lintas data HTTP tanpa enkripsi melalui berkas `network_security_config.xml`. | OWASP Mobile M5 | M01 & M05 | Terverifikasi di `sec-06-permissions.txt` |
| **`SEC-06`** | **Prinsip Izin Minimal (*Least Privilege*)** | Nihil izin jaringan `INTERNET` pada fase offline-first M01 sampai integrasi remote diaktifkan di M05. | OWASP Mobile M6 | M01 & M05 | Terverifikasi di `sec-06-permissions.txt` |

---

## 5. Kriteria Kinerja dan Performa
* **Waktu Alur Presensi:** Waktu yang dibutuhkan pegawai sejak menekan tombol presensi, validasi koordinat lokasi, hingga pengambilan deteksi wajah selesai tercatat adalah **$\le 10$ detik**.
* **Kecepatan Buka Kunci PIN:** Verifikasi PIN lokal harus selesai dalam waktu **$< 1$ detik**.
* **Toleransi Radius Geofencing:** Jarak maksimum kehadiran yang diakui sistem adalah **50 meter** dari titik koordinat kantor.
