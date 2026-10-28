# Kebijakan Privasi — AWALI (Absensi WAjah dan LokasI)
**Versi M01 · Oktober 2026** *(Fase Penyimpanan Lokal — Belum Ada Transmisi Cloud)*  
**Penanggung jawab:** Andang Purwanto - 2300016104

---

Tim pengembang **AWALI** berkomitmen penuh untuk menjaga privasi dan keamanan data pribadi seluruh pengguna sistem ini. Dokumen ini menjelaskan secara transparan jenis data yang dikelola oleh aplikasi AWALI, cara penyimpanannya, hak-hak yang dimiliki oleh pengguna atas data tersebut, serta langkah-langkah perlindungan yang kami terapkan. Kebijakan ini berlaku mulai dari versi M01 dan akan diperbarui secara transparan pada setiap milestone yang membawa perubahan signifikan terhadap cara pengelolaan data.

---

### 1. Data yang Kami Kelola

Aplikasi AWALI hanya mengumpulkan dan memproses data yang benar-benar diperlukan untuk mendukung fungsi pencatatan kehadiran. Berikut adalah rincian data yang kami kelola:

- **Identitas Akun Kepegawaian:** Nomor Induk Pegawai (NIP) dan nama lengkap digunakan untuk memastikan catatan kehadiran tercatat atas nama pegawai yang bersangkutan secara akurat.
- **Data Lokasi GPS:** Koordinat posisi perangkat diambil secara sesaat pada saat pengguna menekan tombol presensi. Data ini digunakan semata-mata untuk memverifikasi bahwa pegawai berada di dalam area kantor yang telah ditentukan (*geofencing*). Aplikasi AWALI **tidak melacak lokasi pengguna di latar belakang** setelah proses presensi selesai.
- **Vektor Fitur Biometrik Wajah:** Aplikasi menggunakan kamera perangkat untuk mengambil gambar wajah saat proses presensi berlangsung. Gambar tersebut diproses secara lokal untuk menghasilkan representasi matematis berupa vektor fitur (*face embedding*). **Foto wajah mentah tidak disimpan secara permanen**; yang tersimpan hanyalah vektor fitur dalam format terenkripsi.
- **PIN Keamanan Aplikasi:** PIN yang ditetapkan oleh pengguna digunakan untuk melindungi akses ke aplikasi di perangkat. PIN ini tidak disimpan dalam bentuk teks biasa, melainkan dalam bentuk hash kriptografis menggunakan algoritma PBKDF2 dengan salt acak.
- **Catatan Waktu Presensi (*Timestamp*):** Waktu masuk dan pulang dicatat secara otomatis oleh sistem sebagai dasar rekap administrasi kehadiran.

---

### 2. Lokasi Penyimpanan Data

Pada versi M01 ini, **seluruh data pengguna disimpan secara lokal di dalam perangkat pengguna masing-masing**. Tidak ada data yang dikirimkan ke server eksternal atau layanan cloud pada versi ini.

- Informasi sensitif seperti NIP, PIN, dan vektor fitur biometrik diamankan menggunakan teknologi enkripsi perangkat keras bawaan sistem operasi (*Android Keystore / iOS Keychain*).
- Data catatan presensi disimpan dalam basis data lokal yang hanya dapat diakses melalui antarmuka aplikasi AWALI.
- Kami tidak terhubung ke server atau cloud eksternal mana pun pada versi M01. Seluruh pemrosesan data berlangsung sepenuhnya di dalam perangkat pengguna.

---

### 3. Pihak yang Dapat Mengakses Data

- **Pengguna Sendiri:** Pegawai hanya dapat mengakses data riwayat kehadiran pribadinya melalui antarmuka aplikasi yang terautentikasi.
- **Admin / HRD:** Dengan kewenangan yang telah ditetapkan, admin dapat mengakses data kehadiran pegawai dalam lingkup tanggung jawabnya melalui antarmuka pengelola.
- **Tim Pengembang AWALI:** Tidak memiliki akses terhadap data pengguna yang tersimpan di perangkat. Penyimpanan data bersifat lokal dan tidak dapat diakses dari jarak jauh.
- Kami tidak pernah menjual, menyewakan, membagikan, atau mentransfer data pribadi pengguna kepada pihak ketiga, pengiklan, atau entitas lain yang tidak memiliki kewenangan yang sah.

