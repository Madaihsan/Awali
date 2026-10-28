# Project Charter — AWALI (Absensi WAjah dan LokasI)
**Topik:** Presensi Pegawai Berbasis Lokasi & Face Recognition  
**Kelompok:** Kelompok 2 · Pemrograman Mobile SI UAD (2026/2027 Gasal)  
**Anggota:** Mada Ihsan Wicaksono, Faishal Abyan, M Yusuf Ardabili, Andang Purwanto, Az zikra Farraz Arsyahputra  
**Penanggung Jawab:** M. Yusuf Ardabili  

---

## 1. Visi Produk
Menyediakan sistem pencatatan kehadiran pegawai berbasis mobile yang cepat, objektif, dan privat dengan memvalidasi keberadaan fisik di area kantor serta verifikasi identitas wajah secara lokal tanpa mengorbankan privasi pengguna.

---

## 2. Tujuan Terukur (Measurable Goals)
1. **Kecepatan Presensi:** Proses validasi lokasi dan pengambilan verifikasi wajah hingga selesai tercatat membutuhkan waktu **≤ 10 detik** dari layar utama.
2. **Akurasi Geofencing:** Memvalidasi radius kehadiran pegawai dengan presisi **toleransi radius 50 meter** dari titik koordinat kantor yang ditetapkan.
3. **Keandalan Deteksi Wajah:** Memastikan keberadaan wajah valid terdeteksi dengan tingkat keyakinan (*confidence score*) **≥ 80%** sebelum data presensi diizinkan tersimpan.
4. **Kepatuhan Privasi:** 100% data kredensial dan sesi lokal tersimpan terenkripsi di *secure storage* perangkat tanpa transmisi data tidak sah.

---

## 3. Pengguna Sasaran (Target Audience)
- **Pengguna Utama (*Primary*):** Pegawai / staf institusi (estimasi target simulasi: 1.000 pegawai) yang menggunakan smartphone Android/iOS.
- **Pengguna Pengelola (*Secondary*):** Admin / HRD dan supervisor yang berwenang memantau rekapitulasi kehadiran.

---

## 4. Ruang Lingkup Proyek (Scope MoSCoW)

### Must Have (Wajib Ada di Prototipe)
- Autentikasi pengguna berbasis NIP dan pengamanan PIN lokal terenkripsi (PBKDF2).
- Validasi posisi GPS perangkat terhadap titik dan radius kantor (*geofencing*).
- Pengambilan foto dan deteksi wajah pengguna menggunakan kamera.
- Pencatatan status presensi (Masuk / Pulang) beserta stempel waktu (*timestamp*) dan koordinat.
- Riwayat presensi pribadi yang dapat ditinjau oleh pegawai.
- Fitur penghapusan data lokal pengguna (*right to erasure* sesuai UU PDP).

### Won't Have (Sengaja Dikecualikan untuk Semester Ini)
- Integrasi langsung ke sistem penggajian (*payroll*) dan perbankan.
- Sinkronisasi multi-cabang otomatis berskala nasional.
- Pemasangan SDK *analytics* atau pelacak pihak ketiga (*third-party trackers*).
- Pengenalan wajah berbasis cloud AI berbayar eksternal.

---

## 5. Batasan & Asumsi (Constraints & Assumptions)
- **Teknologi:** Dibangun menggunakan framework Flutter (Dart) dengan arsitektur Repository Pattern.
- **Waktu:** Waktu pengerjaan dibatasi oleh jadwal 16 minggu perkuliahan semester gasal.
- **Offline-First:** Pada tahap M01–M04, aplikasi bekerja secara lokal (*in-memory / secure local storage*); integrasi remote API/Firestore disimulasikan pada M05.
- **Kamera & Lokasi:** Diasumsikan perangkat pengguna memiliki sensor GPS aktif dan kamera depan dengan pencahayaan memadai.

---

## 6. Risiko Awal & Mitigasi
1. **Risiko Biometrik & Privasi (UU PDP):** Wajah merupakan data pribadi spesifik.  
   *Mitigasi:* Simpan data wajah secara lokal dan terenkripsi; jangan kirim gambar mentah tanpa persetujuan eksplisit.
2. **Manipulasi Lokasi (*Fake GPS / Mock Location*):** Pegawai berpotensi memalsukan lokasi kehadiran.  
   *Mitigasi:* Periksa status mock location pada API perangkat dan validasi akurasi koordinat.
3. **Variasi Hardware Smartphone:** Perbedaan kualitas kamera dan akurasi sensor GPS antar-merk HP.  
   *Mitigasi:* Sediakan toleransi radius yang wajar (50 meter) dan petunjuk panduan pengambilan foto wajah yang jelas.

---

## 7. Kriteria Sukses (Success Criteria)
- Seluruh kebutuhan non-fungsional keamanan (`SEC-xx`) dan privasi (`PRV-xx`) lulus verifikasi linter dan audit kepatuhan.
- Alur presensi (mulai buka app $\rightarrow$ cek lokasi $\rightarrow$ foto wajah $\rightarrow$ tersimpan) berhasil diuji coba oleh minimal 5 orang pengguna tanpa kendala teknis fatal.
