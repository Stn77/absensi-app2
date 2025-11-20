// ===== models/absensi_response.dart =====
class AbsensiResponse {
  final String status;
  final String message;
  final AbsensiData data;

  AbsensiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AbsensiResponse.fromJson(Map<String, dynamic> json) {
    return AbsensiResponse(
      status: json['status'],
      message: json['message'],
      data: AbsensiData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class AbsensiData {
  final int riwayatAbsenId;
  final String tanggal;
  final String hari;
  final String waktuAbsen;
  final String isLate;

  AbsensiData({
    required this.riwayatAbsenId,
    required this.tanggal,
    required this.hari,
    required this.waktuAbsen,
    required this.isLate,
  });

  factory AbsensiData.fromJson(Map<String, dynamic> json) {
    return AbsensiData(
      riwayatAbsenId: json['riwayat_absen_id'],
      tanggal: json['tanggal'],
      hari: json['hari'],
      waktuAbsen: json['waktu_absen'],
      isLate: json['is_late'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'riwayat_absen_id': riwayatAbsenId,
      'tanggal': tanggal,
      'hari': hari,
      'waktu_absen': waktuAbsen,
      'is_late': isLate,
    };
  }
}