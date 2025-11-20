import 'package:intl/intl.dart';

class Helpers {
  // Format date dari string ke format Indonesia
  static String formatDate(String dateString, {String format = 'dd MMMM yyyy'}) {
    try {
      final date = DateTime.parse(dateString);
      final formatter = DateFormat(format, 'id_ID');
      return formatter.format(date);
    } catch (e) {
      return dateString;
    }
  }

  // Format time dari string HH:mm:ss ke HH:mm
  static String formatTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}';
      }
      return timeString;
    } catch (e) {
      return timeString;
    }
  }

  // Format datetime ke format Indonesia lengkap
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd MMMM yyyy HH:mm', 'id_ID');
    return formatter.format(dateTime);
  }

  // Get hari ini dalam bahasa Indonesia
  static String getTodayInIndonesian() {
    final now = DateTime.now();
    return getDayNameInIndonesian(now.weekday);
  }

  // Convert weekday ke nama hari Indonesia
  static String getDayNameInIndonesian(int weekday) {
    switch (weekday) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return 'Unknown';
    }
  }

  // Get current date dalam format yyyy-MM-dd
  static String getCurrentDate() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  // Get current time dalam format HH:mm:ss
  static String getCurrentTime() {
    final now = DateTime.now();
    return DateFormat('HH:mm:ss').format(now);
  }

  // Format koordinat (latitude/longitude)
  static String formatCoordinate(String coordinate) {
    try {
      final double value = double.parse(coordinate);
      return value.toStringAsFixed(6);
    } catch (e) {
      return coordinate;
    }
  }

  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Truncate text dengan ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Check apakah sudah jam masuk (contoh: jam 08:00)
  static bool isTimeAfter(String timeString, String compareTime) {
    try {
      final time = DateFormat('HH:mm:ss').parse(timeString);
      final compare = DateFormat('HH:mm:ss').parse(compareTime);
      return time.isAfter(compare);
    } catch (e) {
      return false;
    }
  }

  // Get greeting berdasarkan waktu
  static String getGreeting() {
    final hour = DateTime.now().hour;
    
    if (hour >= 0 && hour < 11) {
      return 'Selamat Pagi';
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat Siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  // Format phone number
  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-numeric characters
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Format: 0812-3456-7890
    if (cleaned.length >= 11) {
      return '${cleaned.substring(0, 4)}-${cleaned.substring(4, 8)}-${cleaned.substring(8)}';
    }
    
    return phoneNumber;
  }

  // Parse error message dari exception
  static String parseErrorMessage(dynamic error) {
    String errorMessage = error.toString();
    
    // Remove 'Exception: ' prefix jika ada
    if (errorMessage.startsWith('Exception: ')) {
      errorMessage = errorMessage.replaceFirst('Exception: ', '');
    }
    
    return errorMessage;
  }
}