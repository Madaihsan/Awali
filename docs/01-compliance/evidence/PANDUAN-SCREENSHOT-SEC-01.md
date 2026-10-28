# PANDUAN SCREENSHOT BUKTI TEKNIS
## Verifikasi Enkripsi Penyimpanan Lokal — Aplikasi AWALI
**Requirement:** SEC-01 (Penyimpanan Kredensial Terenkripsi)  
**Kelompok:** Kelompok 2 · Pemrograman Mobile SI UAD  
**Tanggal Panduan:** 2026-10-29

---

## Mengapa Screenshot Ini Diperlukan?

Bukti ini membuktikan bahwa data sensitif aplikasi AWALI (PIN, NIP, vektor biometrik)
**tidak dapat dibaca sebagai teks biasa** oleh pihak yang tidak berwenang, bahkan jika
seseorang memiliki akses fisik ke folder data aplikasi di perangkat Android.

Penyimpanan menggunakan `FlutterSecureStorage` berbasis **Android Keystore** menjamin
bahwa file yang tersimpan bersifat ter-enkripsi oleh hardware perangkat. Screenshot ini
adalah bukti visual dari keamanan tersebut.

---

## LANGKAH A — Siapkan Aplikasi di Emulator atau Perangkat Fisik

1. Jalankan emulator Android via Android Studio, atau sambungkan perangkat Android
   fisik dengan kabel USB (pastikan **USB Debugging** sudah aktif di Developer Options).

2. Di terminal VS Code atau Command Prompt, jalankan:
   ```
   cd E:\UAD\Semester 7\Pemrograman Mobile\Tugas\Presensi-Pegawai\awali
   flutter run
   ```

3. Tunggu aplikasi berhasil terpasang dan berjalan di emulator/perangkat.

4. Di dalam aplikasi, lakukan salah satu aksi berikut agar data tersimpan:
   - Buat atau masukkan PIN aplikasi (jika fitur sudah tersedia), ATAU
   - Jalankan unit test `SecureStorageService` untuk menulis data uji ke storage.

---

## LANGKAH B — Buka Device File Explorer di Android Studio

1. Buka **Android Studio**.
2. Di menu atas, pilih: **View → Tool Windows → Device File Explorer**
   _(Atau tekan shortcut: tidak ada default, cari di Search Everywhere dengan Ctrl+Shift+A → "Device File Explorer")_

3. Di panel Device File Explorer yang muncul di sebelah kanan atau bawah,
   pastikan perangkat/emulator yang menjalankan AWALI sudah terpilih di dropdown atas.

---

## LANGKAH C — Navigasi ke Folder Data Aplikasi AWALI

4. Di panel Device File Explorer, navigasikan ke path berikut (klik satu per satu):
   ```
   data/
   └── data/
       └── id.ac.uad.awali/     ← package ID aplikasi AWALI
           ├── shared_prefs/
           ├── databases/
           └── files/
   ```
   > **Catatan:** Folder `id.ac.uad.awali` adalah package ID aplikasi.
   > Jika berbeda, sesuaikan dengan package ID di `pubspec.yaml` atau `AndroidManifest.xml`.

5. Klik folder `shared_prefs/` untuk melihat isinya.

---

## LANGKAH D — Ambil Screenshot Bukti

### Screenshot 1 — Isi folder `shared_prefs/` (tampilkan daftar file)
- Di panel Device File Explorer, klik folder `shared_prefs/`.
- Akan terlihat file seperti `FlutterSecureStorageMasterKey.xml` dan
  `FlutterSecureStorage.xml` (atau nama serupa).
- **Ambil screenshot** yang menampilkan daftar file tersebut.
- Simpan dengan nama: `sec-01-screenshot-folder.png`

### Screenshot 2 — Isi file storage (teks terenkripsi, tidak terbaca)
- Klik dua kali pada file `FlutterSecureStorage.xml` (atau file penyimpanan utama).
- File akan terbuka di panel teks Android Studio dan menampilkan isi file dalam format XML.
- Anda akan melihat bahwa **value** dari setiap entri adalah string panjang acak
  yang tidak terbaca (ini adalah data terenkripsi), bukan teks biasa seperti "1234" atau NIP.
- **Ambil screenshot** yang menampilkan isi file terenkripsi tersebut.
- Simpan dengan nama: `sec-01-screenshot-encrypted-content.png`

---

## LANGKAH E — Simpan Screenshot ke Folder Evidence

6. Salin kedua file screenshot ke:
   ```
   awali/docs/01-compliance/evidence/
   ├── sec-01-screenshot-folder.png
   └── sec-01-screenshot-encrypted-content.png
   ```

7. Commit file screenshot ke repositori:
   ```bash
   git add docs/01-compliance/evidence/
   git commit -m "sec: tambah screenshot bukti enkripsi FlutterSecureStorage (SEC-01)"
   ```

---

## Tampilan yang Diharapkan (Indikator LULUS)

Jika penyimpanan terenkripsi berfungsi dengan benar, isi file yang tampil di
Android Studio akan terlihat seperti ini (contoh ilustratif):

```xml
<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<map>
    <string name="VGVzdEtleQ==">AAAAAAAAABCxyz123abcDEFghi...</string>
    <string name="cGluX2hhc2g=">AAAAAAAAACmnopqrSTUVwxyz456...</string>
</map>
```

Perhatikan bahwa:
- Nama kunci (key) sudah terenkripsi (string Base64 acak)
- Nilai (value) adalah data biner terenkripsi, bukan teks seperti "1234" atau NIP asli

Jika nilai yang tampil adalah teks biasa yang terbaca (misal: `pin_hash=1234`),
berarti enkripsi TIDAK berfungsi dan harus segera diperbaiki.

---

## ALTERNATIF: Verifikasi via ADB (Jika Tidak Menggunakan Android Studio)

Jika menggunakan emulator dan ADB sudah terkonfigurasi di PATH, jalankan:

```bash
# Masuk ke shell perangkat
adb shell

# Pindah ke folder data aplikasi (memerlukan root di emulator)
run-as id.ac.uad.awali

# Lihat isi folder shared_prefs
ls shared_prefs/
cat shared_prefs/FlutterSecureStorage.xml
```

Salin output terminal tersebut dan simpan ke:
`docs/01-compliance/evidence/sec-01-adb-storage-dump.txt`

---

## Ringkasan File Evidence yang Dibutuhkan

| File | Cara Mendapatkan | Status |
|---|---|:---:|
| `sec-03-lint.txt` | `flutter analyze > ...` | ✅ Sudah Ada |
| `sec-03-print.txt` | `git grep -n 'print(' -- lib` | ✅ Sudah Ada |
| `sec-06-permissions.txt` | Verifikasi AndroidManifest | ✅ Sudah Dibuat |
| `sec-01-screenshot-folder.png` | Device File Explorer Android Studio | ⏳ Perlu Dilakukan Manual |
| `sec-01-screenshot-encrypted-content.png` | Device File Explorer Android Studio | ⏳ Perlu Dilakukan Manual |
