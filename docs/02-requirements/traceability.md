# Matriks Ketertelusuran Kebutuhan (Requirements Traceability Matrix)
**Aplikasi:** AWALI (Absensi WAjah dan LokasI) — Presensi Pegawai  
**Milestone:** M02 — Spesifikasi Kebutuhan & Desain Arsitektur (`m02-spec`)  
**Penyusun:** Tim Pengembang AWALI  

---

## 1. Pendahuluan

Matriks Ketertelusuran (*Traceability Matrix*) membuktikan keterhubungan lurus dua arah (*bidirectional traceability*) dari kebutuhan bisnis tingkat tinggi, kebutuhan fungsional (FR) dan non-fungsional (NFR), cerita pengguna (*User Stories*), pemodelan use case, komponen kode/arsitektur, target antarmuka layar (M03), hingga rencana pengujian sistem (M04/M05).

Dengan adanya matriks ini, setiap fitur yang dikembangkan dipastikan memiliki dasar kebutuhan yang valid (*no scope creep*), dan setiap kebutuhan yang dijanjikan dalam Project Charter memiliki realisasi komponen teknis serta pengujian yang terukur.

---

## 2. Matriks Ketertelusuran Kebutuhan Fungsional (FR)

| ID Kebutuhan | Nama Kebutuhan Fungsional | User Story Terkait | Use Case ID | Komponen / Method Arsitektur Kode | Target Layar UI (Figma M03) | Rencana Pengujian (Test Case ID) |
|:---:|---|:---:|:---:|---|---|:---:|
| **`FR-01`** | Autentikasi NIP Pegawai | `US-01` | `UC-01` | `SecureStorageService.saveUserSession()` | `LoginScreen` | `TC-AUTH-01` (Validasi format NIP) |
| **`FR-02`** | Proteksi PIN Keamanan PBKDF2 | `US-01` | `UC-01` | `PinService.setPin()`, `PinService.verifyPin()` | `PinLockScreen`, `SetupPinScreen` | `TC-PIN-01` (Verifikasi PIN PBKDF2) |
| **`FR-03`** | Validasi Lokasi Geofencing ($\le 50$m) | `US-02` | `UC-03` | `LocationData.isWithinGeofence()`, `LocationService` | `AttendanceScreen` (Peta Radius) | `TC-GEO-01` (Uji jarak toleransi 50m) |
| **`FR-04`** | Verifikasi Wajah (Face Detection) | `US-03` | `UC-04` | `CameraFaceService.captureAndDetectFace()` | `CameraPreviewModal` | `TC-FACE-01` (Deteksi wajah confidence $\ge 80\%$) |
| **`FR-05`** | Pencatatan Presensi Masuk & Pulang | `US-04` | `UC-02` | `AttendanceProvider.recordAttendance()`, `AttendanceRepository.add()` | `AttendanceSuccessScreen` | `TC-ATT-01` (Simpan record presensi lengkap) |
| **`FR-06`** | Riwayat Presensi Personal | `US-05` | `UC-06` | `AttendanceProvider.records`, `AttendanceRepository.getAll()` | `HistoryScreen` | `TC-HIST-01` (Muat riwayat kronologis) |
| **`FR-07`** | Monitoring & Ekspor Rekapitulasi | `US-06` | `UC-08`, `UC-09` | `AttendanceProvider.persentaseKehadiran()`, `ExportService` | `DashboardScreen`, `ReportScreen` | `TC-REP-01` (Ekspor dokumen CSV/PDF ringkas) |
| **`FR-08`** | Hak Penghapusan Data (Right to Erasure) | `US-07` | `UC-10` | `AttendanceProvider.clearAll()`, `SecureStorageService.clearAll()` | `PrivacySettingsScreen` (Dialog Konfirmasi) | `TC-PRV-01` (Verifikasi pemusnahan total data lokal) |

---

## 3. Matriks Ketertelusuran Kebutuhan Non-Fungsional (NFR: Privasi, Keamanan, UX)

