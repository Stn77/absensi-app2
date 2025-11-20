import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/snackbar_helper.dart';
import '../../widgets/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Get auth provider
    final authProvider = context.read<AuthProvider>();

    // Perform login
    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      // Login berhasil
      SnackBarHelper.showSuccess(context, 'Login berhasil!');
      
      // Navigate to home
      AppRouter.navigateAndRemoveUntil(context, Routes.home);
    } else {
      // Login gagal
      SnackBarHelper.showError(
        context,
        authProvider.errorMessage ?? 'Login gagal. Silakan coba lagi.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lavenderMist,
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return LoadingOverlay(
              isLoading: authProvider.isLoading,
              message: 'Memproses login...',
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      
                      // Logo & Title
                      Center(
                        child: Column(
                          children: [
                            // Logo Container
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.purple,
                                    AppTheme.purpleDark,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.purple.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.fingerprint,
                                size: 56,
                                color: AppTheme.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // App Name
                            const Text(
                              AppConstants.appName,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.purpleDeep,
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            // Subtitle
                            Text(
                              'Masuk ke akun Anda',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Email Field
                      CustomTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: 'Masukkan email Anda',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Password Field
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: 'Masukkan password Anda',
                        prefixIcon: Icons.lock_outlined,
                        obscureText: true,
                        validator: Validators.password,
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Login Button
                      CustomButton(
                        text: 'Masuk',
                        onPressed: _handleLogin,
                        isLoading: authProvider.isLoading,
                        width: double.infinity,
                        height: 54,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Info Text
                      Center(
                        child: Text(
                          'Gunakan email dan password yang terdaftar',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Version Info
                      Center(
                        child: Text(
                          'Version ${AppConstants.appVersion}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.grey.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}