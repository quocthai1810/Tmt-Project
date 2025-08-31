import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tmt_project/core/constants/env.dart';

class SearchProvider extends ChangeNotifier {
  List searchMovies = [];
  bool isLoading = false;
  String? error;



  /// Hàm tìm phim theo query
  Future<void> updateSearch(String query) async {
    if (query.isEmpty) {
      searchMovies = [];
      notifyListeners();
      return;
    }
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await http
          .get(
            Uri.parse("$apiTMT/Phim/TimPhim?tenphim=$query"),
          )
          .timeout(const Duration(seconds: 5));

      final layDuLieu = jsonDecode(response.body);

      if (response.statusCode == 200) {
        searchMovies = layDuLieu["data"] ?? [];
      } else {
        error = layDuLieu["message"] ?? "Lỗi không xác định";
      }
    } catch (e) {
      error = "Lỗi mạng !";
    }

    isLoading = false;
    notifyListeners();
  }
}
