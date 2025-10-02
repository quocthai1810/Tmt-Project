import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tmt_project/src/minh_src/models/modelGhe.dart';

class GheProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<GheModel> danhSachGhe = [];

  Future<void> fetchGheTheoPhong({
    required int maPhong,
    required int maSuatChieu,
    z,
  }) async {
    isLoading = true;
    errorMessage = null;
    danhSachGhe = [];
    notifyListeners();

    final url =
        "https://tmtbackend.ddns.net/api/SuatChieu/LayDanhSachGheTheoPhong?maphong=$maPhong&masuatchieu=$maSuatChieu";

    try {
      final res = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['statusCode'] == 200 && body['data'] != null) {
          final List<dynamic> gheJsonList = body['data']['danh_sach_ghe'];
          danhSachGhe =
              gheJsonList.map((json) => GheModel.fromJson(json)).toList();
        } else {
          errorMessage = body['message'] ?? 'Dữ liệu không hợp lệ';
        }
      } else {
        errorMessage = 'Lỗi HTTP ${res.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Lỗi mạng hoặc server: $e';
    }

    isLoading = false;
    notifyListeners();
  }
}
