import 'kelas_model.dart';
import 'jurusan_model.dart';

// ===== models/siswa_model.dart =====
class SiswaModel {
  final int id;
  final int userId;
  final String name;
  final String nisn;
  final String? alamat;
  final String? nik;
  final String? tempatLahir;
  final String? tanggalLahir;
  final String? noTelepon;
  final String? foto;
  final String? jenisKelamin;
  final String createdAt;
  final String updatedAt;
  final int kelasId;
  final int jurusanId;
  final KelasModel kelas;
  final JurusanModel jurusan;

  SiswaModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.nisn,
    this.alamat,
    this.nik,
    this.tempatLahir,
    this.tanggalLahir,
    this.noTelepon,
    this.foto,
    this.jenisKelamin,
    required this.createdAt,
    required this.updatedAt,
    required this.kelasId,
    required this.jurusanId,
    required this.kelas,
    required this.jurusan,
  });

  factory SiswaModel.fromJson(Map<String, dynamic> json) {
    return SiswaModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      nisn: json['nisn'],
      alamat: json['alamat'],
      nik: json['nik'],
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'],
      noTelepon: json['no_telepon'],
      foto: json['foto'],
      jenisKelamin: json['jenis_kelamin'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      kelasId: json['kelas_id'],
      jurusanId: json['jurusan_id'],
      kelas: KelasModel.fromJson(json['kelas']),
      jurusan: JurusanModel.fromJson(json['jurusan']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'nisn': nisn,
      'alamat': alamat,
      'nik': nik,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir,
      'no_telepon': noTelepon,
      'foto': foto,
      'jenis_kelamin': jenisKelamin,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'kelas_id': kelasId,
      'jurusan_id': jurusanId,
      'kelas': kelas.toJson(),
      'jurusan': jurusan.toJson(),
    };
  }
}

