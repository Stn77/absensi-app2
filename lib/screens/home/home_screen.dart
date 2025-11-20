import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/app_theme.dart';
import '../../config/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/absensi_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/snackbar_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    if (_isInitialized) return;

    // Load profile dan history
    final profileProvider = context.read<ProfileProvider>();
    final absensiProvider = context.read<AbsensiProvider>();

    await Future.wait([
      profileProvider.loadProfile(),
      absensiProvider.loadHistory(),
    ]);

    _isInitialized = true;
  }

  Future<void> _handleRefresh() async {
    final profileProvider = context.read<ProfileProvider>();
    final absensiProvider = context.read<AbsensiProvider>();

    await Future.wait([
      profileProvider.refreshProfile(),
      absensiProvider.refreshHistory(),
    ]);

    if (mounted) {
      SnackBarHelper.showSuccess(context, 'Data berhasil diperbarui');
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: TextStyle(color: AppTheme.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.logout();

      if (success && mounted) {
        // Clear other providers
        context.read<ProfileProvider>().clearProfile();
        context.read<AbsensiProvider>().clearAll();

        // Navigate to login
        AppRouter.navigateAndRemoveUntil(context, Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lavenderMist,
      body: SafeArea(
        child: Consumer3<AuthProvider, ProfileProvider, AbsensiProvider>(
          builder: (context, authProvider, profileProvider, absensiProvider, child) {
            final isLoading = profileProvider.isLoading || absensiProvider.isLoadingHistory;

            return LoadingOverlay(
              isLoading: isLoading && !_isInitialized,
              message: 'Memuat data...',
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppTheme.purple,
                child: CustomScrollView(
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      expandedHeight: 180,
                      floating: false,
                      pinned: true,
                      backgroundColor: AppTheme.purple,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.purple,
                                AppTheme.purpleDark,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Helpers.getGreeting(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppTheme.white.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profileProvider.siswa?.name ?? authProvider.user?.name ?? 'User',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: _handleLogout,
                          tooltip: 'Logout',
                        ),
                      ],
                    ),

                    // Content
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date & Time Card
                            _buildDateTimeCard(),
                            
                            const SizedBox(height: 20),
                            
                            // Status Absen Hari Ini
                            _buildAbsenStatusCard(absensiProvider),
                            
                            const SizedBox(height: 24),
                            
                            // Quick Actions
                            const Text(
                              'Menu',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.purpleDeep,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            _buildQuickActions(absensiProvider),
                            
                            const SizedBox(height: 24),
                            
                            // Riwayat Terbaru
                            _buildRecentHistory(absensiProvider),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateTimeCard() {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
    final timeFormat = DateFormat('HH:mm');

    return CustomCard(
      color: AppTheme.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.lavenderMist,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: AppTheme.purple,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFormat.format(now),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.purpleDeep,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeFormat.format(now),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.purple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsenStatusCard(AbsensiProvider absensiProvider) {
    final hasDatang = absensiProvider.hasAbsenDatangToday();
    final hasPulang = absensiProvider.hasAbsenPulangToday();

    IconData icon;
    Color color;
    String title;
    String subtitle;

    if (hasPulang) {
      icon = Icons.check_circle;
      color = AppTheme.success;
      title = 'Absensi Lengkap';
      subtitle = 'Anda sudah absen datang dan pulang hari ini';
    } else if (hasDatang) {
      icon = Icons.access_time;
      color = AppTheme.warning;
      title = 'Sudah Absen Datang';
      subtitle = 'Jangan lupa absen pulang nanti';
    } else {
      icon = Icons.info;
      color = AppTheme.error;
      title = 'Belum Absen';
      subtitle = 'Silakan lakukan absensi datang';
    }

    return StatusCard(
      icon: icon,
      color: color,
      title: title,
      subtitle: subtitle,
    );
  }

  Widget _buildQuickActions(AbsensiProvider absensiProvider) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            icon: Icons.fingerprint,
            title: 'Absensi',
            color: AppTheme.purple,
            onTap: () => AppRouter.navigate(context, Routes.absensi),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            icon: Icons.history,
            title: 'Riwayat',
            color: AppTheme.purpleDark,
            onTap: () => AppRouter.navigate(context, Routes.history),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            icon: Icons.person,
            title: 'Profile',
            color: AppTheme.lavenderMedium,
            onTap: () => AppRouter.navigate(context, Routes.profile),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.purpleDeep,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentHistory(AbsensiProvider absensiProvider) {
    final history = absensiProvider.history.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Riwayat Terbaru',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.purpleDeep,
              ),
            ),
            TextButton(
              onPressed: () => AppRouter.navigate(context, Routes.history),
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        if (history.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'Belum ada riwayat absensi',
                style: TextStyle(
                  color: AppTheme.grey,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          ...history.map((item) => RiwayatCard(
                tanggal: Helpers.formatDate(item.tanggal),
                hari: item.hari,
                waktu: Helpers.formatTime(item.waktuAbsen),
                jenis: item.jenis,
                status: item.isLate,
              )),
      ],
    );
  }
}