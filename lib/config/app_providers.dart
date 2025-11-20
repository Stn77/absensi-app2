import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// Providers
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/absensi_provider.dart';

/// App Providers Configuration
/// Centralized provider list untuk memudahkan management
class AppProviders {
  // List semua providers yang digunakan di aplikasi
  static List<SingleChildWidget> providers = [
    // Auth Provider
    ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(),
      lazy: false, // Load immediately saat app start
    ),

    // Profile Provider
    ChangeNotifierProvider<ProfileProvider>(
      create: (_) => ProfileProvider(),
      lazy: true, // Load on demand
    ),

    // Absensi Provider
    ChangeNotifierProvider<AbsensiProvider>(
      create: (_) => AbsensiProvider(),
      lazy: true, // Load on demand
    ),
  ];

  /// Helper method untuk mendapatkan provider tanpa BuildContext
  /// Gunakan dengan hati-hati, prefer menggunakan context jika memungkinkan
  static T getProvider<T>(BuildContext context, {bool listen = false}) {
    return Provider.of<T>(context, listen: listen);
  }

  /// Clear all providers (berguna saat logout)
  static void clearAllProviders(BuildContext context) {
    // Clear Auth Provider
    final authProvider = context.read<AuthProvider>();
    authProvider.logout();

    // Clear Profile Provider
    final profileProvider = context.read<ProfileProvider>();
    profileProvider.clearProfile();

    // Clear Absensi Provider
    final absensiProvider = context.read<AbsensiProvider>();
    absensiProvider.clearAll();
  }

  /// Initialize providers yang perlu data awal
  static Future<void> initializeProviders(BuildContext context) async {
    // Initialize auth provider
    final authProvider = context.read<AuthProvider>();
    await authProvider.initialize();

    // Jika user sudah login, load profile dan history
    if (authProvider.isAuthenticated) {
      // Load profile
      final profileProvider = context.read<ProfileProvider>();
      await profileProvider.loadProfile();

      // Load absensi history
      final absensiProvider = context.read<AbsensiProvider>();
      await absensiProvider.loadHistory();
    }
  }
}

/// Extension untuk memudahkan akses provider dari context
extension ProviderExtension on BuildContext {
  // Auth Provider
  AuthProvider get authProvider => read<AuthProvider>();
  AuthProvider get watchAuthProvider => watch<AuthProvider>();

  // Profile Provider
  ProfileProvider get profileProvider => read<ProfileProvider>();
  ProfileProvider get watchProfileProvider => watch<ProfileProvider>();

  // Absensi Provider
  AbsensiProvider get absensiProvider => read<AbsensiProvider>();
  AbsensiProvider get watchAbsensiProvider => watch<AbsensiProvider>();
}