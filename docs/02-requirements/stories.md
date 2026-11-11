# User Stories & Acceptance Criteria
**Aplikasi:** AWALI (Absensi WAjah dan LokasI) — Presensi Pegawai  
**Milestone:** M02 — Spesifikasi Kebutuhan & Desain Arsitektur (`m02-spec`)  
**Penyusun:** Tim Pengembang AWALI  

---

## 1. Pendahuluan

Dokumen ini mendefinisikan kebutuhan fungsional sistem AWALI dari sudut pandang pengguna dalam bentuk **User Story** yang terukur. Setiap *story* diturunkan langsung dari ruang lingkup *Must Have* pada Project Charter (`docs/00-charter.md`) serta hasil elisitasi kebutuhan (`docs/02-requirements/notes.md`).

Setiap *User Story* dilengkapi dengan **Kriteria Penerimaan (*Acceptance Criteria*)** menggunakan format terstruktur **Given-When-Then** (Gherkin syntax) untuk memastikan implementasi pada Milestone M04 dan pengujian pada Milestone M05 dapat diuji secara objektif (*verifiable & testable*).

---

## 2. Daftar User Stories

### US-01: Autentikasi Pengguna & Pengamanan PIN Lokal
* **Sebagai:** Pegawai
* **Saya ingin:** Melakukan login menggunakan NIP dan mengamankan akses aplikasi dengan kode PIN 4–6 digit
* **Agar:** Sesi akun kepegawaian saya terlindungi dan hanya saya yang dapat membuka aplikasi di perangkat ini.

#### Kriteria Penerimaan:
* **Skenario 1.1: Pembuatan PIN Aplikasi Berhasil**
  * **Given:** Pegawai telah memasukkan NIP yang valid dan belum memiliki PIN aktif.
  * **When:** Pegawai memasukkan 6 digit PIN baru dan mengonfirmasi ulang PIN yang sama.
  * **Then:** Sistem menyimpan hash PIN menggunakan PBKDF2 (120.000 iterasi + salt acak) ke dalam `FlutterSecureStorage` (`SEC-02`), menandai status PIN aktif, dan mengarahkan pengguna ke layar utama.
* **Skenario 1.2: Verifikasi PIN Benar**
  * **Given:** Aplikasi dalam keadaan terkunci dan PIN keamanan telah aktif.
  * **When:** Pegawai memasukkan PIN yang sesuai dengan hash tersimpan.
  * **Then:** Sistem memverifikasi kecocokan menggunakan perbandingan waktu konstan (*constant-time comparison*), membuka kunci aplikasi, dan menampilkan dashboard utama dalam waktu $\le 1$ detik.
* **Skenario 1.3: Penolakan PIN Salah**
  * **Given:** Aplikasi dalam keadaan terkunci.
  * **When:** Pegawai memasukkan digit PIN yang tidak cocok.
  * **Then:** Sistem menampilkan pesan kesalahan *"PIN tidak valid"* dan mengosongkan kembali kolom isian tanpa membuka akses layar.

---

### US-02: Validasi Lokasi Kehadiran (Geofencing 50 Meter)
* **Sebagai:** Pegawai
* **Saya ingin:** Sistem memeriksa koordinat lokasi saya secara otomatis saat menekan tombol presensi
* **Agar:** Kehadiran saya diakui sah karena terbukti berada di dalam radius area kantor yang diizinkan.

#### Kriteria Penerimaan:
* **Skenario 2.1: Lokasi Berada di Dalam Radius Kantor (Valid)**
  * **Given:** Pegawai berada di kantor dengan jarak fisik $\le 50$ meter dari titik koordinat kantor yang ditetapkan.
  * **When:** Pegawai menekan tombol presensi dan memberikan izin lokasi sesaat (*on-demand*).
  * **Then:** Sistem mengambil koordinat GPS, menghitung jarak menggunakan `Geolocator`, menampilkan indikator hijau *"Lokasi Valid: Dalam Area Kantor"*, dan mengizinkan proses berlanjut ke tahap verifikasi wajah.
* **Skenario 2.2: Lokasi di Luar Radius Kantor (Ditolak)**
  * **Given:** Pegawai berada di luar area kantor (jarak $> 50$ meter dari titik acuan kantor).
  * **When:** Pegawai menekan tombol presensi.
  * **Then:** Sistem menampilkan dialog peringatan berwarna oranye/merah *"Di Luar Area Kantor: Jarak Anda X meter dari kantor (Maksimal 50m)"*, dan menonaktifkan tombol verifikasi presensi.
