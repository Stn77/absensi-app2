import 'package:flutter/material.dart';

/// Navigation Service
/// Service untuk navigasi tanpa BuildContext
/// Berguna untuk navigasi dari service layer atau provider
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Get current context
  BuildContext? get currentContext => navigatorKey.currentContext;

  // Get current navigator state
  NavigatorState? get navigator => navigatorKey.currentState;

  /// Navigate to named route
  Future<dynamic>? navigateTo(String routeName, {Object? arguments}) {
    return navigator?.pushNamed(routeName, arguments: arguments);
  }

  /// Replace current route with named route
  Future<dynamic>? navigateReplaceTo(String routeName, {Object? arguments}) {
    return navigator?.pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Navigate and remove all previous routes
  Future<dynamic>? navigateAndRemoveUntil(
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return navigator?.pushNamedAndRemoveUntil(
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  /// Go back to previous route
  void goBack({dynamic result}) {
    navigator?.pop(result);
  }

  /// Check if can go back
  bool canGoBack() {
    return navigator?.canPop() ?? false;
  }

  /// Navigate to route with custom page
  Future<T?> navigateToPage<T>(Widget page) {
    return navigator!.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Show dialog
  Future<T?> showDialogPage<T>({
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: currentContext!,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

  /// Show bottom sheet
  Future<T?> showBottomSheetPage<T>({
    required Widget Function(BuildContext) builder,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet<T>(
      context: currentContext!,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: builder,
    );
  }
}