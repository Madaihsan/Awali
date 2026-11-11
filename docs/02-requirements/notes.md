# Catatan Elisitasi Kebutuhan Sistem (Elicitation Notes)
**Aplikasi:** AWALI (Absensi WAjah dan LokasI) — Presensi Pegawai  
**Milestone:** M02 — Spesifikasi Kebutuhan & Desain Arsitektur (`m02-spec`)  
**Kelompok:** Kelompok 2 · Pemrograman Mobile Sistem Informasi UAD (2026/2027 Gasal)  
**Penyusun:** Tim Pengembang AWALI  

---

## 1. Pendahuluan & Metodologi Elisitasi

Elisitasi kebutuhan dilakukan untuk menggali permasalahan nyata pada sistem pencatatan kehadiran yang sedang berjalan saat ini (*existing system*) serta memetakan kebutuhan objektif seluruh pemangku kepentingan (*stakeholders*). Proses pengumpulan informasi dilakukan melalui wawancara mendalam semi-terstruktur (*semi-structured in-depth interview*) kepada tiga perwakilan persona yang mewakili ekosistem kepegawaian institusi:

1. **Narasumber 1 (Pengguna Langsung / *Primary User*):** Mewakili pegawai operasional yang menggunakan sistem presensi setiap hari kerja.
2. **Narasumber 2 (Pengelola Kepegawaian / *Secondary User*):** Mewakili unit kerja HRD / Biro Sumber Daya Manusia (BSDM) yang memvalidasi dan merekapitulasi kehadiran.
3. **Narasumber 3 (Penanggung Jawab Kebijakan & Infrastruktur TI):** Mewakili pengelola tata kelola teknologi informasi, keamanan data, dan kepatuhan hukum privasi (UU PDP).

---

## 2. Transkrip & Intisari Wawancara Narasumber

### Narasumber 1: Pegawai / Staf Operasional
* **Identitas:** Budi Santoso, S.Kom. (Usia 31 tahun)
* **Peran:** Staf Administrasi Akademik Fakultas
* **Waktu Wawancara:** 3 November 2026

#### Pertanyaan & Jawaban:
1. **Bagaimana pengalaman Anda menggunakan sistem presensi yang ada saat ini (mesin fingerprint dinding)?**
   > *"Setiap pagi antara pukul 07.45 sampai 08.00 WIB, selalu terjadi antrean panjang di lobi gedung utama. Jika ada 20 orang antre di depan mesin fingerprint, butuh waktu 5–10 menit hanya untuk menunggu giliran. Kadang sensor kacanya buram atau tangan sedang berkeringat setelah naik motor, mesin berulang kali berbunyi 'Coba lagi'. Akibatnya saya yang sudah sampai kantor jam 07.50 bisa tercatat terlambat jam 08.02."*

2. **Bagaimana jika Anda ditugaskan dinas luar atau rapat di kampus cabang lain?**
   > *"Itu salah satu masalah terbesar. Saya harus mengisi formulir kertas manual, minta tanda tangan pimpinan unit, lalu menyerahkannya ke kantor pusat. Prosesnya memakan waktu dan sering terselip."*

3. **Apa yang Anda harapkan dari aplikasi presensi berbasis smartphone?**
   > *"Saya ingin prosesnya cepat: begitu motor saya masuk gerbang kantor, saya buka aplikasi di HP saya sendiri, lakukan verifikasi wajah hitungan detik, langsung terkonfirmasi 'Hadir'. Saya juga ingin bisa mengecek riwayat kehadiran saya sendiri di HP secara transparan agar tahu apakah jam masuk saya sudah diakui sistem."*

4. **Apakah Anda memiliki kekhawatiran terkait privasi (data wajah dan lokasi GPS)?**
   > *"Tentu saja. Saya tidak ingin lokasi saya terus dilacak oleh aplikasi saat saya sudah pulang kerja atau di akhir pekan. Pelacakan hanya boleh terjadi pada detik saya menekan tombol presensi di kantor. Saya juga khawatir foto wajah saya disalahgunakan jika tersimpan di server luar."*

---

### Narasumber 2: Pengelola Kepegawaian (HRD / BSDM)
* **Identitas:** Siti Rahmawati, S.Psi. (Usia 39 tahun)
* **Peran:** Kepala Sub Bagian Administrasi Kepegawaian
* **Waktu Wawancara:** 4 November 2026

#### Pertanyaan & Jawaban:
1. **Apa tantangan terbesar tim HRD dalam mengelola kehadiran pegawai saat ini?**
   > *"Setiap akhir bulan, tim kami menghabiskan 3 sampai 4 hari kerja penuh hanya untuk mengunduh log dari mesin fingerprint fisik, mencocokkannya dengan presensi kertas dinas luar, dan melakukan rekapitulasi ke spreadsheet Excel. Proses manual ini rentan salah ketik dan sangat melelahkan."*

2. **Apakah pernah ditemukan kecurangan dalam pencatatan kehadiran?**
   > *"Pada masa absensi manual kertas tanda tangan, praktik titip presensi antar-rekan kerja sering terjadi. Bahkan pada sistem berbasis aplikasi sederhana tanpa verifikasi identitas, ada pegawai yang menitipkan akunnya ke teman sekantor untuk di-login-kan. Kami butuh mekanisme kepastian bahwa orang yang tercatat hadir memang benar-benar orang yang bersangkutan."*

3. **Fitur apa yang paling dibutuhkan oleh unit HRD?**
   > *"Pertama, validasi ganda: ada pembatasan radius lokasi kantor (geofencing) agar pegawai tidak absen dari rumah, serta verifikasi foto wajah langsung untuk membuktikan identitas. Kedua, dashboard ringkas yang menyajikan data kehadiran secara real-time dan rekapitulasi bulanan otomatis."*

