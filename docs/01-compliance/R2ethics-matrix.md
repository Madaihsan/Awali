# R2 · Matriks Etika Profesi
**Aplikasi:** AWALI (Absensi WAjah dan LokasI)  
**Topik:** Presensi Pegawai  
**Kode Etik yang Digunakan:** **ACM Code of Ethics (2018)** dan **IEEE-CS Software Engineering Code of Ethics (1999)**  
**Penanggung Jawab:** Faishal Abyan  
**NIM:** 2338016159

---

## 1. Latar Belakang Pertimbangan Etika

Pengembangan aplikasi AWALI yang memproses data biometrik wajah dan koordinat lokasi pegawai menghadirkan dimensi etika yang kompleks. Di satu sisi, organisasi memiliki kepentingan yang sah dalam memastikan ketertiban kehadiran dan akuntabilitas kinerja pegawai. Di sisi lain, penerapan teknologi pengenalan wajah dan pelacakan lokasi berpotensi menimbulkan kekhawatiran terhadap privasi, pengawasan berlebih (*mass surveillance*), serta potensi diskriminasi algoritmik apabila tidak dirancang dengan bertanggung jawab.

Kami selaku tim pengembang menyadari bahwa setiap keputusan teknis dalam membangun sistem ini membawa konsekuensi etis. Oleh karena itu, register ini disusun sebagai komitmen tertulis bahwa desain dan implementasi AWALI dipandu oleh prinsip-prinsip etika profesi yang diakui secara internasional.

---

## 2. Matriks Prinsip Etika vs Risiko & Kontrol Aplikasi

| Sumber | Prinsip Etika | Risiko Potensial di Aplikasi AWALI | Kontrol Teknis / Kebijakan (ID) |
|---|---|---|---|
| **ACM 1.6** | **Hormati Privasi (*Respect Privacy*)** | Pengumpulan koordinat GPS secara terus-menerus di luar sesi presensi akan mengubah sistem absensi menjadi alat pengawasan mobilitas pegawai (*mobility tracking*) yang melampaui tujuan awal dan melanggar hak privasi pribadi. | **`PRV-01`**: Pengambilan koordinat GPS hanya bersifat sesaat (*point-in-time*) saat tombol presensi ditekan secara aktif oleh pengguna; tidak ada *background location tracking*. |
| **ACM 1.7** | **Jaga Kerahasiaan (*Honor Confidentiality*)** | Penyimpanan data biometrik wajah tanpa enkripsi membuka risiko ekstraksi data oleh aplikasi lain, proses backup ADB yang tidak terproteksi, atau eksploitasi celah keamanan perangkat yang dapat mengekspos data wajah pegawai secara permanen — data yang tidak dapat "diganti" seperti kata sandi. | **`SEC-01`**: Seluruh data sensitif termasuk vektor fitur biometrik wajib disimpan di `FlutterSecureStorage` yang berbasis Android Keystore hardware-backed. Foto wajah mentah tidak pernah ditulis ke penyimpanan persisten. |
| **ACM 1.3** | **Jujur dan Tepercaya (*Be Honest and Trustworthy*)** | Tanpa transparansi penuh, pegawai tidak mengetahui data apa saja yang dikumpulkan, ke mana data tersebut dikirim, dan berapa lama data disimpan. Aplikasi yang diam-diam mengaktifkan *remote sync* tanpa pemberitahuan merupakan bentuk pelanggaran kepercayaan yang serius. | **`PRV-05`**: Kebijakan privasi berbahasa Indonesia yang jelas dapat diakses langsung dari aplikasi. Sakelar `USE_REMOTE` dinonaktifkan secara default hingga M05, dan setiap pengaktifan fitur cloud wajib disertai pemberitahuan eksplisit kepada pengguna. |
| **ACM 2.5** | **Evaluasi Menyeluruh (*Give Comprehensive and Thorough Evaluations*)** | Algoritma deteksi wajah dapat menunjukkan performa yang tidak merata pada pegawai dengan warna kulit lebih gelap, menggunakan penutup kepala (hijab, peci), atau kacamata — kondisi yang umum dijumpai di lingkungan kerja Indonesia. Kegagalan sistematis pada kelompok tertentu berpotensi menimbulkan diskriminasi tidak langsung dalam pencatatan kehadiran. | **`UX-02`**: Wajib disediakan mekanisme presensi alternatif (misalnya pengajuan koreksi manual kepada admin/HRD) apabila sistem verifikasi wajah mengalami kegagalan teknis yang berulang pada pengguna tertentu. |
| **IEEE-CS 1.03** | **Kepentingan Publik (*Act Consistently with the Public Interest*)** | Kebocoran data biometrik dalam skala besar — misalnya akibat konfigurasi keamanan yang salah, tidak adanya enkripsi, atau celah pada proses penyimpanan cloud — dapat berdampak signifikan terhadap identitas digital seluruh pegawai yang terlibat dan berpotensi menimbulkan kerugian yang tidak dapat dipulihkan. | **`SEC-03`** & **`SEC-05`**: Menonaktifkan fitur backup otomatis (`allowBackup="false"`), melarang koneksi HTTP tanpa enkripsi (*cleartext*), dan memastikan seluruh komunikasi dengan server (M05) menggunakan TLS 1.3. |

