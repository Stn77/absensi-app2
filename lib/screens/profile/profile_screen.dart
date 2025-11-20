import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/snackbar_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profileProvider = context.read<ProfileProvider>();
    if (!profileProvider.hasData) {
      await profileProvider.loadProfile();
    }
  }

  Future<void> _handleRefresh() async {
    final profileProvider = context.read<ProfileProvider>();
    await profileProvider.refreshProfile();

    if (mounted) {
      SnackBarHelper.showSuccess(context, 'Profile berhasil diperbarui');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lavenderMist,
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return LoadingOverlay(
            isLoading: profileProvider.isLoading && !profileProvider.hasData,
            message: 'Memuat profile...',
            child: CustomScrollView(
              slivers: [
                // App Bar with Profile Header
                SliverAppBar(
                  expandedHeight: 200,
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
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            // Avatar
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppTheme.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.person,
                                size: 56,
                                color: AppTheme.purple,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Name
                            Text(
                              profileProvider.getFullName(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // NISN
                            Text(
                              'NISN: ${profileProvider.siswa?.nisn ?? '-'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    color: AppTheme.purple,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Personal Info Section
                          const Text(
                            'Informasi Pribadi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.purpleDeep,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildInfoCard(
                            icon: Icons.person_outline,
                            label: 'Nama Lengkap',
                            value: profileProvider.getFullName(),
                          ),
                          
                          _buildInfoCard(
                            icon: Icons.badge_outlined,
                            label: 'NISN',
                            value: profileProvider.siswa?.nisn ?? '-',
                          ),
                          
                          _buildInfoCard(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: profileProvider.user?.email ?? '-',
                          ),
                          
                          _buildInfoCard(
                            icon: Icons.phone_outlined,
                            label: 'No. Telepon',
                            value: profileProvider.getNoTelepon(),
                          ),
                          
                          _buildInfoCard(
                            icon: Icons.credit_card_outlined,
                            label: 'NIK',
                            value: profileProvider.getNik(),
                          ),
                          
                          _buildInfoCard(
                            icon: Icons.cake_outlined,
                            label: 'Tempat, Tanggal Lahir',
                            value: profileProvider.getTempatTanggalLahir(),
                          ),
                          
                          _buildInfoCard(
                            icon: Icons.wc_outlined,
                            label: 'Jenis Kelamin',
                            value: profileProvider.getJenisKelamin(),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Academic Info Section
                          const Text(
                            'Informasi Akademik',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.purpleDeep,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildInfoCard(
                            icon: Icons.school_outlined,
                            label: 'Kelas',
                            value: profileProvider.siswa?.kelas.name ?? '-',
                          ),
                          
                          _buildInfoCard(
                            icon: Icons.business_center_outlined,
                            label: 'Jurusan/Kompetensi Keahlian',
                            value: profileProvider.siswa?.jurusan.name ?? '-',
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Address Section
                          const Text(
                            'Alamat',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.purpleDeep,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          CustomCard(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppTheme.lavenderMist,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.location_on_outlined,
                                    color: AppTheme.purple,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Alamat Lengkap',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        profileProvider.getAlamat(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.purpleDeep,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.lavenderMist,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppTheme.purple,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.purpleDeep,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}