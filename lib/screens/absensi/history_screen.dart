import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/absensi_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/snackbar_helper.dart';
import '../../utils/helpers.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'Semua'; // Semua, Datang, Pulang, Terlambat

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final absensiProvider = context.read<AbsensiProvider>();
    await absensiProvider.loadHistory();
  }

  Future<void> _handleRefresh() async {
    final absensiProvider = context.read<AbsensiProvider>();
    await absensiProvider.refreshHistory();

    if (mounted) {
      SnackBarHelper.showSuccess(context, 'Riwayat berhasil diperbarui');
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Filter Riwayat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('Semua'),
            _buildFilterOption('Datang'),
            _buildFilterOption('Pulang'),
            _buildFilterOption('Terlambat'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String filter) {
    final isSelected = _selectedFilter == filter;
    return ListTile(
      title: Text(filter),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppTheme.purple)
          : null,
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lavenderMist,
      appBar: AppBar(
        title: const Text('Riwayat Absensi'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Consumer<AbsensiProvider>(
        builder: (context, absensiProvider, child) {
          return LoadingOverlay(
            isLoading: absensiProvider.isLoadingHistory && absensiProvider.history.isEmpty,
            message: 'Memuat riwayat...',
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppTheme.purple,
              child: absensiProvider.history.isEmpty
                  ? _buildEmptyState()
                  : _buildHistoryList(absensiProvider),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: Icons.history,
      title: 'Belum Ada Riwayat',
      message: 'Riwayat absensi Anda akan muncul di sini',
      buttonText: 'Refresh',
      onButtonPressed: _handleRefresh,
    );
  }

  Widget _buildHistoryList(AbsensiProvider absensiProvider) {
    // Filter history based on selected filter
    var filteredHistory = absensiProvider.history;

    if (_selectedFilter == 'Datang') {
      filteredHistory = filteredHistory
          .where((item) => item.jenis.toLowerCase() == 'datang')
          .toList();
    } else if (_selectedFilter == 'Pulang') {
      filteredHistory = filteredHistory
          .where((item) => item.jenis.toLowerCase() == 'pulang')
          .toList();
    } else if (_selectedFilter == 'Terlambat') {
      filteredHistory = filteredHistory
          .where((item) => item.isLate.toLowerCase().contains('terlambat'))
          .toList();
    }

    if (filteredHistory.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.filter_alt_off,
                size: 64,
                color: AppTheme.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'Tidak ada data dengan filter "$_selectedFilter"',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Filter Info
        if (_selectedFilter != 'Semua')
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.purple.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.filter_alt,
                  color: AppTheme.purple,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Filter: $_selectedFilter',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.purple,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'Semua';
                    });
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.purple,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Statistics Card
        _buildStatisticsCard(absensiProvider),

        const SizedBox(height: 20),

        // History List
        Text(
          'Riwayat (${filteredHistory.length})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.purpleDeep,
          ),
        ),
        const SizedBox(height: 12),

        ...filteredHistory.map((item) {
          return RiwayatCard(
            tanggal: Helpers.formatDate(item.tanggal),
            hari: item.hari,
            waktu: Helpers.formatTime(item.waktuAbsen),
            jenis: item.jenis,
            status: item.isLate,
            onTap: () => _showDetailDialog(item),
          );
        }),
      ],
    );
  }

  Widget _buildStatisticsCard(AbsensiProvider absensiProvider) {
    final history = absensiProvider.history;
    final totalDatang = history.where((item) => item.jenis == 'datang').length;
    final totalPulang = history.where((item) => item.jenis == 'pulang').length;
    final totalTerlambat = history
        .where((item) => item.isLate.toLowerCase().contains('terlambat'))
        .length;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistik',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.purpleDeep,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total',
                  history.length.toString(),
                  AppTheme.purple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Datang',
                  totalDatang.toString(),
                  AppTheme.purpleDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Pulang',
                  totalPulang.toString(),
                  AppTheme.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Terlambat',
                  totalTerlambat.toString(),
                  AppTheme.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(dynamic item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Detail Absensi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Tanggal', Helpers.formatDate(item.tanggal)),
            const SizedBox(height: 12),
            _buildDetailRow('Hari', item.hari),
            const SizedBox(height: 12),
            _buildDetailRow('Waktu', item.waktuAbsen),
            const SizedBox(height: 12),
            _buildDetailRow('Jenis', item.jenis.toUpperCase()),
            const SizedBox(height: 12),
            _buildDetailRow('Status', item.isLate),
            const SizedBox(height: 12),
            _buildDetailRow('Latitude', item.latitude),
            const SizedBox(height: 12),
            _buildDetailRow('Longitude', item.longitude),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.grey,
            ),
          ),
        ),
        const Text(': '),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.purpleDeep,
            ),
          ),
        ),
      ],
    );
  }
}