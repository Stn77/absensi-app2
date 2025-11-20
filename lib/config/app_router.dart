import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/absensi/absensi_screen.dart';
import '../screens/absensi/history_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../utils/constants.dart';

class AppRouter {
  // Generate routes dengan page transition animation
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _buildRoute(
          const SplashScreen(),
          settings: settings,
        );

      case Routes.login:
        return _buildRoute(
          const LoginScreen(),
          settings: settings,
        );

      case Routes.home:
        return _buildRoute(
          const HomeScreen(),
          settings: settings,
        );

      case Routes.absensi:
        return _buildRoute(
          const AbsensiScreen(),
          settings: settings,
        );

      case Routes.history:
        return _buildRoute(
          const HistoryScreen(),
          settings: settings,
        );

      case Routes.profile:
        return _buildRoute(
          const ProfileScreen(),
          settings: settings,
        );

      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Route tidak ditemukan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text('${settings.name}'),
                ],
              ),
            ),
          ),
          settings: settings,
        );
    }
  }

  // Build route dengan custom page transition
  static Route<dynamic> _buildRoute(
    Widget page, {
    RouteSettings? settings,
    bool fadeTransition = false,
  }) {
    if (fadeTransition) {
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
    }

    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }

  // Navigate to route with replacement
  static void navigateReplace(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  // Navigate to route
  static void navigate(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  // Navigate and remove all previous routes
  static void navigateAndRemoveUntil(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
    );
  }

  // Go back
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  // Check if can go back
  static bool canGoBack(BuildContext context) {
    return Navigator.canPop(context);
  }
}