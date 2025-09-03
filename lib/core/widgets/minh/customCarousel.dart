import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tmt_project/routers/app_route.dart';

class Movie {
  final int id;
  final String imageUrl;
  final String title;
  final List<String> genres;
  final int topRank;
  final int rating;
  final String is16Plus;

  Movie({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.genres,
    required this.topRank,
    required this.rating,
    required this.is16Plus,
  });

  // chuyền Back - end
  factory Movie.fromJson(Map<String, dynamic> json, {int rank = 0}) {
    // Backend trả path poster (không có domain), cần nối baseUrl
    const String imgUrl = "https://image.tmdb.org/t/p/w500";
    return Movie(
      id: json["ma_phim"],
      imageUrl: imgUrl + (json["anh_poster"] ?? ""),
      title: json["ten_phim"] ?? "Chưa cập nhập",
      genres:
          (json["theloai"] as List<dynamic>? ?? [])
              .map((e) => e["theLoai"]["ten_the_loai"].toString())
              .toList(),
      topRank: rank,
      rating: json["tong_diem_danh_gia"],
      is16Plus: (json["gioi_han_tuoi"]["ky_hieu"] ?? 0),
    );
  }
}

/// Widget Carousel phim
class MovieCarousel extends StatelessWidget {
  final List<Movie> movies;
  const MovieCarousel({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const Center(child: Text("Không có phim để hiển thị"));
    }
    // Sắp xếp topRank trước
    movies.sort((a, b) => a.topRank.compareTo(b.topRank));
    return CarouselSlider.builder(
      itemCount: movies.length,
      itemBuilder: (context, index, realIdx) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouteNames.detailMovie,
              arguments: movie.id, // <-- truyền Movie object
            );
          },
          child: _MovieCard(movie: movie, width: 220),
        );
      },
      options: CarouselOptions(
        height: 320,
        viewportFraction: 0.6,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
      ),
    );
  }
}

/// Card hiển thị phim
class _MovieCard extends StatelessWidget {
  final Movie movie;
  final double width;
  const _MovieCard({required this.movie, required this.width});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(movie.imageUrl, fit: BoxFit.cover),
              Container(color: Colors.black26), // overlay nhẹ
              // Số thứ tự topRank
              Positioned(
                left: 12,
                right: 12, // thêm right để Row có đủ không gian
                bottom: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Rank
                    Text(
                      "${movie.topRank}",
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        foreground:
                            Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.white, // màu viền
                      ),
                    ),
                    // Rating
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(
                          0.5,
                        ), // nền mờ cho dễ đọc
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 6),
                            ],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${movie.rating}/10",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 6),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Badge sneakshow + 16+
              Positioned(
                top: 10,
                left: 10,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: _Badge(
                        label: movie.is16Plus,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              // Tên + thể loại
              Positioned(
                left: 12,
                right: 12,
                bottom: 64,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.genres.join(", "),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Trạng thái phim (đang chiếu, sắp chiếu)
class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
