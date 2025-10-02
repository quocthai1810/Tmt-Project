import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/env.dart';

enum SignUpStatus { idle, loading, success, error }

class SignUpProvider extends ChangeNotifier {
  SignUpStatus status = SignUpStatus.idle;
  String? errorMessage;

  bool get isLoading => status == SignUpStatus.loading;
  bool get isSuccess => status == SignUpStatus.success;

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    status = SignUpStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse("${apiTMT}/XacThuc/DangKy");
      final body = jsonEncode({
        "email": email,
        "mat_khau": password,
        "ho_ten": fullName,
      });

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print('SignUp HTTP ${response.statusCode} - body: ${response.body}');

      if (response.statusCode == 200) {
        // Đăng ký thành công → lưu email & isLogin
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("email", email);
        await prefs.setBool("isLogin", true);

        status = SignUpStatus.success;
      } else if (response.statusCode == 409) {
        // Email đã tồn tại
        final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        status = SignUpStatus.error;
        errorMessage = (data['message'] ?? 'Email đã tồn tại').toString();
      } else {
        // Các lỗi khác
        final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        status = SignUpStatus.error;
        errorMessage =
            (data['message'] ?? 'Lỗi: ${response.statusCode}').toString();
      }
    } catch (e) {
      status = SignUpStatus.error;
      errorMessage = 'Lỗi mạng hoặc server: $e';
      print('SignUp exception: $e');
    }

    notifyListeners();
  }

  /// Reset trạng thái về ban đầu (gọi sau khi đã điều hướng)
  void reset() {
    status = SignUpStatus.idle;
    errorMessage = null;
    notifyListeners();
  }

  /// Lấy email đã lưu
  Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  /// Kiểm tra trạng thái login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLogin") ?? false;
  }
}
