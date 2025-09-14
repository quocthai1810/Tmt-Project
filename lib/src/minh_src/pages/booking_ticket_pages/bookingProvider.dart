import 'package:http/http.dart' as http;
import 'package:tmt_project/core/constants/env.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

// Provider để lấy danh sách cụm rạp
class CumRapProvider extends ChangeNotifier {
  Map<int, String>? cumRapMap = {};
  bool? isLoadingCumRap;
  String? errorCumRap;

  Future<void> fetchCumRap() async {
    try {
      isLoadingCumRap = true;
      errorCumRap = null;
      notifyListeners();

      final res = await http
          .get(
            Uri.parse("https://tmtbackend.ddns.net/api/RapPhim/LayTatCaCumRap"),
          )
          .timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        final layDuLieu = jsonDecode(res.body);
        if (layDuLieu["statusCode"] == 200 && layDuLieu["data"] != null) {
          final data = layDuLieu["data"];
          cumRapMap = {
            for (var item in data)
              item['ma_he_thong'] as int: item['ten_he_thong'] as String,
          };
        } else {
          cumRapMap = {};
          errorCumRap = "Dữ liệu trả về không hợp lệ.";
        }
      } else {
        cumRapMap = {};
        errorCumRap = "Không lấy được dữ liệu: ${res.statusCode}";
      }
    } catch (e) {
      cumRapMap = null;
      errorCumRap = "Lỗi mạng hoặc server: $e";
    }

    isLoadingCumRap = false;
    notifyListeners();
  }
}

// Provider để lấy danh sách rạp theo cụm rạp
class LayRapPhimProvider extends ChangeNotifier {
  Map<int, String>? cumRapMap = {};
  bool? isLoadingCumRap;
  String? errorCumRap;

  Future<void> fetchCumRap(int id) async {
    try {
      isLoadingCumRap = true;
      errorCumRap = null;
      notifyListeners();

      final res = await http
          .get(
            Uri.parse(
              "https://tmtbackend.ddns.net/api/RapPhim/LayTatCaRap/$id",
            ),
          )
          .timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        final layDuLieu = jsonDecode(res.body);
        if (layDuLieu["statusCode"] == 200 && layDuLieu["data"] != null) {
          final data = layDuLieu["data"];
          cumRapMap = {
            for (var item in data)
              item['ma_rap'] as int: item['ten_rap'] as String,
          };
        } else {
          cumRapMap = {};
          errorCumRap = "Dữ liệu trả về không hợp lệ.";
        }
      } else {
        cumRapMap = {};
        errorCumRap = "Không lấy được dữ liệu: ${res.statusCode}";
      }
    } catch (e) {
      cumRapMap = null;
      errorCumRap = "Lỗi mạng hoặc server: $e";
    }

    isLoadingCumRap = false;
    notifyListeners();
  }
}

class BookingProvider extends ChangeNotifier {
  Map<String, dynamic>? thongTinVe;
  bool? isLoadingVe;
  String? errorVe;

  Future<void> fetchThongTinVe(int id) async {
    try {
      isLoadingVe = true;
      errorVe = null;
      notifyListeners();

      final response = await http
          .get(Uri.parse("$apiTMT/DatVe/LayThongTinVe/$id"))
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
          thongTinVe = data;
        } else {
          thongTinVe = null;
          errorVe = "Dữ liệu trả về không hợp lệ.";
        }
      } else {
        thongTinVe = null;
        errorVe = "Không lấy được dữ liệu: ${response.statusCode}";
      }
    } catch (e) {
      thongTinVe = null;
      errorVe = "Lỗi mạng hoặc server: $e";
    }

    isLoadingVe = false;
    notifyListeners();
  }
}
