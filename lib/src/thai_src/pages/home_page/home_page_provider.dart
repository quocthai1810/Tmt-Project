import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tmt_project/core/constants/env.dart';

class MovieProvider extends ChangeNotifier {
  /// lấy dữ liệu đang chiếu
  List moviesDangChieu = [];
  bool? isLoading;
  String? error;

  /// lấy dữ liệu phim sắp ra mắt
  List moviesSapRaMat = [];
  bool? isLoading2;
  String? error2;

  /// lấy dữ liệu phim đang hot
  List moviesDangHot = [];
  bool? isLoading3;
  String? error3;

  dynamic layPhimDangChieu() async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await http
          .get(Uri.parse("$apiTMT/Phim/LayPhimDangChieu"))
          .timeout(const Duration(seconds: 5));
      final layDuLieu = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = layDuLieu["data"];
        moviesDangChieu = data;
      } else {
        error = "Không thể lấy dữ liệu";
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
          .get(Uri.parse("$apiTMT/Phim/LayPhimSapChieu"))
          .timeout(const Duration(seconds: 5));
      final layDuLieu = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = layDuLieu["data"];
        moviesSapRaMat = data;
      } else {
        error2 = "Không thể lấy dữ liệu";
      }
    } catch (e) {
      error2 = "Lỗi mạng !";
    }
    isLoading2 = false;
    notifyListeners();
  }

  dynamic layPhimDangHot() async {
    try {
      isLoading3 = true;
      notifyListeners();
      final response = await http
          .get(Uri.parse("$apiTMT/Phim/LayPhimDangHot"))
          .timeout(const Duration(seconds: 5));
      final layDuLieu = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = layDuLieu["data"];
        moviesDangHot = data;
      } else {
        error3 = "Không thể lấy dữ liệu";
      }
    } catch (e) {
      error3 = "Lỗi mạng !";
    }
    isLoading3 = false;
    notifyListeners();
  }
}