| ID NFR | Deskripsi Kebutuhan Non-Fungsional | Sumber / Regulasi | Use Case Terkait | Komponen / Implementasi Teknis | Bukti Verifikasi / Test Artifact |
|:---:|---|---|:---:|---|---|
| **`PRV-01`** | Minimisasi Data (Tidak simpan foto mentah permanen) | UU PDP Ps. 4 | `UC-04` | Ekstraksi fitur numerik lokal; memori citra langsung dibebaskan | Kode `CameraFaceService` & Inspeksi Storage |
| **`PRV-02`** | Bebas SDK Pelacak Pihak Ketiga | Kode Etik ACM 1.6 | Seluruh Sistem | Mengunci dependensi hanya pada package resmi | Audit berkas `pubspec.yaml` & `pubspec.lock` |
| **`PRV-03`** | Hak Penghapusan Data ($\le 2$ ketukan) | UU PDP Ps. 8 | `UC-10` | `AttendanceRepository.clear()` & `SecureStorageService.clearAll()` | `sequence/skenario-2.md` & Skenario Uji UI |
| **`PRV-04`** | Hak Akses dan Portabilitas Data | UU PDP Ps. 7 | `UC-09` | Fitur ekspor riwayat presensi portabel | Layar `ReportScreen` |
| **`PRV-05`** | Transparansi Kebijakan Privasi | UU PDP Ps. 5 | `UC-11` | Layar statis pembaca kebijakan privasi offline | Layar `PrivacyPolicyScreen` & `R6 privacy-policy.md` |
| **`PRV-06`** | Hak Koreksi atas Kendala Teknis | UU PDP Ps. 6 | `UC-07` | Alur tiket pengajuan koreksi presensi ke HRD | `stories.md` (US-08) |
| **`SEC-01`** | Kredensial Terenkripsi Hardware Keystore | OWASP M9 | `UC-01` | Pustaka `flutter_secure_storage` | `docs/01-compliance/evidence/sec-01-*` |
| **`SEC-02`** | Kriptografi KDF PBKDF2 (120.000 iterasi) | OWASP M1/M10 | `UC-01`, `UC-05` | `PinService` (HMAC-SHA256 + salt acak) | `lib/services/pin_service.dart` & `sequence/skenario-2.md` |
| **`SEC-03`** | Nonaktifkan Backup & Linter `avoid_print` | OWASP M8 | Seluruh Sistem | `android:allowBackup="false"` & `analysis_options.yaml` | `docs/01-compliance/evidence/sec-03-*` |
| **`SEC-04`** | Proteksi Repositori & Kunci Dependensi | OWASP M2 | Seluruh Sistem | `.gitignore` menyaring secret; commit `pubspec.lock` | Pemeriksaan Git status |
| **`SEC-05`** | Larangan Komunikasi Cleartext HTTP | OWASP M5 | Seluruh Sistem | `network_security_config.xml` (`cleartextTrafficPermitted="false"`) | `docs/01-compliance/evidence/sec-06-permissions.txt` |
| **`SEC-06`** | Prinsip Izin Minimal (Nihil INTERNET di M01) | OWASP M6 | Seluruh Sistem | Manifest merge tanpa deklarasi izin berlebih | `docs/01-compliance/evidence/sec-06-permissions.txt` |
| **`UX-01`** | Bebas Dark Pattern | Panduan UX Etis | Seluruh Layar | Audit berkala 6 pola manipulasi antarmuka | Dokumen `docs/01-compliance/R5 dark-pattern-audit.md` |
| **`UX-02`** | Izin Default MATI & Sedia Alternatif | UU PDP Ps. 9 | `UC-03`, `UC-05` | Izin on-demand & Fallback PIN jika kamera gagal | `sequence/skenario-2.md` |
| **`UX-03`** | Aksesibilitas WCAG AA (Teks $\ge 14$sp) | Standar Desain | Seluruh Layar | Token warna dan tipografi di `AppTheme` | `lib/core/app_theme.dart` |

---

## 4. Ringkasan Cakupan Ketertelusuran (*Traceability Coverage Summary*)

* **Total Butir Must-Have dari Charter:** 6 Butir $\rightarrow$ **100% Tercakup pada `FR-01` s.d. `FR-08`**.
* **Total Kebutuhan Fungsional (FR):** 8 Kebutuhan $\rightarrow$ **100% Memiliki User Story, Use Case, dan Komponen Kode**.
* **Total Kebutuhan Non-Fungsional (NFR):** 15 Kebutuhan (`PRV`, `SEC`, `UX`) $\rightarrow$ **100% Memiliki Komponen Implementasi & Bukti Verifikasi**.
* **Status Ketertelusuran:** **Lengkap & Terverifikasi (Terkoneksi Penuh ke Milestone M01, M02, dan M03/M04)**.
