import 'package:flutter/material.dart';

/// Card hiển thị phim theo chiều dọc
class CustomItemVertical extends StatefulWidget {
  final int idMovie;
  final String imageUrl;
  final String title;
  final List<dynamic> genre; // [{ma_the_loai: 27, ten_the_loai: "Kinh dị"}]
  final Map<String, dynamic> ageLimit; // {ma_gioi_han_tuoi: 12, ky_hieu: "C18"}
  final bool isSneakShow;
  final double totalRating;
  final int reviews;

  const CustomItemVertical({
    super.key,
    required this.idMovie,
    required this.imageUrl,
    required this.title,
    required this.genre,
    required this.ageLimit,
    required this.isSneakShow,
    required this.totalRating,
    required this.reviews,
  });

  @override
  State<CustomItemVertical> createState() => _CustomItemVerticalState();
}

class _CustomItemVerticalState extends State<CustomItemVertical> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final String genreText = widget.genre
        .map((g) => g["theLoai"]["ten_the_loai"] as String)
        .join(", ");

    final String ageLimitText = widget.ageLimit["ky_hieu"] ?? "P";

    return Container(
      height: 280,
      width: 200,
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() => _isFocused = hasFocus);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: _isFocused ? Colors.pink : Colors.transparent,
              width: 2,
            ),
          ),
          elevation: _isFocused ? 8 : 3,
          shadowColor: Colors.pinkAccent.withOpacity(0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Poster phim
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      "https://image.tmdb.org/t/p/w500${widget.imageUrl}",
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(
                            height: 180,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.broken_image, size: 40),
                          ),
                    ),
                  ),
                  if (widget.isSneakShow) ...[
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "Sneak Show",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              /// Nội dung
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Tên phim
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    /// Thể loại
                    Text(
                      genreText,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Age limit + Sneak show
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                ageLimitText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        /// Rating
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              "${widget.totalRating.toStringAsFixed(1)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              " (${widget.reviews})",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
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