---

## 3. Analisis Mendalam: Dilema Etis Utama Topik Presensi Pegawai

### 3.1 Hak Privasi Pekerja vs Kewajiban Ketertiban Kerja

Penerapan sistem presensi berbasis biometrik dan lokasi menghadirkan tegangan etis yang nyata antara dua kepentingan yang sama-sama sah:

- **Kepentingan Organisasi:** Memastikan akuntabilitas kehadiran, mengurangi potensi kecurangan presensi (*buddy punching* atau manipulasi lokasi), dan mempercepat proses administrasi kepegawaian.
- **Kepentingan Pekerja:** Hak atas privasi yang dijamin oleh UU Nomor 27 Tahun 2022 tentang Pelindungan Data Pribadi, hak atas kondisi kerja yang bebas dari pengawasan berlebih, serta hak-hak yang dijamin dalam UU Nomor 13 Tahun 2003 tentang Ketenagakerjaan.

UU Ketenagakerjaan Nomor 13/2003 mewajibkan pencatatan kehadiran yang akurat sebagai dasar administrasi hak cuti, lembur, dan pengupahan. Namun undang-undang yang sama juga mengharuskan penggunaan data tersebut secara proporsional dan tidak boleh dijadikan alat tekanan atau intimidasi terhadap pekerja. Oleh karena itu, desain AWALI membatasi diri hanya pada validasi kehadiran fisik di lokasi kantor pada momen presensi, dan tidak memperluas cakupan ke pemantauan aktivitas pegawai di luar jam kerja.

### 3.2 Risiko Diskriminasi Algoritmik

Sistem pengenalan wajah yang tidak dikalibrasi dengan cukup beragam data pelatihan berpotensi menghasilkan tingkat kesalahan (*false rejection rate* / FRR) yang lebih tinggi pada kelompok tertentu. Dalam konteks presensi pegawai, FRR yang tinggi pada kelompok tertentu berarti pegawai tersebut lebih sering ditolak sistem meskipun sebenarnya hadir secara fisik — sebuah bentuk diskriminasi tidak langsung yang harus diantisipasi sejak tahap desain. Kami berkomitmen menyediakan jalur eskalasi manual yang mudah diakses sebagai mitigasi terhadap risiko ini.

### 3.3 Ireversibilitas Data Biometrik

Berbeda dengan kata sandi yang dapat diganti setelah terjadi kebocoran, data biometrik wajah bersifat permanen dan melekat pada identitas seseorang seumur hidup. Konsekuensinya, standar perlindungan yang diterapkan harus lebih ketat dibanding data kredensial biasa. Prinsip "**tidak menyimpan lebih dari yang diperlukan, tidak lebih lama dari yang dibutuhkan**" menjadi fondasi utama pengelolaan data biometrik dalam sistem AWALI.

---

## 4. Komitmen Tim Pengembang

Berdasarkan analisis etika di atas, tim pengembang AWALI berkomitmen untuk:

1. Tidak pernah menggunakan data biometrik atau lokasi pegawai di luar tujuan verifikasi presensi yang telah dinyatakan secara eksplisit.
2. Memberikan informasi yang jujur, lengkap, dan mudah dipahami kepada pengguna mengenai seluruh data yang dikumpulkan dan cara pengelolaannya.
3. Menyediakan mekanisme alternatif yang adil bagi pengguna yang mengalami kegagalan teknis sistem biometrik.
4. Menerapkan standar keamanan teknis tertinggi yang memungkinkan sejak milestone pertama pengembangan.
5. Memperbarui penilaian etika ini pada setiap milestone yang membawa perubahan signifikan pada alur pemrosesan data.