4. **Bagaimana penanganan jika pegawai mengalami kendala teknis (kamera HP rusak atau GPS drop)?**
   > *"Sistem harus adil dan manusiawi. Jangan sampai pegawai yang sudah hadir ditolak tanpa jalan keluar. Harus ada mekanisme pengajuan koreksi presensi atau fallback verifikasi aman (misalnya PIN) yang dapat diperiksa oleh supervisor."*

---

### Narasumber 3: Ahli Tata Kelola & Keamanan TI
* **Identitas:** Ir. Hendra Wijaya, M.T. (Usia 44 tahun)
* **Peran:** Kepala Seksi Keamanan Sistem Informasi & Infrastruktur Jaringan
* **Waktu Wawancara:** 5 November 2026

#### Pertanyaan & Jawaban:
1. **Bagaimana standar keamanan dan kepatuhan hukum yang harus dipenuhi oleh aplikasi presensi mobile?**
   > *"Aplikasi ini memproses dua data yang sangat sensitif: data biometrik wajah dan koordinat lokasi. Sesuai UU No. 27 Tahun 2022 tentang Pelindungan Data Pribadi (UU PDP), data biometrik masuk kategori 'Data Pribadi Spesifik'. Aplikasi tidak boleh menyimpan foto wajah mentah secara permanen. Ekstraksi harus menghasilkan representasi nilai fitur numerik (embedding/hash), lalu foto mentah segera dimusnahkan dari memori."*

2. **Bagaimana mencegah manipulasi teknis dari sisi perangkat pegawai?**
   > *"Banyak pengguna paham aplikasi Fake GPS / Mock Location untuk memalsukan posisi koordinat. Aplikasi wajib memverifikasi flag `isMocked` dari sensor sistem Android. Selain itu, penyimpanan sesi lokal dan PIN tidak boleh ditaruh di SharedPreferences biasa; wajib masuk ke hardware Keystore perangkat."*

3. **Bagaimana dengan prinsip hak subjek data pengguna?**
   > *"Pengguna berhak atas transparansi (kebijakan privasi yang jelas di dalam app), hak koreksi data, serta hak penghapusan data lokal (Right to Erasure) apabila pegawai berhenti menggunakan aplikasi. Pengambilan GPS juga harus berstatus on-demand, dilarang menjalankan background tracking secara berkelanjutan."*

---

## 3. Matriks Sintesis Kebutuhan Lintas Narasumber

Tabel berikut merangkum konvergensi pandangan antara ketiga narasumber dan solusinya pada arsitektur sistem AWALI:

| Aspek / Kebutuhan | Pegawai (Narasumber 1) | HRD (Narasumber 2) | Tim Keamanan TI (Narasumber 3) | Solusi Arsitektur Sistem AWALI |
|---|---|---|---|---|
| **Kecepatan Proses** | Presensi kilat tanpa antre di lobi | Data langsung masuk secara digital | Pemrosesan deteksi wajah lokal di perangkat (*on-device*) | Alur presensi tuntas $\le 10$ detik menggunakan ML Kit lokal |
| **Validasi Lokasi** | GPS hanya aktif saat menekan tombol presensi | Pegawai wajib berada di dalam area kantor | Deteksi manipulasi Fake GPS / *Mock Location* | Validasi geofencing radius 50 meter + blokir posisi tiruan (*mock check*) |
| **Verifikasi Identitas** | Tidak repot, verifikasi kamera instan | Mencegah kecurangan titip absen | Foto mentah dilarang disimpan permanen; simpan vektor numerik | Kamera depan mendeteksi wajah; ekstraksi embedding lokal terenkripsi |
| **Penanganan Kendala** | Opsi alternatif jika sensor bermasalah | Fitur pengajuan koreksi dengan bukti | Alur fallback PIN dengan pembatasan percobaan aman | Fitur Fallback PIN (`SEC-02`) & Pengajuan Koreksi Presensi (`PRV-06`) |
| **Perlindungan Privasi** | Tolak pelacakan di luar jam kerja | Akses data hanya untuk petugas berwenang | Kepatuhan UU PDP Pasal 4 & hak penghapusan data | Kebijakan privasi transparan (`PRV-05`) & *Right to Erasure* (`PRV-03`) |

---

## 4. Klasifikasi Kebutuhan Menurut Prinsip Rekayasa Perangkat Lunak

Berdasarkan hasil elisitasi, kebutuhan dipilah secara tegas menjadi tiga kategori:

### A. Kebutuhan Bisnis (*Business Requirements*)
* Digitalisasi dan otomatisasi kehadiran untuk mengeliminasi antrean fisik dan rekapitulasi manual.
* Peningkatan integritas kehadiran institusi dengan meniadakan celah titip presensi.
* Kepatuhan tata kelola hukum terhadap regulasi ketenagakerjaan dan UU Pelindungan Data Pribadi.

### B. Kebutuhan Pengguna (*User Requirements*)
* Pegawai dapat melakukan presensi mandiri (masuk dan pulang) melalui ponsel pintar masing-masing.
* Pegawai dapat memeriksa riwayat kehadiran pribadinya kapan saja secara transparan.
* Admin HRD dapat memantau data presensi harian dan menghasilkan rekap bulanan otomatis.

### C. Batasan Sistem (*System Constraints*)
* Aplikasi berjalan pada sistem operasi Android (API level minimum 21 / Android 5.0 Lollipop).
* Pada tahap M01–M04, aplikasi menerapkan paradigma *offline-first* dengan penyimpanan lokal terenkripsi hardware (*Android Keystore*); transmisi cloud disimulasikan pada M05.
* Kamera depan dan sensor GPS perangkat diasumsikan berfungsi dengan baik dan berada dalam jangkauan sinyal satelit yang memadai.

