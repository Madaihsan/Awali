# R1 · Inventaris Data Pribadi
**Aplikasi:** AWALI (Absensi WAjah dan LokasI)  
**Topik:** Presensi Pegawai  
**Kelompok:** Kelompok 2 · Pemrograman Mobile SI UAD  
**Penanggung jawab:** Az Zikra Farras Arsyaputra - 2300016091

---

## 1. Tabel Inventaris Data

Tabel berikut mendokumentasikan seluruh kategori data pribadi yang dikumpulkan, diproses, dan disimpan oleh aplikasi AWALI. Penyusunan inventaris ini mengacu pada Pasal 4 UU Nomor 27 Tahun 2022 tentang Pelindungan Data Pribadi (UU PDP), yang membedakan antara **data pribadi yang bersifat umum** dan **data pribadi yang bersifat spesifik**.

| Data | Kategori UU PDP (Ps. 4) | Tujuan Pemrosesan | Lokasi Simpan | Masa Retensi | Perlindungan Teknis |
|---|---|---|---|---|---|
| **Nama Pegawai** | Data Umum | Identifikasi profil pengguna pada antarmuka dan laporan kehadiran | Lokal (`AttendanceRecord`) / Cloud di M05 | Selama berstatus pegawai aktif | Pembatasan akses berbasis peran (*RBAC*) |
| **Nomor Induk Pegawai (NIP)** | Data Umum | Kredensial unik autentikasi akun kepegawaian | `FlutterSecureStorage` (Android Keystore / iOS Keychain) | Selama akun aktif | Enkripsi hardware Keystore (`SEC-01`) |
| **Vektor Fitur Biometrik Wajah** | **Data Spesifik** *(Sangat Sensitif — UU PDP Ps. 4 huruf b)* | Verifikasi keabsahan identitas pegawai saat melakukan presensi masuk/pulang. **Catatan penting:** Aplikasi AWALI **tidak menyimpan foto wajah mentah secara permanen**. Proses pengambilan gambar melalui kamera hanya bersifat sementara (*in-memory*) untuk diekstraksi menjadi representasi matematis berupa vektor fitur (*face embedding*). Gambar mentah dihapus dari memori secara otomatis setelah proses ekstraksi selesai. | Vektor fitur tersimpan dalam basis data lokal terenkripsi di perangkat pengguna | Sesuai masa aktif keanggotaan pegawai, atau dihapus atas permintaan pengguna melalui fitur *Right to Erasure* (`PRV-03`) | (1) Penyimpanan terenkripsi berbasis hardware Keystore; (2) gambar mentah tidak pernah ditulis ke penyimpanan persisten; (3) tidak diunggah ke server tanpa persetujuan eksplisit (`PRV-01`, `SEC-01`) |
| **Koordinat Lokasi GPS** | Data Umum (berkaitan dengan aktivitas kepegawaian) | Validasi apakah posisi fisik pegawai berada di dalam radius area kantor yang ditentukan (*geofencing*) pada saat presensi berlangsung | Tersimpan sebagai bagian dari catatan presensi (*AttendanceRecord*) di basis data lokal | 1 tahun untuk keperluan audit kehadiran | Koordinat hanya diambil secara sesaat (*point-in-time on-demand*) saat tombol presensi ditekan; tidak ada pelacakan lokasi latar belakang (`PRV-01`) |
| **Waktu Presensi (*Timestamp*)** | Data Umum | Mencatat waktu kehadiran masuk dan pulang secara objektif sebagai dasar laporan administrasi kepegawaian | Basis data presensi lokal | 1 tahun ajaran | Integritas data waktu sistem; tidak dapat dimodifikasi oleh pengguna biasa |
| **PIN Aplikasi** | Kredensial Keamanan | Otorisasi pembukaan sesi aplikasi sebagai lapisan keamanan tambahan untuk melindungi akses data presensi di perangkat | `FlutterSecureStorage` (berbasis Android Keystore / iOS Keychain) | Sampai diganti atau direset oleh pengguna yang bersangkutan | Hashing menggunakan algoritma **PBKDF2-HMAC-SHA256** dengan 120.000 iterasi dan salt acak 16-byte; verifikasi menggunakan perbandingan waktu-konstan untuk mencegah *timing attack* (`SEC-02`) |

