import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tmt_project/core/constants/env.dart';

class VerificationProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  bool isOTPSent = false;
  bool isVerified = false;

  // gửi mã OTP qua email
  Future<void> sendOtpEmail(String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse("${apiTMT}/XacThuc/GuiMaOTPEmail");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final data = jsonDecode(response.body);
      print(data);

      if (response.statusCode == 200 && data["success"] == true) {
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

  // xác thực OTP
  Future<void> verifyOtp(String email, String otp) async {
    isLoading = true;
    errorMessage = null;
    isVerified = false;
    notifyListeners();

    try {
      final url = Uri.parse("${apiTMT}/XacThuc/XacThucMaOTPEmail");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        isVerified = true;
      } else {
        errorMessage = data["message"] ?? "Xác thực OTP thất bại";
      }
    } catch (e) {
      errorMessage = "Lỗi mạng: $e";
    }

    isLoading = false;
    notifyListeners();
  }
}
