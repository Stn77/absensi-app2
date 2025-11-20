// ===== models/riwayat_absen_model.dart =====
class RiwayatAbsenModel {
  final int id;
  final String tanggal;
  final String hari;
  final String waktuAbsen;
  final String latitude;
  final String longitude;
  final String isLate;
  final int siswaId;
  final String jenis; // 'datang' atau 'pulang'
  final String? createdAt;
  final String? updatedAt;

  RiwayatAbsenModel({
    required this.id,
    required this.tanggal,
    required this.hari,
    required this.waktuAbsen,
    required this.latitude,
    required this.longitude,
    required this.isLate,
    required this.siswaId,
    required this.jenis,
    this.createdAt,
    this.updatedAt,
  });

  factory RiwayatAbsenModel.fromJson(Map<String, dynamic> json) {
    return RiwayatAbsenModel(
      id: json['id'],
      tanggal: json['tanggal'],
      hari: json['hari'],
      waktuAbsen: json['waktu_absen'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isLate: json['is_late'],
      siswaId: json['siswa_id'],
      jenis: json['jenis'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal,
      'hari': hari,
      'waktu_absen': waktuAbsen,
      'latitude': latitude,
      'longitude': longitude,
      'is_late': isLate,
      'siswa_id': siswaId,
      'jenis': jenis,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}