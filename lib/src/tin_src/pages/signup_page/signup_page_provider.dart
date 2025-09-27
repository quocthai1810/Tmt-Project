import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/env.dart';

class SignUpProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  bool isSuccess = false;

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    isLoading = true;
    errorMessage = null;
    isSuccess = false;
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

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["success"] == true) {
          isSuccess = true;
        } else {
          errorMessage = data["message"] ?? "Đăng ký thất bại";
        }
      } else {
        errorMessage = "Lỗi: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage = "Lỗi mạng hoặc server: $e";
    }

    isLoading = false;
    notifyListeners();
  }
}
