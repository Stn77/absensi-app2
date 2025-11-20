import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

// Config
import 'config/app_theme.dart';
import 'config/app_router.dart';
import 'config/app_providers.dart';

// Providers
import 'providers/auth_provider.dart';

// Services
import 'services/storage_service.dart';
import 'services/navigation_service.dart';

// Utils
import 'utils/constants.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting untuk bahasa Indonesia
  await initializeDateFormatting('id_ID', null);

  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();

  // Set preferred orientations (portrait only)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Use AppProviders configuration
      providers: AppProviders.providers,
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            
            // Theme Configuration
            theme: AppTheme.lightTheme,
            
            // Routing Configuration
            initialRoute: Routes.splash,
            onGenerateRoute: AppRouter.generateRoute,
            
            // Navigation Key untuk navigasi tanpa context
            navigatorKey: NavigationService().navigatorKey,
            
            // Localization
            locale: const Locale('id', 'ID'),
            supportedLocales: const [
              Locale('id', 'ID'),
              Locale('en', 'US'),
            ],
            
            // Builder untuk error handling dan text scale
            builder: (context, child) {
              // Error widget builder
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                return Scaffold(
                  backgroundColor: AppTheme.lavenderMist,
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppTheme.error,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Terjadi Kesalahan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.purpleDeep,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Mohon restart aplikasi',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              };

              // Set text scale factor agar tidak terpengaruh system settings
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0,
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}

// ============================================================================
// CATATAN PENGGUNAAN:
// ============================================================================
// 
// 1. Provider Usage:
//    - Gunakan context.read<T>() untuk akses provider tanpa rebuild
//    - Gunakan context.watch<T>() untuk listen perubahan dan auto rebuild
//    - Atau gunakan extension: context.authProvider, context.profileProvider
//
// 2. Navigation:
//    - Dengan context: Navigator.pushNamed(context, Routes.home)
//    - Atau: AppRouter.navigate(context, Routes.home)
//    - Tanpa context: NavigationService().navigateTo(Routes.home)
//
// 3. Provider Initialization:
//    - Auth provider di-load immediately (lazy: false)
//    - Profile & Absensi provider di-load on demand (lazy: true)
//    - Initialize di SplashScreen dengan AppProviders.initializeProviders()
//
// 4. Logout Flow:
//    - Panggil authProvider.logout()
//    - Atau AppProviders.clearAllProviders(context) untuk clear semua
//    - Navigate ke login: AppRouter.navigateAndRemoveUntil(context, Routes.login)
//
// 5. Error Handling:
//    - Error widget sudah ter-handle di builder
//    - Gunakan try-catch di provider methods
//    - Tampilkan error dengan SnackBarHelper.showError()
//
// ============================================================================