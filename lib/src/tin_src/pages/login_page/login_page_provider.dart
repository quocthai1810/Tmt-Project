import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmt_project/core/constants/env.dart';

class LoginProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  bool isSuccess = false;

  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    isSuccess = false;
    notifyListeners();

    try {
      final url = Uri.parse("$apiTMT/XacThuc/DangNhap");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "mat_khau": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["data"] != null) {
        final token = data["data"]["accessToken"];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("accessToken", token);

        isSuccess = true;
      } else {
        errorMessage = data["message"] ?? "Đăng nhập thất bại";
      }
    } catch (e) {
      errorMessage = "Lỗi mạng hoặc server: $e";
    }

    isLoading = false;
    notifyListeners();
  }
}
