# Katalog Kebutuhan Kepatuhan (Compliance Requirements Catalog)
**Aplikasi:** AWALI (Absensi WAjah dan LokasI)  
**Tujuan:** Mengonsolidasi seluruh ID requirement non-fungsional dari register privasi, etika, dan keamanan untuk dibawa ke dokumen Spesifikasi Kebutuhan Perangkat Lunak (SRS) pada Milestone M02.  
**Penanggung Jawab:** M. Yusuf Ardabili_230016156

---

## 1. Kebutuhan Privasi & Pengalaman Pengguna (PRV-xx, UX-xx)

| ID Kebutuhan | Deskripsi Kebutuhan (*Requirement*) | Landasan / Sumber | Target Milestone |
|:---:|---|---|:---:|
| **`PRV-01`** | **Minimisasi Data:** Aplikasi hanya mengumpulkan data yang mutlak diperlukan untuk verifikasi presensi (NIP, foto wajah saat presensi, dan koordinat instan tanpa pelacakan latar belakang). | UU PDP Ps. 4 / R1 Data Inventory | M01 – M04 |
| **`PRV-02`** | **Bebas SDK Pihak Ketiga:** Tidak menyertakan library pelacak iklan (*Ad SDK*) atau analitik pihak ketiga yang berpotensi membocorkan data pengguna. | Kebijakan Etika / R1 Data Inventory | M01 – M05 |
| **`PRV-03`** | **Hak Penghapusan Data (*Right to Erasure*):** Pengguna dapat menghapus seluruh riwayat presensi lokal dan data sesi dalam $\le 2$ ketukan dari menu pengaturan. | UU PDP Ps. 8 / R3 PDP Rights Map | M04 |
| **`PRV-04`** | **Hak Akses & Portabilitas:** Pengguna dapat melihat dan mengekspor riwayat presensi pribadinya dalam format dokumen portabel. | UU PDP Ps. 7 / R3 PDP Rights Map | M04 |
| **`PRV-05`** | **Transparansi Kebijakan Privasi:** Teks kebijakan privasi berbahasa Indonesia yang mudah dipahami wajib dapat diakses langsung dari antarmuka aplikasi. | UU PDP Ps. 5 & 12 / R6 Privacy Policy | M03 – M04 |
| **`PRV-06`** | **Mekanisme Hak Koreksi:** Sediakan alur pengajuan koreksi presensi bagi pegawai jika terjadi anomali GPS atau kesalahan deteksi wajah. | UU PDP Ps. 6 / R3 PDP Rights Map | M04 |
| **`UX-01`** | **Bebas Dark Pattern:** Seluruh desain antarmuka wajib lulus pengujian audit dark pattern pada setiap rilis rute/layar baru. | R5 Dark Pattern Audit | M03 – M05 |
| **`UX-02`** | **Izin Default Mati & Hak Tarik:** Izin akses kamera dan lokasi berstatus default MATI sebelum diminta secara transparan; izin dapat ditarik kembali sewaktu-waktu. | UU PDP Ps. 9 / R5 Dark Pattern Audit | M04 – M05 |
| **`UX-03`** | **Standar Aksesibilitas:** Desain antarmuka mematuhi standar ukuran teks $\ge 14\text{sp}$, kontras warna WCAG AA, dan label aksesibilitas tombol. | Panduan Desain / R5 Dark Pattern Audit | M03 – M04 |

---

## 2. Kebutuhan Keamanan Sistem (SEC-xx)

| ID Kebutuhan | Deskripsi Kebutuhan (*Requirement*) | Landasan / Sumber | Target Milestone |
|:---:|---|---|:---:|
| **`SEC-01`** | **Penyimpanan Kredensial Terenkripsi:** Penyimpanan NIP, token sesi, dan konfigurasi keamanan wajib menggunakan `FlutterSecureStorage` (berbasis Android Keystore / iOS Keychain). | OWASP M9 / P05 | M01 |
| **`SEC-02`** | **Pengamanan Kriptografi PIN:** PIN aplikasi wajib di-hash menggunakan algoritma KDF **PBKDF2** (120.000 iterasi, HMAC-SHA256, salt 16-byte) dengan verifikasi waktu konstan. | OWASP M1 & M10 / P05 | M01 |
| **`SEC-03`** | **Konfigurasi Keamanan Platform:** Menonaktifkan fitur backup otomatis (`android:allowBackup="false"`) dan menerapkan aturan linter `avoid_print: true` untuk mencegah kebocoran log. | OWASP M8 / P05 | M01 |
| **`SEC-04`** | **Proteksi Rantai Pasok & Repositori:** Mengunci versi dependensi via `pubspec.lock` dan mencegah kebocoran file sensitif (`.env`, keystore, key.properties) via `.gitignore`. | OWASP M1 & M2 / P05 | M01 |
| **`SEC-05`** | **Larangan Komunikasi Cleartext:** Mengonfigurasi `network_security_config.xml` untuk melarang koneksi HTTP tanpa enkripsi TLS/SSL di mode produksi. | OWASP M5 / P05 | M01 & M05 |
| **`SEC-06`** | **Prinsip Izin Minimal (*Least Privilege*):** Tidak menambahkan izin jaringan (`INTERNET`) pada AndroidManifest sampai sistem cloud benar-benar diintegrasikan di M05. | OWASP M5 & M6 / P05 | M01 & M05 |
