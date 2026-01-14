import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/app_theme.dart';
import '../../providers/absensi_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/snackbar_helper.dart';
import '../../widgets/loading_overlay.dart';
import '../../utils/helpers.dart';

class AbsensiScreen extends StatefulWidget {
  const AbsensiScreen({super.key});

  @override
  State<AbsensiScreen> createState() => _AbsensiScreenState();
}

class _AbsensiScreenState extends State<AbsensiScreen> {
  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    final absensiProvider = context.read<AbsensiProvider>();
    final success = await absensiProvider.getCurrentLocation();

    if (!success && mounted) {
      SnackBarHelper.showError(
        context,
        absensiProvider.errorMessage ?? 'Gagal mendapatkan lokasi',
      );
    }
  }

  Future<void> _handleAbsensi() async {
    final absensiProvider = context.read<AbsensiProvider>();

    // Validasi lokasi
    if (!absensiProvider.hasLocation) {
      SnackBarHelper.showWarning(
        context,
        'Lokasi belum tersedia. Ambil lokasi terlebih dahulu.',
      );
      return;
    }

    // Submit absensi
    final success = await absensiProvider.submitAbsensi();

    if (!mounted) return;

    if (success) {
      final lastAbsensi = absensiProvider.lastAbsensi;
      
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 64,
                  color: AppTheme.success,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Absensi Berhasil!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.purpleDeep,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                lastAbsensi?.message ?? 'Absensi Anda telah tercatat',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.grey,
                ),
              ),
              if (lastAbsensi != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.lavenderMist,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Waktu', lastAbsensi.data.waktuAbsen),
                      const SizedBox(height: 8),
                      _buildInfoRow('Status', lastAbsensi.data.isLate),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            CustomButton(
              text: 'OK',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Back to home
              },
              width: double.infinity,
            ),
          ],
        ),
      );
    } else {
      SnackBarHelper.showError(
        context,
        absensiProvider.errorMessage ?? 'Gagal melakukan absensi',
      );
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.purpleDeep,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lavenderMist,
      appBar: AppBar(
        title: const Text('Absensi'),
        elevation: 0,
      ),
      body: Consumer<AbsensiProvider>(
        builder: (context, absensiProvider, child) {
          return LoadingOverlay(
            isLoading: absensiProvider.isLoading,
            message: 'Memproses absensi...',
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Time Card
                  _buildTimeCard(),
                  
                  const SizedBox(height: 20),
                  
                  // Location Card
                  _buildLocationCard(absensiProvider),
                  
                  const SizedBox(height: 24),
                  
                  // Status Absen Hari Ini
                  _buildStatusCard(absensiProvider),
                  
                  const SizedBox(height: 32),
                  
                  // Absen Button
                  CustomButton(
                    text: 'Lakukan Absensi',
                    icon: Icons.fingerprint,
                    onPressed: absensiProvider.hasLocation ? _handleAbsensi : null,
                    isLoading: absensiProvider.isLoading,
                    height: 56,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Refresh Location Button
                  CustomButton(
                    text: 'Perbarui Lokasi',
                    icon: Icons.my_location,
                    onPressed: _getLocation,
                    isOutlined: true,
                    isLoading: absensiProvider.isGettingLocation,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Info Card
                  _buildInfoCard(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeCard() {
    final now = DateTime.now();
    final dayFormat = DateFormat('EEEE', 'id_ID');
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
    final timeFormat = DateFormat('HH:mm:ss');

    return CustomCard(
      child: Column(
        children: [
          Text(
            dayFormat.format(now),
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            dateFormat.format(now),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.purpleDeep,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.purple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              timeFormat.format(now),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppTheme.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(AbsensiProvider absensiProvider) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.lavenderMist,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  absensiProvider.hasLocation ? Icons.location_on : Icons.location_off,
                  color: absensiProvider.hasLocation ? AppTheme.success : AppTheme.error,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lokasi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.purpleDeep,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      absensiProvider.hasLocation ? 'Lokasi tersedia' : 'Lokasi belum tersedia',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (absensiProvider.isGettingLocation)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.purple,
                  ),
                ),
            ],
          ),
          if (absensiProvider.hasLocation) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lavenderMist,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Latitude',
                        style: TextStyle(fontSize: 12, color: AppTheme.grey),
                      ),
                      Text(
                        absensiProvider.currentLatitude ?? '-',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.purpleDeep,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Longitude',
                        style: TextStyle(fontSize: 12, color: AppTheme.grey),
                      ),
                      Text(
                        absensiProvider.currentLongitude ?? '-',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.purpleDeep,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusCard(AbsensiProvider absensiProvider) {
    final status = absensiProvider.getAbsenStatusToday();
    final hasDatang = absensiProvider.hasAbsenDatangToday();
    final hasPulang = absensiProvider.hasAbsenPulangToday();

    Color statusColor;
    IconData statusIcon;

    if (hasPulang) {
      statusColor = AppTheme.success;
      statusIcon = Icons.check_circle;
    } else if (hasDatang) {
      statusColor = AppTheme.warning;
      statusIcon = Icons.access_time;
    } else {
      statusColor = AppTheme.error;
      statusIcon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              status,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return CustomCard(
      color: AppTheme.purple.withOpacity(0.1),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.purple, size: 20),
              SizedBox(width: 8),
              Text(
                'Informasi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.purpleDeep,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            '• Pastikan GPS aktif untuk mendapatkan lokasi\n'
            '• Absen datang dilakukan saat pertama kali absen\n'
            '• Absen pulang dilakukan setelah absen datang\n'
            '• Jam masuk: 08:00, terlambat jika lebih dari jam tersebut',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}