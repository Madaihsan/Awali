# R5 · Audit Dark Pattern
**Aplikasi:** AWALI (Absensi WAjah dan LokasI)  
**Tujuan:** Memastikan antarmuka pengguna tidak memanipulasi, menjebak, atau mempersulit pegawai dalam mengambil keputusan terkait privasi dan kendali data pribadinya.  

---

## 1. Matriks Audit Dark Pattern

| Kategori Pola (*Dark Pattern*) | Pertanyaan Pengujian pada Rilis | Standar yang Diterapkan di Aplikasi AWALI | Status Audit |
|---|---|---|:---:|
| **Pre-selected Options** (Pilihan Tercentang Otomatis) | Apakah ada kotak centang atau sakelar izin yang sudah aktif secara otomatis demi kepentingan sistem? | Seluruh sakelar perizinan data opsional berada dalam **status default MATI**. Pengguna harus secara sadar mengaktifkannya sendiri. | ✅ **Lulus** |
| **Trick Questions** (Pertanyaan Menjebak) | Apakah kalimat pada dialog perizinan atau konfirmasi dapat ditafsirkan ganda atau membingungkan? | Menggunakan kalimat afirmatif tunggal yang lugas dan transparan. Contoh: *"Izinkan akses kamera untuk memverifikasi wajah presensi?"* (bukan kalimat negasi ganda). | ✅ **Lulus** |
| **Roach Motel** (Mudah Masuk, Sulit Keluar) | Apakah proses keluar (*logout*) atau penghapusan data akun jauh lebih sulit dibanding proses registrasi/login? | Menu hapus sesi dan pembersihan riwayat lokal tersedia langsung di menu Pengaturan Privasi dan dapat diselesaikan dalam **≤ 2 ketukan**. | ✅ **Lulus** |
| **Confirmshaming** (Mempermalukan Pengguna) | Apakah teks pada tombol penolakan membuat pengguna merasa bersalah atau bodoh? | Tombol penolakan atau pembatalan menggunakan kata netral dan objektif: *"Batal"* atau *"Nanti Saja"*, bukan kalimat manipulatif. | ✅ **Lulus** |
| **Privacy Zuckering** (Menyembunyikan Opsi Privasi) | Apakah pengaturan privasi dan kebijakan data disembunyikan di balik menu berlapis yang rumit? | Semua pengaturan privasi, hak data, dan penjelasan penggunaan kamera/lokasi dikelompokkan dalam satu layar terpusat **"Privasi & Data"**. | ✅ **Lulus** |
| **Forced Action** (Tindakan Terpaksa Berlebih) | Apakah aplikasi memaksa pengguna memberikan izin yang tidak relevan dengan presensi (misal: kontak atau galeri)? | Aplikasi hanya meminta izin Kamera dan Lokasi saat fitur presensi akan digunakan. Jika ditolak, aplikasi memberikan edukasi tanpa memblokir seluruh akses informasi umum. | ✅ **Lulus** |

---

## 2. Kebutuhan (Requirements) yang Lahir dari Register Ini
- **`UX-01`**: Aplikasi wajib lulus evaluasi audit dark pattern pada setiap rilis milestone.
- **`UX-02`**: Seluruh perizinan fitur opsional berstatus default MATI dan persetujuan dapat ditarik kembali oleh pengguna sewaktu-waktu.
- **`UX-03`**: Standar aksesibilitas antarmuka: ukuran teks minimum 14sp, rasio kontras warna memenuhi standar WCAG AA, dan kontrol utama memiliki label deskriptif.
