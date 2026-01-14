import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../providers/api_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Menggunakan GlobalKey<FormState> untuk memvalidasi input
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Memastikan semua TextFormField divalidasi
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final authProvider = context.read<AuthProvider>();
    
    // Asumsi: provider.login sudah menangani error jika email/password kosong
    // Jika tidak, Anda dapat menambahkan validasi kosong di TextFormField
    
    final success = await authProvider.login(email: email, password: password);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login berhasil!')),
      );
      // Ganti rute menggunakan Navigator
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.home, // Asumsi Routes.home adalah string/konstanta rute
        (Route<dynamic> route) => false,
      );
      // Jika AppRouter.navigateAndRemoveUntil sudah menangani navigasi, gunakan yang asli:
      // AppRouter.navigateAndRemoveUntil(context, Routes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'Login gagal. Silakan coba lagi.')),
      );
    }
  }

  Future<void> _handleTestConnection() async {
    // Implementasi fungsi untuk menguji koneksi ke endpoint test
    final apiProvider = context.read<ApiProvider>();
    final success = await apiProvider.testConnection();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Koneksi berhasil!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Koneksi gagal. Silakan coba lagi.')),
      );
    }
  }
  
  // Fungsi validator dasar
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email harus diisi.';
    }
    // Tambahkan validasi format email jika perlu
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password harus diisi.';
    }
    // Tambahkan validasi panjang password jika perlu
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFE9E2FF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form( // Menggunakan Form widget untuk mengelola state form
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // Container(
                //   width: 10,
                //   height: 100,
                //   decoration: BoxDecoration(
                //     color: const Color(0xFF8C45FF),
                //     borderRadius: BorderRadius.circular(25),
                //     shape: BoxShape.rectangle,
                //   ),
                //   child: const Icon(
                //     Icons.fingerprint,
                //     size: 56,
                //     color: Colors.white,
                //   ),
                // ),

                Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.grey,
                  ),
                ),
                SizedBox(height: 40),
                
                // --- Email Input (Menggunakan TextFormField) ---
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Masukkan email Anda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: _validateEmail,
                ),
                
                SizedBox(height: 16),
                
                // --- Password Input (Menggunakan TextFormField) ---
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password Anda',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: _validatePassword,
                ),
                
                SizedBox(height: 32),
                
                // --- Login Button ---
                ElevatedButton(
                  onPressed: authProvider.isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppTheme.purple, // Asumsi AppTheme punya primaryColor
                    foregroundColor: Colors.white,
                  ),
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),

                // SizedBox(height: 16),

                // ElevatedButton(
                //   onPressed: () {
                //     _handleTestConnection();
                //   },
                //   child: const Text(
                //     'Test Connection'
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}