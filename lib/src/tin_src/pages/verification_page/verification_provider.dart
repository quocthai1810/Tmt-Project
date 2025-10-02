import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmt_project/core/constants/env.dart';

class VerificationProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  bool isOTPSent = false;
  bool isVerified = false;

  Future<void> sendOtpEmail(String email) async {
    await _sendOtp("${apiTMT}/XacThuc/GuiMaOTPEmail", {"email": email});
  }

  Future<void> sendOtpForgotPassword(String email) async {
    await _sendOtp("${apiTMT}/XacThuc/GuiMaOTPQuenMatKhau", {"email": email});
  }

  Future<void> verifyOtp(String email, String otp, String type) async {
    await _verifyOtp(
      "${apiTMT}/XacThuc/XacThucMaOTPEmail",
      {
        "email": email,
        "otp": otp,
      },
      email: email,
      type: type,
    );
  }

  Future<void> verifyOtpCreateNewPassword(
      String email,
      String otp,
      String newPassword,
      String type,
      ) async {
    await _verifyOtp(
      "${apiTMT}/XacThuc/DatLaiMatKhau",
      {
        "email": email,
        "otp": otp,
        "mat_khau_moi": newPassword,
      },
      email: email,
      type: type,
    );
  }

  Future<void> _sendOtp(String urlApi, Map<String, dynamic> body) async {
    isLoading = true;
    errorMessage = null;
    isOTPSent = false;
    notifyListeners();

    try {
      final url = Uri.parse(urlApi);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        isOTPSent = true;
      } else {
        errorMessage = data["message"] ?? "Không gửi được mã OTP";
      }
    } catch (e) {
      errorMessage = "Lỗi mạng: $e";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _verifyOtp(
      String urlApi,
      Map<String, dynamic> body, {
        required String email,
        required String type,
      }) async {
    isLoading = true;
    errorMessage = null;
    isVerified = false;
    notifyListeners();

    try {
      final url = Uri.parse(urlApi);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        isVerified = true;

        if (type == "register") {
          // 👉 Đăng ký thành công → lưu token + email + isLogin
          final token = data["data"]["accessToken"];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("accessToken", token);
          await prefs.setString("email", email);
          await _saveLoginState(true);
        } else {
          // 👉 Nếu là create_new_password thì clear token & email
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove("accessToken");
          await prefs.remove("email");
          await _saveLoginState(false);
        }
      } else {
        errorMessage = data["message"] ?? "Xác thực OTP thất bại";
        await _saveLoginState(false);
      }
    } catch (e) {
      errorMessage = "Lỗi mạng: $e";
      await _saveLoginState(false);
    }

    isLoading = false;
    notifyListeners();
  }

  void resetVerified() {
    isVerified = false;
    notifyListeners();
  }

  Future<void> _saveLoginState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLogin", value);
  }
}
