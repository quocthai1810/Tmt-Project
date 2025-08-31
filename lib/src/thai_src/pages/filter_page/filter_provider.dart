import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tmt_project/core/constants/env.dart';

class FilterProvider extends ChangeNotifier {
  Map<int, String> categories = {};
  bool isLoading = false;
  String? error;

  Map<int, String> idTheLoai = {};
  bool isLoading2 = false;
  String? error2;

  Map<int, List<dynamic>> moviesByCategory = {};

  Future<void> layTheLoaiPhim() async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await http
          .get(Uri.parse("$apiTMT/Phim/LayTheLoai"))
          .timeout(const Duration(seconds: 5));

      final layDuLieu = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = layDuLieu["data"] as List<dynamic>;
        categories = {
          for (var item in data)
            item["ma_the_loai"] as int: item["ten_the_loai"] as String,
        };
      } else {
        error = layDuLieu["message"];
      }
    } catch (e) {
      error = "Lỗi mạng !";
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> layTheoTheLoai(int query) async {
    try {
      isLoading2 = true;
      final response = await http
          .get(Uri.parse("$apiTMT/Phim/TimPhimTheoTheLoai?matheloai=$query"))
          .timeout(const Duration(seconds: 5));
      final layDuLieu = jsonDecode(response.body);
      // print(layDuLieu);
      if (response.statusCode == 200) {
        final data = layDuLieu["data"] as List<dynamic>;
        
        // lưu danh sách phim theo categoryId
        moviesByCategory[query] = data;
      } else {
        error2 = layDuLieu["message"];
      }
    } catch (e) {
      error2 = "Lỗi mạng !";
      // print(e);
    }
    isLoading2 = false;
    notifyListeners();
  }
}
