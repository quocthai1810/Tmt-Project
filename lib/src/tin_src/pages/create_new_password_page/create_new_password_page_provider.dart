import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // thêm vào
import 'package:tmt_project/core/constants/env.dart';

class CreateNewPasswordProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  bool isSuccess = false;

  Future<void> resetPassword({
    required String otp,
    required String newPassword,
  }) async {
    isLoading = true;
    errorMessage = null;
    isSuccess = false;
    notifyListeners();

    try {
      // 👉 lấy email trong SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString("email");

      if (email == null || email.isEmpty) {
        errorMessage = "Không tìm thấy email trong bộ nhớ";
        isLoading = false;
        notifyListeners();
        return;
      }

      final url = Uri.parse("${apiTMT}/XacThuc/DatLaiMatKhau");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
          "mat_khau_moi": newPassword,
        }),
      );

      final data = jsonDecode(response.body);
      debugPrint("Reset Password Response: $data");

      if (response.statusCode == 200) {
        isSuccess = true;

        // Xóa isLogin & accessToken trong SharedPreferences
        await prefs.remove("isLogin");
        await prefs.remove("accessToken");

        debugPrint("isLogin & accessToken đã bị xóa sau khi đổi mật khẩu");
      } else {
        errorMessage = data["message"] ?? "Đặt lại mật khẩu thất bại";
      }
    } catch (e) {
      errorMessage = "Lỗi mạng: $e";
    }

    isLoading = false;
    notifyListeners();
  }
}
