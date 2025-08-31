import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tmt_project/core/constants/env.dart';
import 'package:geolocator/geolocator.dart';

class TheaterProvider extends ChangeNotifier {
  /// lấy dữ liệu tìm rạp phim
  List theaterMovies = [];
  bool? isLoading;
  String? error;

  /// lấy dữ liệu cho rạp phim (CGV, Lotte,...)
  List theaterTakeAll = [];
  bool isLoadingTakeAll = false;
  String? errorTakeAll;

  /// lấy dữ liệu cho rạp phim gần nhất
  List theaterNear = [];
  bool isLoadingNear = false;
  String? errorNear;
  double? viDo;
  double? kinhDo;

  dynamic layCacCumRap() async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await http
          .get(Uri.parse("$apiTMT/RapPhim/LayTatCaCumRap"))
          .timeout(const Duration(seconds: 5));
      final layDuLieu = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = layDuLieu["data"];
        theaterMovies = data;
      } else {
        error = layDuLieu["message"];
      }
    } catch (e) {
      error = "Lỗi mạng !";
    }
    isLoading = false;
    notifyListeners();
  }

  dynamic layTatCaRapPhim(int query) async {
    try {
      isLoadingTakeAll = true;
      final response = await http
          .get(Uri.parse("$apiTMT/RapPhim/LayTatCaRap/$query"))
          .timeout(const Duration(seconds: 5));
      final layDuLieu = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = layDuLieu["data"];
        theaterTakeAll = data;
      } else {
        errorTakeAll = layDuLieu["message"];
      }
    } catch (e) {
      errorTakeAll = "Lỗi mạng !";
      print(e);
    }
    isLoadingTakeAll = false;
    notifyListeners();
  }

  dynamic layRapGan() async {
    try {
      isLoadingNear = true;
      errorNear = null;
      notifyListeners();
      final response = await http
          .post(
            Uri.parse("$apiTMT/RapPhim/LayRapPhimGanNhat"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"vi_do": viDo, "kinh_do": kinhDo}),
          )
          .timeout(const Duration(seconds: 5));
      final layDuLieu = jsonDecode(response.body);
      print(layDuLieu);
      if (response.statusCode == 200) {
        final data = layDuLieu["data"];
        print(data);
        theaterNear = data;
      } else {
        errorNear = "Bạn cần cấp quyền vị trí";
        print(errorNear);
      }
    } catch (e) {
      errorNear = "Lỗi mạng !";
      print(e);
    }
    isLoadingNear = false;
    notifyListeners();
  }

  dynamic getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra dịch vụ GPS đã bật chưa
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Dịch vụ định vị chưa được bật!");
      return;
    }

    // Xin quyền
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Người dùng từ chối quyền vị trí");
        return [null, null];
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Người dùng từ chối vĩnh viễn quyền vị trí");
      return [null, null];
    }
    isLoadingNear = true;
    errorNear = null;
    notifyListeners();
    // Lấy tọa độ hiện tại
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return [position.latitude, position.longitude];
    // print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
  }
}
