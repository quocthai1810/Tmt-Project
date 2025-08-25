import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieProvider extends ChangeNotifier {
  
  /// lấy dữ liệu đang chiếu
  List moviesDangChieu = [];
  late bool isLoading = false;
  String? error;
  /// lấy dữ liệu phim sắp ra mắt
  List moviesSapRaMat = [];
  late bool isLoading2 = false;
  String? error2;

  dynamic layPhimDangChieu() async {
    isLoading = true;
    notifyListeners();
    final response = await http.get(
      Uri.parse("https://real-ducks-serve.loca.lt/api/Phim/LayPhimDangChieu"),
    );

    if (response.statusCode == 200) {
      final layDuLieu = jsonDecode(response.body);
      final data = layDuLieu["data"];
      moviesDangChieu = data;
    } else {
      error = "Không load được dữ liệu";
      print(error);
    }
    isLoading = false;
    notifyListeners();
  }

  dynamic layPhimSapRaMat() async {
    isLoading2 = true;
    notifyListeners();
    final response = await http.get(
      Uri.parse("https://real-ducks-serve.loca.lt/api/Phim/LayPhimDangChieu"),
    );

    if (response.statusCode == 200) {
      final layDuLieu = jsonDecode(response.body);
      final data = layDuLieu["data"];
      moviesSapRaMat = data;
    } else {
      error2 = "Không load được dữ liệu";
      print(error);
    }
    isLoading2 = false;
    notifyListeners();
  }
  
}