---

### 4. Hak Pengguna atas Data Pribadi

Sesuai dengan Undang-Undang Nomor 27 Tahun 2022 tentang Pelindungan Data Pribadi (UU PDP), setiap pengguna aplikasi AWALI memiliki hak-hak berikut:

- **Hak Memperoleh Informasi (Pasal 5):** Pengguna berhak mengetahui jenis data yang dikumpulkan, tujuan pemrosesannya, dan pihak yang bertanggung jawab atas pengelolaannya. Informasi ini tersedia secara lengkap dalam dokumen kebijakan privasi yang dapat diakses langsung dari menu Pengaturan aplikasi.
- **Hak Mengakses dan Memperoleh Salinan (Pasal 7):** Pengguna dapat melihat seluruh riwayat catatan presensi pribadinya kapan saja melalui menu "Riwayat Presensi" di aplikasi.
- **Hak Meminta Koreksi (Pasal 6):** Apabila terjadi anomali data akibat kendala teknis GPS atau deteksi wajah, pengguna dapat mengajukan permintaan koreksi presensi kepada bagian administrasi atau HRD melalui fitur yang disediakan.
- **Hak Penghapusan Data (Pasal 8 — *Right to Erasure*):** Pengguna dapat menghapus seluruh data presensi lokal, data sesi, dan data biometrik yang tersimpan di perangkat secara permanen melalui menu **"Hapus Seluruh Data"** di Pengaturan Privasi. Proses ini dapat diselesaikan dalam tidak lebih dari dua ketukan dan bersifat tidak dapat dibatalkan.
- **Hak Menarik Persetujuan (Pasal 9):** Izin akses kamera dan lokasi yang telah diberikan dapat ditarik kembali kapan saja melalui pengaturan izin aplikasi di sistem operasi perangkat.

---

### 5. Langkah-Langkah Perlindungan Teknis

Sebagai bentuk tanggung jawab teknis, kami menerapkan kontrol keamanan berikut:

- **Enkripsi Berbasis Hardware:** Kredensial dan data sensitif dilindungi oleh Android Keystore / iOS Keychain — sistem enkripsi yang didukung oleh chip keamanan perangkat keras perangkat.
- **Tidak Ada Foto Wajah Permanen:** Gambar wajah yang diambil selama proses presensi hanya hidup di memori sementara dan dihapus segera setelah proses ekstraksi fitur selesai.
- **Tidak Ada Pelacakan Latar Belakang:** Izin lokasi hanya aktif selama pengguna berada di layar presensi dan dinonaktifkan segera setelahnya.
- **Tanpa SDK Pihak Ketiga:** Aplikasi tidak mengandung library iklan, analitik, atau pelacak (*tracker*) pihak ketiga yang dapat membocorkan data pengguna.
- **Pemblokiran Koneksi Tidak Aman:** Konfigurasi `network_security_config.xml` memastikan aplikasi tidak dapat melakukan koneksi HTTP tanpa enkripsi (*cleartext*).

---

### 6. Perubahan Kebijakan di Masa Mendatang

Apabila pada milestone selanjutnya (M05) aplikasi menambahkan fitur sinkronisasi data dengan server terpusat atau layanan cloud, pengguna akan menerima pemberitahuan pembaruan kebijakan privasi yang jelas dan transparan **sebelum** fitur tersebut diaktifkan. Persetujuan eksplisit pengguna akan diminta sebelum data apa pun dikirimkan ke luar perangkat.

---

### 7. Hubungi Kami

Apabila terdapat pertanyaan, masukan, atau keberatan mengenai pengelolaan data pribadi dalam aplikasi AWALI, tim pengembang dapat dihubungi melalui:

- **Unit Pengelola:** Tim Kepegawaian & Pengembang AWALI, Universitas Ahmad Dahlan
- **Kanal Pengaduan Formal:** Bagian Kepegawaian UAD (untuk penanganan keberatan yang berkaitan dengan hak-hak data pribadi sesuai UU PDP)
