import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tmt_project/core/constants/env.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tmt_project/core/widgets/tin/custom_dialog.dart';
import 'package:tmt_project/core/widgets/tin/overlay_loading.dart';
import 'package:url_launcher/url_launcher.dart';

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
        error = "Không thể lấy dữ liệu";
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
        errorTakeAll = "Không thể lấy dữ liệu";
      }
    } catch (e) {
      errorTakeAll = "Lỗi mạng !";
      print(e);
    }
    isLoadingTakeAll = false;
    notifyListeners();
  }

  dynamic getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check GPS
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      errorNear = "Vui lòng bật GPS để tiếp tục";
      notifyListeners();
      return [null, null];
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        errorNear = "Ứng dụng cần quyền vị trí để hoạt động.";
        notifyListeners();
        return [null, null];
      }
    }

    if (permission == LocationPermission.deniedForever) {
      errorNear = "Bạn đã từ chối quyền vĩnh viễn. Hãy mở Cài đặt để bật lại.";
      notifyListeners();
      return [null, null];
    }

    // Bật loading
    isLoadingNear = true;
    errorNear = null;
    notifyListeners();

    try {
      // Lấy vị trí với timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 5));

      return [position.latitude, position.longitude];
    } catch (e) {
      errorNear = "Không lấy được vị trí (timeout)";
      isLoadingNear = false;
      notifyListeners();
      return [null, null];
    }
  }

  dynamic layRapGan() async {
    try {
      isLoadingNear = true; // 🔥 thêm dòng này để chắc chắn
      notifyListeners();

      final response = await http
          .post(
            Uri.parse("$apiTMT/RapPhim/LayRapPhimGanNhat"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"vi_do": viDo, "kinh_do": kinhDo}),
          )
          .timeout(const Duration(seconds: 5));

      final layDuLieu = jsonDecode(response.body);

      if (response.statusCode == 200) {
        theaterNear = layDuLieu["data"];
        errorNear = null;
      } else {
        errorNear = "Không thể lấy dữ liệu";
      }
    } catch (e) {
      errorNear = "Lỗi mạng !";
      print(e);
    }

    isLoadingNear = false;
    notifyListeners();
  }

  Future<void> moBanDoChiDuong(
    BuildContext context,
    double rapViDo,
    double rapKinhDo,
  ) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra GPS bật chưa
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Vui lòng bật GPS để tiếp tục")));
      return;
    }

    // Kiểm tra quyền
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ứng dụng cần quyền vị trí để hoạt động.")),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Từ chối vĩnh viễn -> mở cài đặt
      showCustomDialog(
        context,
        title: "Cần quyền vị trí",
        content:
            "Bạn đã từ chối quyền vĩnh viễn. Vui lòng mở cài đặt để cấp lại quyền.",
        confirmText: "Mở Cài đặt",
        cancelText: "Đóng",
        isCancel: true,
        onConfirm: () {
          Geolocator.openAppSettings();
        },
      );
      return;
    }
    OverlayLoading.show(context);
    // Nếu đã có quyền thì lấy vị trí hiện tại
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final double myLat = position.latitude;
    final double myLng = position.longitude;

    // Link Google Maps chỉ đường
    final Uri googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&origin=$myLat,$myLng&destination=$rapViDo,$rapKinhDo&travelmode=driving",
    );

    await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    OverlayLoading.hide();
  }
}
