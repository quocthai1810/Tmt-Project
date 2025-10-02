class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json["ma_the_loai"], name: json["ten_the_loai"]);
  }
}

class AgeLimit {
  final int id;
  final String kyHieu;
  final String moTa;

  AgeLimit({required this.id, required this.kyHieu, required this.moTa});

  factory AgeLimit.fromJson(Map<String, dynamic> json) {
    return AgeLimit(
      id: json["ma_gioi_han_tuoi"],
      kyHieu: json["ky_hieu"] ?? "",
      moTa: json["mo_ta"] ?? "",
    );
  }
}

class Showtime {
  final int id;
  final DateTime startTime;
  final DateTime endTime;
  final String type; // 2D / 3D

  Showtime({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.type,
  });

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      id: json["ma_suat_chieu"],
      startTime: DateTime.parse(json["thoi_gian_chieu"]),
      endTime: DateTime.parse(json["thoi_gian_ket_thuc"]),
      type: json["phong"]["loai_suat"]["ten_loai_suat"],
    );
  }
}
