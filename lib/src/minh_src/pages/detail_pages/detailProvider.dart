import 'package:http/http.dart' as http;
import 'package:tmt_project/core/constants/env.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class Detailprovider extends ChangeNotifier {
  Map<String, dynamic>? thongTinPhim;
  bool? isLoadingDetail;
  String? errorDetail;

  Future<void> fetchDetails(int id) async {
    try {
      isLoadingDetail = true;
      errorDetail = null;
      notifyListeners();

      final response = await http
          .get(Uri.parse("$apiTMT/Phim/LayThongTinPhim/$id"))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final layDuLieu = jsonDecode(response.body);

        if (layDuLieu["statusCode"] == 200 && layDuLieu["data"] != null) {
          final data = layDuLieu["data"];

          // Convert các đường dẫn ảnh sang URL đầy đủ
          data["anh_poster"] = baseImageUrl + (data["anh_poster"] ?? "");
          data["anh_header"] = baseImageUrl + (data["anh_header"] ?? "");

          // Bổ sung mô tả cho key mo_ta để khớp với UI
          data["mo_ta"] = data["tom_tat"] ?? "";

          // Gán dữ liệu vào provider
          thongTinPhim = data;
        } else {
          thongTinPhim = null;
          errorDetail = "Dữ liệu trả về không hợp lệ.";
        }
      } else {
        thongTinPhim = null;
        errorDetail = "Không lấy được dữ liệu: ${response.statusCode}";
      }
    } catch (e) {
      thongTinPhim = null;
      errorDetail = "Lỗi mạng hoặc server: $e";
    }

    isLoadingDetail = false;
    notifyListeners();
  }
}

class CommentProvider extends ChangeNotifier {
  List<String> comments = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchComments(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await http
          .get(Uri.parse("$apiTMT/BinhLuan/LayDanhSachBinhLuan/$id"))
          .timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        comments = List<String>.from(data['data'].map((e) => e['noi_dung']));
        error = null;
      } else {
        error = "Không lấy được bình luận.";
      }
    } catch (e) {
      error = "Lỗi mạng khi tải bình luận.";
    }

    isLoading = false;
    notifyListeners();
  }
}
