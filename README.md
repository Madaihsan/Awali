# AWALI (Absensi WAjah dan LokasI)
**Aplikasi Presensi Pegawai Berbasis Lokasi dan Face Recognition**  
Pemrograman Mobile · Program Studi Sistem Informasi · Fakultas Sains dan Teknologi Terapan  
Universitas Ahmad Dahlan — Tahun Akademik 2026/2027 Gasal

---

## 👥 Tim Pengembang (Kelompok)
- **Mada Ihsan Wicaksono** — 2300016158 *(Repository & Security Lead)*
- **Faishal Abyan** — 2338016159
- **M Yusuf Ardabili** — 2300016156
- **Andang Purwanto** — 2300016104
- **Az zikra Farraz Arsyahputra** — 2300016091

---

## 📱 Deskripsi Aplikasi
**AWALI** (*Absensi WAjah dan LokasI*) adalah aplikasi mobile *cross-platform* yang dirancang untuk memodernisasi pencatatan kehadiran pegawai secara akurat, transparan, dan aman. Aplikasi ini menggabungkan dua lapis verifikasi utama:
1. **Validasi Geografis (*Geofencing/GPS*)**: Memastikan pegawai melakukan presensi berada di dalam titik dan radius area kerja yang telah ditentukan.
2. **Verifikasi Biometrik Wajah (*Face Recognition*)**: Memverifikasi keabsahan identitas pegawai untuk meminimalisir potensi kecurangan atau titip absen.

Sistem AWALI dibangun dengan prinsip *Privacy by Design* yang patuh terhadap **UU No. 27 Tahun 2022 tentang Pelindungan Data Pribadi (UU PDP)** serta standar keamanan **OWASP Mobile Top 10**.

---

## 🛠️ Teknologi yang Digunakan
- **Framework Utama**: [Flutter](https://flutter.dev/) (Channel Stable, Dart 3+)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Penyimpanan Kredensial Aman**: [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) *(Integrasi Android Keystore & iOS Keychain)*
- **Kriptografi & Hashing**: [cryptography](https://pub.dev/packages/cryptography) *(PBKDF2 HMAC-SHA256 120.000 iterasi dengan verifikasi waktu konstan)*
- **Format Waktu & Tanggal**: [intl](https://pub.dev/packages/intl)
- **Arsitektur**: *Clean Architecture* berbasis *Repository Pattern* (Pemisahan ketat antara antarmuka UI dan sumber data).

---

## ⚙️ Persyaratan Lingkungan (Prerequisites)
Sebelum menjalankan aplikasi, pastikan komputer pengembang telah terpasang:
- **Flutter SDK**: Versi `^3.24.0` atau lebih baru (`flutter doctor` centang hijau)
- **Dart SDK**: Termasuk dalam bundle Flutter SDK
- **Git**: Versi `^2.40.0`
- **IDE**: Visual Studio Code (dengan ekstensi Flutter & Dart) atau Android Studio
- **Perangkat Uji**: Emulator Android (API Level 26+ / Android 8.0+) atau Smartphone fisik Android dengan mode *USB Debugging* aktif

---

## 🚀 Panduan Instalasi & Menjalankan Lokal

### 1. Kloning Repositori
```bash
git clone https://github.com/Madaihsan/Awali.git
cd Awali
```

### 2. Pasang Seluruh Dependensi
```bash
flutter pub get
```

### 3. Jalankan Analisis Kode (Linter)
Pastikan tidak ada issue atau kesalahan penulisan kode:
```bash
flutter analyze
```

### 4. Jalankan Aplikasi
Jalankan aplikasi di perangkat emulator atau smartphone fisik yang terhubung:
```bash
flutter run
```

Untuk menjalankan dengan konfigurasi environment tertentu (contoh mode dev/prod):
```bash
# Mode Pengembangan (Default)
flutter run --dart-define=ENV=dev

# Mode Rilis / Produksi (dengan sakelar backend)
flutter run --release --dart-define=ENV=prod --dart-define=USE_REMOTE=false
```

---

## 📁 Struktur Folder Proyek
Proyek disusun secara modular sesuai standar industri dan panduan mata kuliah:

```text
awali/
├── android/                 # Konfigurasi platform Android (Manifest, network security, gradle)
├── design/                  # Aset ekspor desain antarmuka & prototipe Figma (M03)
├── docs/                    # Dokumentasi resmi kepatuhan & arsitektur proyek
│   ├── 00-charter.md        # Project Charter, visi, tujuan terukur & MoSCoW scope
│   ├── 01-compliance/       # 6 Register Kepatuhan UU PDP, etika & OWASP (M01-Tugas 2)
│   │   └── evidence/        # Bukti verifikasi linter & izin APK
│   ├── 02-requirements/     # SRS ringkas, user stories, use case & sequence diagram (M02)
│   ├── 03-design/           # Dokumentasi design tokens, flow & usability test (M03)
│   └── adr/                 # Architecture Decision Records (pencatatan keputusan teknis)
├── lib/                     # Basis kode utama Flutter (Dart)
│   ├── core/                # AppConfig (environment) & AppTheme (design tokens Figma)
│   ├── models/              # Model data entitas presensi (AttendanceRecord)
│   ├── providers/           # Pengelolaan status aplikasi / State Management (Provider)
│   ├── repositories/        # Abstraksi data (AttendanceRepository & InMemoryRepository)
│   ├── screens/             # Halaman antarmuka aplikasi (UI views)
│   ├── services/            # Layanan sistem, SecureStorage & Hashing PIN PBKDF2
│   └── widgets/             # Komponen antarmuka yang dapat digunakan kembali
├── test/                    # Pengujian unit & widget aplikasi
├── pubspec.yaml             # Konfigurasi dependensi dan metadata proyek
└── README.md                # Dokumentasi utama proyek
```

---

## 📌 Status Milestone Proyek
Proyek ini dikerjakan secara bertahap sepanjang semester mengacu pada peta milestone:

| Milestone | Tahapan | Deskripsi Utama | Status | Tag Git |
|:---:|---|---|:---:|:---:|
| **M01** | **Inisiasi Proyek** | Charter, Register Kepatuhan R1–R6, Baseline Keamanan & Fondasi Repository | 🟡 *Dalam Proses* | `m01-start` → `m01-initiation` |
| **M02** | **Spesifikasi** | Elisitasi Kebutuhan, User Stories, Acceptance Criteria, SRS Ringkas & Diagram UML | ⚪ *Belum Mulai* | `m02-spec` |
| **M03** | **Prototipe UI** | Screen Inventory, Hi-Fi Prototype Figma, Design Tokens & Usability Testing | ⚪ *Belum Mulai* | `m03-design` |
| **M04** | **Frontend Mobile**| Implementasi Widget Flutter, Navigasi, Provider State, Validasi & Data Terenkripsi | ⚪ *Belum Mulai* | `m04-frontend` |
| **M05** | **Integrasi API** | Integrasi Cloud/Firestore, Sakelar USE_REMOTE, Security Rules & Kebijakan Privasi v2 | ⚪ *Belum Mulai* | `m05-integration` |
