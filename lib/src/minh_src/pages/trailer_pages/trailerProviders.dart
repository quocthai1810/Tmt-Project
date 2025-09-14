import 'package:http/http.dart' as http;
import 'package:tmt_project/core/constants/env.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class TrailerProvider extends ChangeNotifier {
  Map<String, dynamic>? thongTinPhim;
  List<String> genres = [];
  List<Map<String, String>> cast = [];
  String? trailerUrl;
  String? posterPath;
  String? movieTitle;
  String? summary;
  String? releaseDate;

  bool isLoadingDetail = false;
  String? errorDetail;

  Future<void> fetchMovieDetails(int id) async {
    isLoadingDetail = true;
    errorDetail = null;
    notifyListeners();

    try {
      final response = await http
          .get(
            Uri.parse(
              "https://tmtbackend.ddns.net/api/Phim/LayThongTinPhim/$id",
            ),
          )
          .timeout(const Duration(seconds: 5));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["data"] != null) {
        final movieData = data["data"];

        thongTinPhim = movieData;
        trailerUrl = movieData["link_trailer"];
        posterPath = movieData["anh_poster"];
        movieTitle = movieData["ten_phim"];
        summary = movieData["tom_tat"];
        releaseDate = movieData["ngay_phat_hanh"];

        // Genres
        genres = List<String>.from(
          movieData["theloai"].map(
            (g) => g["theLoai"]["ten_the_loai"]?.toString() ?? '',
          ),
        );

        // Cast
        cast =
            (movieData["phim_dienvien"] as List).map<Map<String, String>>((dv) {
              final dienVien = dv["dienVien"] ?? {};
              return {
                "name": dienVien["ten_dien_vien"]?.toString() ?? "",
                "character": dv["character"]?.toString() ?? "",
                "avatar": dienVien["avatar"]?.toString() ?? "",
              };
            }).toList();

        errorDetail = null;
      } else {
        errorDetail = "Không lấy được dữ liệu";
      }
    } catch (e) {
      errorDetail = "Lỗi mạng hoặc server: $e";
    }

    isLoadingDetail = false;
    notifyListeners();
  }
}
