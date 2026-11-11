# Sequence Diagram — Skenario 1: Rekam Presensi Berhasil (Happy Path)
**Aplikasi:** AWALI (Absensi WAjah dan LokasI) — Presensi Pegawai  
**Milestone:** M02 — Spesifikasi Kebutuhan & Desain Arsitektur (`m02-spec`)  
**ID Kebutuhan Terkait:** `FR-03`, `FR-04`, `FR-05`, `PRV-01`  
**Penyusun:** Tim Pengembang AWALI  

---

## 1. Deskripsi Skenario

Skenario ini menggambarkan alur utama (*Happy Path*) saat pegawai melakukan presensi kehadiran masuk harian melalui smartphone di area kantor. Seluruh tahapan validasi berjalan sukses:
1. Pegawai membuka layar presensi dan menekan tombol konfirmasi.
2. Posisi GPS diverifikasi berada di dalam radius toleransi kantor ($\le 50$ meter) dan terbebas dari Fake GPS.
3. Kamera depan mendeteksi wajah dengan tingkat keyakinan valid ($\ge 80\%$), lalu foto mentah langsung dihapus dari memori.
4. Objek rekaman presensi (`AttendanceRecord`) disimpan melalui `AttendanceRepository`.
5. Antarmuka layar diperbarui secara reaktif melalui `AttendanceProvider`, dan umpan balik sukses ditampilkan ke pegawai.

---

## 2. Diagram Sequence (Mermaid)

```mermaid
sequenceDiagram
    autonumber
    actor U as 👤 Pegawai
    participant SC as AttendanceScreen
    participant AP as AttendanceProvider
    participant LS as LocationService
    participant CS as CameraFaceService
    participant AR as InMemoryAttendanceRepository

    Note over U,AR: Skenario 1 — Rekam Presensi Masuk Berhasil (Happy Path)

    %% Langkah 1: Pemicu dari Pengguna
    U ->> SC : Ketuk tombol "Presensi Masuk"
    activate SC
    SC ->> SC : Set state UI: Menampilkan loading validasi

    %% Langkah 2: Validasi Lokasi (Geofencing GPS)
    SC ->> LS : getCurrentLocation()
    activate LS
    LS -->> SC : LocationData (lat, lng, accuracy, isMocked)
    deactivate LS

    SC ->> SC : isWithinGeofence(lat, lng) && !isMocked
    alt Posisi Valid (Jarak <= 50m dari Titik Kantor)
        SC -->> U : Indikator hijau "Lokasi Valid: Dalam Area Kantor"

        %% Langkah 3: Verifikasi Wajah (Face Detection)
        SC ->> CS : captureAndDetectFace()
        activate CS
        Note right of CS: Deteksi fitur wajah via ML Kit
        CS ->> CS : validateConfidenceScore() >= 80%
        CS ->> CS : extractEmbedding() & musnahkan foto mentah (PRV-01)
        CS -->> SC : FaceDetectionResult(isSuccess: true, embedding)
        deactivate CS

        %% Langkah 4: Pencatatan ke Repository melalui Provider
        SC ->> AP : recordAttendance(employeeId, location, WAJAH)
        activate AP
        AP ->> AR : add(AttendanceRecord)
        activate AR
        AR -->> AP : Future<void> resolved (Tersimpan di memori)
        deactivate AR

        %% Langkah 5: Pembaruan State dan Notifikasi UI
        AP ->> AP : notifyListeners()
        AP -->> SC : Consumer rebuild (Perbarui ringkasan kehadiran)
        deactivate AP

        SC -->> U : Tampilkan SnackBar sukses: "Presensi Masuk Berhasil!"
        SC ->> SC : Navigasi kembali ke HomeScreen
    else Posisi di Luar Radius (> 50m) atau Terdeteksi Fake GPS
        SC -->> U : Tampilkan dialog error: "Presensi Ditolak: Di Luar Radius Kantor"
    end
    deactivate SC
```

---

## 3. Analisis Teknis Alur Pesan

| No. Pesan | Pemanggilan / Aksi | Penjelasan Teknis & Alasan Arsitektur |
|:---:|---|---|
| **1–2** | `Ketuk Presensi Masuk` $\rightarrow$ `Set state loading` | Memberikan umpan balik instan (*responsive UI*) kepada pegawai saat proses sensor dimulai. |
| **3–4** | `LS.getCurrentLocation()` | Meminta koordinat GPS secara sesaat (*point-in-time on-demand*). Sesuai `PRV-01`, tidak ada pelacakan di latar belakang setelah nilai koordinat diperoleh. |
| **5–6** | `isWithinGeofence() && !isMocked` | Aturan bisnis geofencing: koordinat diverifikasi terhadap titik koordinat kantor UAD dengan toleransi radius 50 meter dan pengecekan flag Fake GPS. |
| **7–9** | `CS.captureAndDetectFace()` | Mengaktifkan kamera depan. Deteksi wajah diproses lokal di perangkat (*on-device ML*). Segera setelah vektor numerik diperoleh, data citra mentah dimusnahkan dari RAM (`PRV-01`). |
| **10–12** | `AP.recordAttendance()` $\rightarrow$ `AR.add()` | UI tidak pernah langsung mengakses media penyimpanan. Layar mendelegasikan transaksi ke `AttendanceProvider`, dan Provider memanggil interface `AttendanceRepository`. |
| **13–15** | `AP.notifyListeners()` $\rightarrow$ `SnackBar` | Provider memicu *rebuild* widget `Consumer` yang sedang mendengarkan perubahan data, dan sistem menyajikan notifikasi keberhasilan kepada pengguna. |

