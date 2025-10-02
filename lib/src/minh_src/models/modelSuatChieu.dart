// models/suat_chieu_model.dart
class SuatChieuResponse {
  final int statusCode;
  final String message;
  final List<RapPhim> data;

  SuatChieuResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SuatChieuResponse.fromJson(Map<String, dynamic> json) {
    return SuatChieuResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: (json['data'] as List).map((e) => RapPhim.fromJson(e)).toList(),
    );
  }
}

class RapPhim {
  final int maRap;
  final String tenRap;
  final String diaChi;
  final List<PhongChieu> phongChieu;
  final int? maHeThong;

  RapPhim({
    required this.maRap,
    required this.tenRap,
    required this.diaChi,
    required this.phongChieu,
    this.maHeThong,
  });

  factory RapPhim.fromJson(Map<String, dynamic> json) {
    return RapPhim(
      maRap: json['ma_rap'],
      tenRap: json['ten_rap'],
      diaChi: json['dia_chi'],
      maHeThong: json['maHeThong'],
      phongChieu:
          (json['phong_chieu'] as List)
              .map((e) => PhongChieu.fromJson(e))
              .toList(),
    );
  }
}

class PhongChieu {
  final LoaiSuat loaiSuat;
  final List<SuatChieu> suatChieu;

  PhongChieu({required this.loaiSuat, required this.suatChieu});

  factory PhongChieu.fromJson(Map<String, dynamic> json) {
    return PhongChieu(
      loaiSuat: LoaiSuat.fromJson(json['loai_suat']),
      suatChieu:
          (json['suat_chieu'] as List)
              .map((e) => SuatChieu.fromJson(e))
              .toList(),
    );
  }
}

class LoaiSuat {
  final int maLoaiSuat;
  final String tenLoaiSuat;

  LoaiSuat({required this.maLoaiSuat, required this.tenLoaiSuat});

  factory LoaiSuat.fromJson(Map<String, dynamic> json) {
    return LoaiSuat(
      maLoaiSuat: json['ma_loai_suat'],
      tenLoaiSuat: json['ten_loai_suat'],
    );
  }
}

class SuatChieu {
  final int maSuatChieu;
  final DateTime thoiGianChieu;
  final DateTime thoiGianKetThuc;

  SuatChieu({
    required this.maSuatChieu,
    required this.thoiGianChieu,
    required this.thoiGianKetThuc,
  });

  factory SuatChieu.fromJson(Map<String, dynamic> json) {
    return SuatChieu(
      maSuatChieu: json['ma_suat_chieu'],
      thoiGianChieu: DateTime.parse(json['thoi_gian_chieu']),
      thoiGianKetThuc: DateTime.parse(json['thoi_gian_ket_thuc']),
    );
  }
}
