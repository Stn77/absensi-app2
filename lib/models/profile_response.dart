import 'siswa_model.dart';
import 'user_model.dart';

// ===== models/profile_response.dart =====
class ProfileResponse {
  final String status;
  final ProfileData data;

  ProfileResponse({
    required this.status,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'],
      data: ProfileData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class ProfileData {
  final UserModel user;
  final SiswaModel siswa;

  ProfileData({
    required this.user,
    required this.siswa,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: UserModel.fromJson(json['user']),
      siswa: SiswaModel.fromJson(json['siswa']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'siswa': siswa.toJson(),
    };
  }
}

