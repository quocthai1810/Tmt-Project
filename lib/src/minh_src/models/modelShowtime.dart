// models/showtime_models.dart
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

class Movie {
  final int id;
  final String title;
  final String poster;
  final List<Genre> genres;
  final AgeLimit ageLimit;
  final List<Showtime> showtimes;

  Movie({
    required this.id,
    required this.title,
    required this.poster,
    required this.genres,
    required this.ageLimit,
    required this.showtimes,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json["ma_phim"],
      title: json["ten_phim"],
      poster: json["anh_poster"],
      genres:
          (json["theloai"] as List)
              .map((e) => Genre.fromJson(e["theLoai"]))
              .toList(),
      ageLimit: AgeLimit.fromJson(json["gioi_han_tuoi"]),
      showtimes:
          (json["suat_chieu"] as List)
              .map((e) => Showtime.fromJson(e))
              .toList(),
    );
  }
}