---

## 2. Penjelasan Perlakuan Data Biometrik

Mengingat data biometrik wajah termasuk dalam kategori **data pribadi spesifik** yang mendapat perlindungan lebih ketat berdasarkan UU PDP Pasal 4, tim pengembang AWALI menerapkan prinsip-prinsip berikut:

1. **Minimisasi Pemrosesan (*Data Minimisation*):** Kamera hanya diaktifkan saat alur presensi dimulai oleh pengguna secara aktif. Tidak ada pengambilan gambar di latar belakang.
2. **Tidak Menyimpan Foto Mentah (*No Raw Image Persistence*):** Gambar hasil tangkapan kamera hanya hidup di memori RAM selama proses ekstraksi fitur berlangsung, kemudian dihapus secara otomatis. Yang tersimpan secara persisten hanyalah *face embedding vector* dalam format terenkripsi.
3. **Enkripsi Penyimpanan Lokal:** Vektor fitur disimpan di lapisan penyimpanan aman perangkat yang didukung enkripsi hardware (*Android Keystore / iOS Secure Enclave*), sehingga tidak dapat dibaca oleh aplikasi lain maupun melalui proses backup ADB biasa.
4. **Hak Penghapusan (*Right to Erasure*):** Pengguna dapat menghapus seluruh data biometrik tersimpan melalui fitur "Hapus Seluruh Data" yang dapat diakses dalam ≤ 2 ketukan dari menu pengaturan (`PRV-03`).

---

## 3. Data yang TIDAK Dikumpulkan (Konfirmasi Eksplisit)

Sebagai perwujudan prinsip minimisasi data, aplikasi AWALI secara tegas **tidak mengumpulkan** data-data berikut yang tidak relevan dengan fungsi pencatatan kehadiran:

- [x] **Foto wajah mentah secara permanen** — Gambar tangkapan kamera hanya bersifat sementara di memori dan tidak pernah ditulis ke penyimpanan persisten.
- [x] **Pelacakan lokasi latar belakang (*Background Location Tracking*)** — Izin lokasi hanya aktif saat pengguna secara aktif membuka layar presensi.
- [x] **Daftar Kontak Telepon**
- [x] **Riwayat Pesan / SMS / Log Panggilan**
- [x] **File Media / Galeri Lainnya** — Kamera hanya mengambil gambar wajah secara instan melalui antarmuka aplikasi, tidak mengakses galeri pribadi.
- [x] **Pengenal Iklan (*Advertising ID*) & SDK Pelacak Pihak Ketiga**
- [x] **Data Keuangan / Rekening Bank**

---

## 4. Kebutuhan (Requirements) yang Lahir dari Register Ini

| ID Requirement | Deskripsi | Milestone |
|---|---|:---:|
| **`PRV-01`** | Prinsip minimisasi data: aplikasi hanya mengumpulkan data yang mutlak diperlukan untuk proses verifikasi presensi, tanpa redundansi pengumpulan. | M01–M04 |
| **`PRV-02`** | Larangan penggunaan SDK pelacak atau analitik pihak ketiga yang berpotensi mengirimkan data pengguna ke server eksternal tanpa persetujuan eksplisit. | M01–M05 |
| **`PRV-03`** | Pengguna dapat menghapus seluruh data lokal termasuk vektor biometrik dan riwayat presensi dalam ≤ 2 ketukan melalui menu pengaturan (*Right to Erasure*). | M04 |
| **`SEC-01`** | Seluruh data sensitif termasuk vektor fitur biometrik dan kredensial NIP wajib disimpan menggunakan `FlutterSecureStorage` berbasis Android Keystore / iOS Keychain. | M01 |
