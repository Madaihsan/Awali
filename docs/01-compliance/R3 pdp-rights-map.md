# R3 · Peta Hak Subjek Data UU PDP $\rightarrow$ Fitur Aplikasi AWALI

**Aplikasi:** AWALI (Absensi WAjah dan LokasI)  
**Landasan Hukum:** UU No. 27 Tahun 2022 tentang Pelindungan Data Pribadi (Bab IV: Hak Subjek Data Pribadi)  
**Aplikasi:** AWALI (Absensi WAjah dan LokasI)

**Penanggung jawab:** Az Zikra Farras Arsyaputra - 2300016091
 

---

## 1. Pemetaan Hak Subjek Data ke Fitur Aplikasi

| Hak Subjek Data (UU PDP) | Deskripsi Pasal | Fitur Konkret di Aplikasi AWALI | Req ID | Target Milestone |
|---|---|---|---|:---:|
| **Hak Informasi** (Pasal 5) | Pengguna berhak mengetahui tujuan pemrosesan data, pihak yang terlibat, dan akuntabilitas pengelola. | Halaman ringkas **"Kebijakan Privasi & Data"** yang dapat diakses langsung dari menu Profil/Pengaturan aplikasi sebelum atau sesudah login. | **`PRV-05`** | M03 – M04 |
| **Hak Koreksi** (Pasal 6) | Pengguna berhak memperbaiki kesalahan data pribadinya atau catatan kehadiran yang tidak akurat. | Fitur **"Ajukan Koreksi Presensi"** untuk pegawai yang mengalami kendala GPS/kamera dengan menyertakan keterangan dan bukti pendukung. | **`PRV-06`** | M04 |
| **Hak Akses & Salinan** (Pasal 7) | Pengguna berhak memperoleh akses dan salinan rekaman data kehadiran pribadinya. | Menu **"Ekspor Riwayat Presensi"** yang memungkinkan pegawai mengunduh data kehadirannya dalam format portabel (PDF/CSV ringkas). | **`PRV-04`** | M04 |
| **Hak Penghapusan / Pemusnahan** (Pasal 8) | Pengguna berhak meminta penghapusan data pribadi miliknya jika sudah tidak relevan (*Right to Erasure*). | Tombol **"Hapus Seluruh Data & Keluar"** di menu Privasi yang menghapus seluruh rekaman cache biometrik dan kredensial lokal (≤ 2 ketukan). | **`PRV-03`** | M04 |
| **Hak Tarik Persetujuan** (Pasal 9) | Pengguna berhak menarik kembali persetujuan pemrosesan data biometrik/lokasi. | Pengaturan sakelar izin perizinan di aplikasi dengan **status default MATI**, dan opsi untuk membatalkan izin kamera/lokasi sewaktu-waktu. | **`UX-02`** | M04 – M05 |
| **Hak Pengaduan & Keluhan** (Pasal 12) | Pengguna berhak mengajukan keberatan atau pengaduan atas pemrosesan data pribadi yang tidak sesuai. | Kanal kontak bantuan (*Helpdesk / Tim TI Kepegawaian*) yang dicantumkan secara jelas pada bagian bawah halaman Kebijakan Privasi. | **`PRV-05`** | M04 |

---

## 2. Catatan Kepatuhan Arsitektur
Pada arsitektur saat ini (M01–M04), implementasi hak-hak di atas dilakukan pada layer antarmuka dan basis data lokal (`SecureStorageService` & `AttendanceRepository.clear()`). Ketika integrasi cloud/backend diaktifkan pada M05, implementasi ini wajib terhubung ke endpoint API penghapusan data di server.
