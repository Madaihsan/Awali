# R2 · Matriks Etika Profesi
**Aplikasi:** AWALI (Absensi WAjah dan LokasI)  
**Topik:** Presensi Pegawai  
**Kode Etik yang Digunakan:** **ACM Code of Ethics** dan **IEEE-CS Code of Ethics**  
**Penanggung Jawab :** Faishal Abyan
**NIM :** 2338016159 

---

## 1. Matriks Prinsip Etika vs Risiko & Kontrol Aplikasi

| Sumber | Prinsip Etika | Risiko Potensial di Aplikasi AWALI | Kontrol Teknis / Kebijakan (ID) |
|---|---|---|---|
| **ACM 1.6** | **Hormati Privasi (*Respect Privacy*)** | Pengumpulan data lokasi di luar jam kerja menimbulkan rasa diawasi (*surveillance anxiety*) dan pelanggaran ranah pribadi pegawai. | **`PRV-01`**: Pengambilan koordinat GPS hanya bersifat sesaat (*point-in-time*) saat tombol presensi ditekan, bukan *tracking* berkelanjutan. |
| **ACM 1.7** | **Jaga Kerahasiaan (*Honor Confidentiality*)** | Data biometrik wajah pegawai tersimpan tanpa enkripsi dan dapat diekstrak oleh pihak ketiga dari penyimpanan ponsel. | **`SEC-01`**: Seluruh data sesi dan kredensial wajib disimpan di `FlutterSecureStorage` (Android Keystore hardware-backed). |
| **ACM 1.3** | **Jujur dan Tepercaya (*Be Honest and Trustworthy*)** | Aplikasi mengklaim hanya bekerja secara lokal, tetapi diam-diam mengirimkan foto wajah ke cloud tanpa persetujuan eksplisit pengguna. | **`PRV-05`**: Kebijakan privasi yang jujur dan transparan; sakelar `USE_REMOTE` dimatikan secara default hingga M05. |
| **ACM 2.5** | **Evaluasi Menyeluruh (*Give Comprehensive Evaluations of Computer Systems*)** | Algoritma pengenalan wajah gagal mengenali pegawai dengan warna kulit tertentu, pencahayaan minim, atau aksesoris (hijab/kacamata), menyebabkan penolakan presensi yang tidak adil. | **`UX-02`**: Sediakan mekanisme presensi alternatif / pelaporan kendala jika sistem verifikasi wajah mengalami kegagalan teknis. |
| **IEEE-CS 1.03** | **Kepentingan Publik (*Public Interest*)** | Terjadinya kebocoran data biometrik massal akibat celah keamanan pada aplikasi yang merugikan pegawai. | **`SEC-03`** & **`SEC-05`**: Nonaktifkan backup sistem (`allowBackup="false"`), larang koneksi HTTP polos (*cleartext*), dan lakukan pengujian penetrasi berkala. |

---

## 2. Catatan Khusus Risiko Topik Presensi Pegawai
1. **Isu Privasi Biometrik:** Wajah tidak dapat diganti seperti password jika terjadi kebocoran. Oleh karena itu, prinsip *least privilege* dan enkripsi penyimpanan adalah kewajiban mutlak.
2. **Keseimbangan Hak Kerja vs Pengawasan:** Pengawasan kehadiran harus proporsional sesuai UU Ketenagakerjaan No. 13/2003, tidak boleh menjadi alat intimidasi atau pelacakan privasi pekerja di luar jam operasional kantor.
