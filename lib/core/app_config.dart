class AppConfig {
  static const env = String.fromEnvironment('ENV', defaultValue: 'dev');

  // Sakelar ini default-nya MATI (false) sesuai aturan M01.
  // Baru diaktifkan di M05 ketika menghubungkan remote API/backend.
  static const useRemote = bool.fromEnvironment('USE_REMOTE', defaultValue: false);

  static bool get isProd => env == 'prod';

  // Contoh titik koordinat default kantor (Kampus 4 UAD) & batas radius geofencing
  static const defaultOfficeLat = -7.8332;
  static const defaultOfficeLng = 110.3831;
  static const defaultRadiusMeters = 50.0;
}
