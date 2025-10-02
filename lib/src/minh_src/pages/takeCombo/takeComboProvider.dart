import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tmt_project/src/minh_src/models/takeComboModel.dart';

class ComboProvider extends ChangeNotifier {
  List<ComboModel> combos = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchCombos({required int maHeThong}) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
          "https://tmtbackend.ddns.net/api/SuatChieu/LayDanhSachDoAn/$maHeThong",
        ),
      );

      debugPrint("🔗 Gọi API: ${response.request?.url}");
      debugPrint("📡 Status: ${response.statusCode}");
      debugPrint("📦 Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        // Nếu API trả list trực tiếp
        if (body is List) {
          combos = body.map((e) => ComboModel.fromJson(e)).toList();
        }
        // Nếu API bọc trong { data: [...] }
        else if (body is Map && body['data'] is List) {
          combos =
              (body['data'] as List)
                  .map((e) => ComboModel.fromJson(e))
                  .toList();
        } else {
          errorMessage = "Dữ liệu không đúng định dạng.";
        }
      } else {
        errorMessage = "Lỗi server: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage = "Lỗi kết nối: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
