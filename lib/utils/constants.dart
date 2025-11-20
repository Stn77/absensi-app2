class AppConstants {
  // App Info
  static const String appName = 'Absensi Siswa';
  static const String appVersion = '1.0.0';
  
  // Timing
  static const int splashDuration = 2; // seconds
  static const int snackbarDuration = 3; // seconds
  
  // Absensi Rules
  static const String jamMasuk = '08:00:00';
  static const String jamPulang = '15:00:00';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);
  
  // Padding & Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  
  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
  
  // Text Sizes
  static const double textSmall = 12.0;
  static const double textMedium = 14.0;
  static const double textLarge = 16.0;
  static const double textXLarge = 20.0;
  static const double textXXLarge = 24.0;
  
  // Image Assets (jika nanti ada)
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderAvatar = 'assets/images/placeholder_avatar.png';
  
  // Messages
  static const String defaultErrorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
  static const String noInternetMessage = 'Tidak ada koneksi internet.';
  static const String serverErrorMessage = 'Terjadi kesalahan pada server.';
  
  // Status Text
  static const String statusTepatWaktu = 'Tepat Waktu';
  static const String statusTerlambat = 'Terlambat';
  static const String jenisDatang = 'datang';
  static const String jenisPulang = 'pulang';
}

// Route Names
class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String absensi = '/absensi';
  static const String history = '/history';
  static const String profile = '/profile';
}