* **Skenario 2.3: Deteksi Lokasi Tiruan (Anti Mock GPS)**
  * **Given:** Perangkat pegawai mengaktifkan aplikasi Fake GPS / Mock Location provider.
  * **When:** Pegawai memicu pemeriksaan lokasi presensi.
  * **Then:** Sistem mendeteksi status flag `isMocked == true`, menolak koordinat tersebut, dan menampilkan pesan peringatan *"Lokasi palsu terdeteksi. Harap matikan aplikasi Fake GPS"*.

---

### US-03: Presensi dengan Deteksi Wajah Instan
* **Sebagai:** Pegawai
* **Saya ingin:** Memverifikasi kehadiran menggunakan tangkapan kamera wajah depan
* **Agar:** Identitas saya terbukti secara objektif dan sistem terbebas dari kecurangan titip absen.

#### Kriteria Penerimaan:
* **Skenario 3.1: Deteksi Wajah Sah Berhasil**
  * **Given:** Pegawai berada di area presensi dengan pencahayaan memadai dan wajah menghadap kamera depan.
  * **When:** Kamera mengambil tangkapan wajah dan memprosesnya via `google_mlkit_face_detection`.
  * **Then:** Sistem mendeteksi satu wajah valid dengan tingkat keyakinan (*confidence score*) $\ge 80\%$, mengekstrak representasi nilai fitur secara lokal, memusnahkan foto mentah dari memori sementara (`PRV-01`), dan menandai verifikasi identitas sukses.
* **Skenario 3.2: Wajah Tidak Terdeteksi atau Terhalang**
  * **Given:** Wajah pengguna terhalang masker/kegelapan atau kamera mengarah ke area kosong.
  * **When:** Tombol bidik presensi dieksekusi.
  * **Then:** Sistem menampilkan pesan panduan *"Wajah tidak terdeteksi dengan jelas. Pastikan pencahayaan cukup dan wajah menghadap penuh ke kamera"*.

---

### US-04: Pencatatan Presensi Masuk & Pulang
* **Sebagai:** Pegawai
* **Saya ingin:** Data kehadiran saya (Masuk / Pulang) tersimpan secara instan beserta stempel waktu dan statusnya
* **Agar:** Saya memiliki rekaman bukti kehadiran resmi untuk administrasi kepegawaian hari itu.

#### Kriteria Penerimaan:
* **Skenario 4.1: Pencatatan Presensi Masuk Berhasil**
  * **Given:** Validasi lokasi sukses dan verifikasi wajah telah terpenuhi.
  * **When:** Pegawai mengonfirmasi presensi masuk.
  * **Then:** Sistem menyimpan objek `AttendanceRecord` ke basis data lokal (`AttendanceRepository`), mencatat timestamp waktu perangkat, menentukan status kehadiran (Hadir tepat waktu atau Terlambat jika $> 08.00$ WIB), dan menampilkan SnackBar *"Presensi Masuk Berhasil Dicatat"*. Seluruh proses selesai dalam waktu $\le 10$ detik dari layar beranda.
* **Skenario 4.2: Pencatatan Presensi Pulang**
  * **Given:** Pegawai telah memiliki catatan presensi masuk pada hari kerja yang sama.
  * **When:** Pegawai melakukan alur validasi presensi pada sore hari untuk jam pulang.
  * **Then:** Sistem memperbarui record harian dengan jam presensi pulang dan menampilkan konfirmasi sukses.

---

### US-05: Peninjauan Riwayat Presensi Pribadi
* **Sebagai:** Pegawai
* **Saya ingin:** Melihat daftar riwayat kehadiran saya sendiri berdasarkan rentang tanggal
* **Agar:** Saya dapat memantau kedisiplinan dan memastikan tidak ada data jam kerja saya yang terlewat.

#### Kriteria Penerimaan:
* **Skenario 5.1: Menampilkan Riwayat Presensi Lengkap**
  * **Given:** Pegawai telah memiliki sejumlah catatan presensi di perangkat.
  * **When:** Pegawai membuka menu *"Riwayat Kehadiran"*.
  * **Then:** Sistem memuat daftar rekaman kehadiran (`AttendanceRecord`) secara kronologis terbalik (paling baru di atas), menampilkan tanggal, jam masuk, jam pulang, status (Hadir/Terlambat), dan metode verifikasi.
