// ===== models/jurusan_model.dart =====
class JurusanModel {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;

  JurusanModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JurusanModel.fromJson(Map<String, dynamic> json) {
    return JurusanModel(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
