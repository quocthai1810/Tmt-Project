import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieProvider extends ChangeNotifier {
  /// lấy dữ liệu đang chiếu
  List moviesDangChieu = [];
  bool? isLoading;
  String? error;

  /// lấy dữ liệu phim sắp ra mắt
  List moviesSapRaMat = [];
  bool? isLoading2;
  String? error2;

  dynamic layPhimDangChieu() async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await http
          .get(Uri.parse("http://10.0.2.2:8080/api/Phim/LayPhimDangChieu"))
          .timeout(const Duration(seconds: 5));
      final layDuLieu = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = layDuLieu["data"];
        moviesDangChieu = data;
      } else {
        error = layDuLieu["message"];
      }
    } catch (e) {
      error = "Lỗi mạng !";
    }
    isLoading = false;
    notifyListeners();
  }

  dynamic layPhimSapRaMat() async {
    try {
      isLoading2 = true;
      notifyListeners();
      final response = await http
          .get(Uri.parse("http://10.0.2.2:8080/api/Phim/LayPhimSapChieu"))
          .timeout(const Duration(seconds: 5));
      final layDuLieu = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = layDuLieu["data"];
        moviesSapRaMat = data;
      } else {
        error2 = layDuLieu["message"];
      }
    } catch (e) {
      error2 = "Lỗi mạng !";
    }
    isLoading2 = false;
    notifyListeners();
  }
}
