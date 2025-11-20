import 'user_model.dart';
import 'siswa_model.dart';

// ===== models/login_response.dart =====
class LoginResponse {
  final String message;
  final String token;
  final UserModel user;

  LoginResponse({
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      token: json['token'],
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'token': token,
      'user': user.toJson(),
    };
  }
}

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