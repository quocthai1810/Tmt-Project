import 'package:http/http.dart' as http;
import 'package:tmt_project/core/constants/env.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tmt_project/src/minh_src/models/modelMovie.dart';
import 'package:tmt_project/src/minh_src/models/modelSuatChieu.dart';
import 'package:tmt_project/src/minh_src/models/modelShowtime.dart';

// Provider để lấy danh sách cụm rạp

class CumRapModel {
  final int maHeThong;
  final String tenHeThong;

  CumRapModel({required this.maHeThong, required this.tenHeThong});
}

class CumRapProvider extends ChangeNotifier {
  Map<int, String>? cumRapMap = {};
  List<CumRapModel> cumRapList = [];
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
          final data = layDuLieu["data"] as List;

          // ✅ Tạo danh sách CumRapModel
          cumRapList =
              data
                  .map(
                    (item) => CumRapModel(
                      maHeThong: item['ma_he_thong'] as int,
                      tenHeThong: item['ten_he_thong'] as String,
                    ),
                  )
                  .toList();

          // ✅ Đồng thời tạo map (nếu có dùng ở chỗ khác)
          cumRapMap = {
            for (var item in data)
              item['ma_he_thong'] as int: item['ten_he_thong'] as String,
          };
        } else {
          cumRapList = [];
          cumRapMap = {};
          errorCumRap = "Dữ liệu trả về không hợp lệ.";
        }
      } else {
        cumRapList = [];
        cumRapMap = {};
        errorCumRap = "Không lấy được dữ liệu: ${res.statusCode}";
      }
    } catch (e) {
      cumRapList = [];
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

// Provider để lấy danh sách suất chiếu của mã phim theo cụm rạp, ngày(yyyy-mm-d)
class SuatChieuProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<RapPhim> rapPhimList = [];

  Future<void> fetchSuatChieu({
    required int maPhim,
    required int maCumRap,
    required String ngay, // yyyy-MM-dd
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      rapPhimList = [];
      notifyListeners();

      final url =
          "https://tmtbackend.ddns.net/api/SuatChieu/LaySuatChieuTheoCumRapVaNgayVaMaPhim"
          "?maPhim=$maPhim&maCumRap=$maCumRap&ngay=$ngay";

      final res = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['statusCode'] == 200) {
          final response = SuatChieuResponse.fromJson(body);
          rapPhimList = response.data;
        } else {
          errorMessage = body['message'] ?? "Dữ liệu không hợp lệ";
        }
      } else {
        errorMessage = "HTTP ${res.statusCode}";
      }
    } catch (e) {
      errorMessage = "Lỗi: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

//Provider để lấy danh sách phim theo rạp và ngày (yyyy-mm-dd)
class ShowtimeProvider with ChangeNotifier {
  bool isLoading = false;
  List<Movie> movies = [];
  String? error;

  Future<void> fetchShowtimes({
    required int rapId,
    required String ngay,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final url =
        "https://tmtbackend.ddns.net/api/SuatChieu/LaySuatChieuTheoRap?id=$rapId&ngay=$ngay";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final data = body["data"] as List;

        movies = data.map((e) => Movie.fromJson(e)).toList();
      } else {
        error = "Lỗi server: ${response.statusCode}";
      }
    } catch (e) {
      error = "Lỗi mạng: $e";
    }

    isLoading = false;
    notifyListeners();
  }
}
// class BookingProvider extends ChangeNotifier {
//   Map<String, dynamic>? thongTinVe;
//   bool? isLoadingVe;
//   String? errorVe;

//   Future<void> fetchThongTinVe(int id) async {
//     try {
//       isLoadingVe = true;
//       errorVe = null;
//       notifyListeners();

//       final response = await http
//           .get(Uri.parse("$apiTMT/DatVe/LayThongTinVe/$id"))
//           .timeout(const Duration(seconds: 5));

//       if (response.statusCode == 200) {
//         final layDuLieu = jsonDecode(response.body);

//         if (layDuLieu["statusCode"] == 200 && layDuLieu["data"] != null) {
//           final data = layDuLieu["data"];

//           // Convert các đường dẫn ảnh sang URL đầy đủ
//           data["anh_poster"] = baseImageUrl + (data["anh_poster"] ?? "");
//           data["anh_header"] = baseImageUrl + (data["anh_header"] ?? "");

//           // Bổ sung mô tả cho key mo_ta để khớp với UI
//           data["mo_ta"] = data["tom_tat"] ?? "";

//           // Gán dữ liệu vào provider
//           thongTinVe = data;
//         } else {
//           thongTinVe = null;
//           errorVe = "Dữ liệu trả về không hợp lệ.";
//         }
//       } else {
//         thongTinVe = null;
//         errorVe = "Không lấy được dữ liệu: ${response.statusCode}";
//       }
//     } catch (e) {
//       thongTinVe = null;
//       errorVe = "Lỗi mạng hoặc server: $e";
//     }

//     isLoadingVe = false;
//     notifyListeners();
//   }
// }