* **Skenario 5.2: Tampilan Riwayat Kosong**
  * **Given:** Pengguna baru membuka aplikasi dan belum pernah melakukan presensi.
  * **When:** Pengguna membuka menu riwayat.
  * **Then:** Sistem menampilkan ilustrasi ramah dengan teks *"Belum ada riwayat kehadiran tercatat"*.

---

### US-06: Monitoring & Rekapitulasi Presensi oleh HRD
* **Sebagai:** Admin / Pengelola Kepegawaian (HRD)
* **Saya ingin:** Memantau ringkasan statistik kehadiran harian pegawai
* **Agar:** Saya dapat mengevaluasi tingkat kehadiran secara real-time tanpa perlu merekap kertas secara manual.

#### Kriteria Penerimaan:
* **Skenario 6.1: Menampilkan Dashboard Kehadiran**
  * **Given:** Pengguna login sebagai peran Admin/HRD.
  * **When:** Membuka menu Dashboard Kehadiran.
  * **Then:** Sistem menyajikan kartu ringkasan total pegawai hadir, terlambat, izin, dan persentase kehadiran hari berjalan.
* **Skenario 6.2: Ekspor Data Rekapitulasi (`PRV-04`)**
  * **Given:** Admin berada di layar laporan kehadiran.
  * **When:** Admin memilih periode bulan dan menekan tombol *"Ekspor Laporan"*.
  * **Then:** Sistem menghasilkan berkas portabel (format CSV/PDF ringkas) yang dapat diunduh untuk kebutuhan arsip dan pelaporan pimpinan.

---

### US-07: Hak Penghapusan Seluruh Data Pribadi Lokal (`PRV-03` / *Right to Erasure*)
* **Sebagai:** Pegawai
* **Saya ingin:** Menghapus seluruh riwayat presensi, sesi login, dan data keamanan lokal saya dalam $\le 2$ ketukan
* **Agar:** Hak privasi saya terpenuhi sesuai UU PDP Pasal 8 apabila saya tidak lagi menggunakan aplikasi ini.

#### Kriteria Penerimaan:
* **Skenario 7.1: Eksekusi Penghapusan Data Sukses**
  * **Given:** Pengguna berada di layar *"Pengaturan & Privasi"*.
  * **When:** Pengguna mengetuk tombol *"Hapus Seluruh Data"* dan menekan tombol konfirmasi *"Ya, Hapus Permanen"* pada dialog peringatan (total 2 ketukan).
  * **Then:** Sistem menjalankan `AttendanceRepository.clear()` untuk memusnahkan seluruh rekaman presensi dan menjalankan `SecureStorageService.clearAll()` untuk menghapus PIN serta token Keystore, mereset state provider, dan menampilkan notifikasi *"Seluruh data pribadi Anda telah berhasil dihapus secara permanen"*.
* **Skenario 7.2: Pembatalan Penghapusan Data**
  * **Given:** Dialog konfirmasi penghapusan data sedang terbuka.
  * **When:** Pengguna menekan tombol *"Batal"*.
  * **Then:** Dialog tertutup dan seluruh data presensi serta kredensial tetap utuh tanpa perubahan apa pun.

---

### US-08: Pengajuan Koreksi Presensi atas Kendala Teknis (`PRV-06`)
* **Sebagai:** Pegawai
* **Saya ingin:** Mengajukan laporan koreksi presensi disertai keterangan jika sensor perangkat mengalami kegagalan teknis
* **Agar:** Hak kehadiran saya tetap dapat dipertimbangkan secara adil oleh bagian kepegawaian.

#### Kriteria Penerimaan:
* **Skenario 8.1: Pengajuan Koreksi Berhasil Dikirim**
  * **Given:** Pegawai mengalami kendala teknis (misal: GPS anomali atau kamera depan bermasalah di lokasi kantor).
  * **When:** Pegawai membuka menu *"Ajukan Koreksi Presensi"*, memilih tanggal, mengisi deskripsi kendala, dan menekan *"Kirim Pengajuan"*.
  * **Then:** Sistem mencatat status tiket koreksi dengan status *"Diajukan"* dan menampilkan bukti tanda terima nomor laporan.

