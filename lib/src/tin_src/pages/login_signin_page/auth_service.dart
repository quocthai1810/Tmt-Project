import 'package:dio/dio.dart';
import 'package:tmt_project/core/constants/env.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: apiTMT, // đổi thành base url trong app Tmt
      headers: {"Content-Type": "application/json"},
    ),
  );

  Future<Response> loginWithGoogle(String idToken) async {
    try {
      final response = await _dio.post(
        "/XacThuc/DangNhapBangGoogle",
        data: {"idToken": idToken},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
