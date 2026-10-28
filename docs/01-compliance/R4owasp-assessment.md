# R4 · Penilaian Risiko OWASP Mobile Top 10 (2024)

**Aplikasi:** AWALI (Absensi WAjah dan LokasI)  
**Topik:** Presensi Pegawai  
**Baseline Evaluasi:** OWASP Mobile Top 10 (2024 Release)
**Penanggung Jawab :** Faishal Abyan
**NIM :** 2338016159

---

## 1. Matriks Penilaian Risiko OWASP Mobile

| #       | Kategori Risiko OWASP                                           | Status di AWALI (M01)               | Kontrol Teknis & Rencana Mitigasi                                                                                                                     |    Req Terkait     |
| ------- | --------------------------------------------------------------- | ----------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------: |
| **M1**  | **Improper Credential Usage** (Kredensial Tidak Aman)           | ✅ **Terkontrol**                   | Tidak ada API key/secret yang ditulis _hardcoded_ di kode; token disimpan di Keystore via `SecureStorageService`.                                     | `SEC-01`, `SEC-04` |
| **M2**  | **Inadequate Supply Chain Security** (Rantai Pasok Lemah)       | ✅ **Terkontrol**                   | Mengunci seluruh versi dependensi dengan melakukan commit file `pubspec.lock`; menggunakan package resmi terverifikasi dari pub.dev.                  |      `SEC-04`      |
| **M3**  | **Insecure Authentication/Authorization** (Autentikasi Lemah)   | 🟡 **Direncanakan (M01/M04)**       | Autentikasi PIN lokal diperkuat dengan hashing salt acak dan pembatasan batas percobaan (_rate limiting_ / proteksi _brute force_).                   |      `SEC-02`      |
| **M4**  | **Insufficient Input/Output Validation** (Validasi Lemah)       | 🟡 **Direncanakan (M04)**           | Validasi ketat format NIP, koordinat rentang lintang/bujur Indonesia, dan penolakan payload form yang tidak wajar.                                    |      `SEC-03`      |
| **M5**  | **Insecure Communication** (Komunikasi Tidak Aman)              | ✅ **Terkonfigurasi**               | Dikonfigurasi `network_security_config.xml` dengan aturan `cleartextTrafficPermitted="false"`. Seluruh komunikasi cloud wajib HTTPS TLS 1.3 pada M05. | `SEC-05`, `SEC-06` |
| **M6**  | **Inadequate Privacy Controls** (Kontrol Privasi Minim)         | ✅ **Terkontrol**                   | Minimisasi pengumpulan data (tidak meminta izin kontak/SMS/background GPS); izin kamera dan lokasi hanya diminta saat akan presensi.                  | `PRV-01`, `PRV-02` |
| **M7**  | **Insufficient Binary Protections** (Perlindungan Biner Kurang) | 🟡 **Direncanakan (Release Build)** | Menjalankan _obfuscation_ saat proses _build release_ Android (`--obfuscate --split-debug-info`) untuk mencegah _reverse engineering_.                |      `SEC-03`      |
| **M8**  | **Security Misconfiguration** (Konfigurasi Salah)               | ✅ **Terkontrol**                   | Konfigurasi `android:allowBackup="false"` di AndroidManifest, aturan linter `avoid_print: true`, dan mode debug dinonaktifkan di rilis.               |      `SEC-03`      |
| **M9**  | **Insecure Data Storage** (Penyimpanan Data Tidak Aman)         | ✅ **Terkontrol**                   | Menggunakan `FlutterSecureStorage` (bukan SharedPreferences biasa tanpa enkripsi) untuk menyimpan NIP, status PIN, dan sesi token.                    |      `SEC-01`      |
| **M10** | **Insufficient Cryptography** (Kriptografi Lemah)               | ✅ **Terkontrol**                   | Menggunakan algoritma **PBKDF2 HMAC-SHA256** dengan 120.000 iterasi dan komparasi waktu konstan untuk verifikasi PIN; larangan keras MD5/SHA1 polos.  |      `SEC-02`      |

---

## 2. Risiko Spesifik & Khas pada Topik Presensi Pegawai

1. **Manipulasi Lokasi (_Mock Location / Fake GPS_):**  
   _Risiko:_ Pegawai memanipulasi lokasi GPS agar tampak berada di kantor padahal berada di rumah.  
   _Mitigasi:_ Melakukan verifikasi flag `isMocked` dari API geolocator pada Android dan mengecek akurasi horizontal koordinat.
2. **Pemalsuan Wajah (_Biometric Spoofing / Photo Attack_):**  
   _Risiko:_ Pegawai melakukan presensi dengan mengarahkan kamera ke foto cetak atau layar smartphone lain.  
   _Mitigasi:_ Peringatan panduan pengambilan wajah langsung dan direncanakan deteksi kedipan/gerakan sederhana (_liveness detection_).
