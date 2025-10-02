import 'package:tmt_project/src/minh_src/models/modelShowtime.dart';

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
