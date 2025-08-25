import 'package:flutter/material.dart';

/// listItem dọc
/// class này dùng để tạo một ListTile với viền hồng và bóng đổ
/// nó sẽ có viền hồng và bóng đổ khi được focus
class CustomItemVertical extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String genre;
  final double rating;

  const CustomItemVertical({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.genre,
    required this.rating,
  });

  @override
  State<CustomItemVertical> createState() => _CustomItemVerticalState();
}

class _CustomItemVerticalState extends State<CustomItemVertical> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 1.2); // Phóng to nhẹ
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0); // Trở lại bình thường
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0); // Khi không tap nữa
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Kích thước responsive
    final double itemWidth = screenWidth * 0.4;
    final double imageHeight = itemWidth * 1.2;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Container(
          width: itemWidth,
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE + RATING
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                    child: Image.network(
                      widget.imageUrl,
                      width: double.infinity,
                      height: imageHeight,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // TITLE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              // GENRE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.genre,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

///listItem ngang
////// class Color.fromARGB(255, 138, 108, 118) tạo một ListTile với viền hồng và bóng đổ
////// nó sẽ có viền hồng và bóng đổ khi được focus
/// Card ngang hiển thị phim, responsive theo kích thước thiết bị.
/// Cho phép ép kích thước bằng các tham số:
/// - [maxWidth]: bề rộng tối đa của card
/// - [maxHeight]: chiều cao tối đa của card
/// - [imageRatio]: % bề rộng card dành cho ảnh (0.18 -> 0.50)
/// - [imageAspect]: tỉ lệ ảnh (width/height), mặc định 5/7 (poster dọc)
class ListItemNgang extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int year;
  final int duration; // minutes
  final String ageRating; // e.g. PG-13
  final List<String> genres;
  final double rating;
  final bool isPremium;
  final bool isSneakshow;

  // -------- Responsive overrides (optional) --------
  final double? maxWidth; // ép bề rộng tối đa của card
  final double? maxHeight; // ép chiều cao tối đa của card
  final double? imageRatio; // tỉ lệ chiều rộng ảnh trong card
  final double imageAspect; // width/height poster, default 5/7

  const ListItemNgang({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.year,
    required this.duration,
    required this.ageRating,
    required this.genres,
    required this.rating,
    this.isPremium = false,
    this.isSneakshow = false,
    this.maxWidth,
    this.maxHeight,
    this.imageRatio,
    this.imageAspect = 5 / 7,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final screenW = MediaQuery.of(context).size.width;

        // Lấy cấu hình scale theo breakpoint
        final scale = ScaleConfig.forWidth(screenW);

        // Card width thực tế (nếu không set maxWidth -> dùng c.maxWidth)
        final double cardW =
            maxWidth != null ? maxWidth!.clamp(260.0, screenW) : c.maxWidth;

        // Tỉ lệ ảnh trong card
        final double imgRatio = (imageRatio ?? scale.imageRatio).clamp(
          0.18,
          0.50,
        );
        final double imgW = cardW * imgRatio;
        final double imgH = imgW / imageAspect;

        return Container(
          constraints: BoxConstraints(
            maxWidth: cardW,
            maxHeight: maxHeight ?? double.infinity,
          ),
          margin: EdgeInsets.symmetric(vertical: 6 * scale.k),
          padding: EdgeInsets.all(12 * scale.k),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12 * scale.k),
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withOpacity(0.1),
                blurRadius: 12 * scale.k,
                offset: Offset(4 * scale.k, 6 * scale.k),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- Poster ----------
              ClipRRect(
                borderRadius: BorderRadius.circular(12 * scale.k),
                child: Image.network(
                  imageUrl,
                  width: imgW,
                  height: imgH,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) =>
                          Icon(Icons.broken_image, size: 22 * scale.k),
                ),
              ),
              SizedBox(width: 12 * scale.k),

              // ---------- Details ----------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating + Premium + Sneakshow
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8 * scale.k,
                      runSpacing: 6 * scale.k,
                      children: [
                        _ratingChip(rating, scale),
                        if (isPremium)
                          _pill('Premium', Colors.deepOrange, scale),
                        if (isSneakshow) _pill('Sneakshow', Colors.pink, scale),
                      ],
                    ),
                    SizedBox(height: 10 * scale.k),

                    // Title
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16 * scale.k,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 6 * scale.k),

                    // Year + Duration + Age
                    Wrap(
                      spacing: 10 * scale.k,
                      runSpacing: 6 * scale.k,
                      children: [
                        _infoItem(
                          context,
                          Icons.calendar_today,
                          year.toString(),
                          scale,
                        ),
                        _infoItem(
                          context,
                          Icons.access_time,
                          "$duration Minutes",
                          scale,
                        ),
                        _ageBadge(ageRating, scale),
                      ],
                    ),
                    SizedBox(height: 8 * scale.k),

                    // Genres
                    Text(
                      genres.join(" | "),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12 * scale.k,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------- Sub widgets ----------
  Widget _ratingChip(double rating, ScaleConfig s) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6 * s.k, vertical: 2.2 * s.k),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(12 * s.k),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.white, size: 14 * s.k),
          SizedBox(width: 3 * s.k),
          Text(
            rating.toStringAsFixed(rating == rating.roundToDouble() ? 0 : 1),
            style: TextStyle(color: Colors.white, fontSize: 12 * s.k),
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, Color color, ScaleConfig s) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * s.k, vertical: 2.2 * s.k),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12 * s.k),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 12 * s.k),
      ),
    );
  }

  Widget _infoItem(
    BuildContext context,
    IconData icon,
    String text,
    ScaleConfig s,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14 * s.k, color: const Color(0xFF666666)),
        SizedBox(width: 4 * s.k),
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 12 * s.k,
          ),
        ),
      ],
    );
  }

  Widget _ageBadge(String ageRating, ScaleConfig s) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6 * s.k, vertical: 2 * s.k),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(4 * s.k),
      ),
      child: Text(
        ageRating,
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: 12 * s.k,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Helper scale config (public, không có dấu gạch dưới cho đỡ nhầm)
class ScaleConfig {
  /// Hệ số scale cho font/padding/radius/spacing…
  final double k;

  /// % bề rộng card dành cho ảnh (0.18 -> 0.50)
  final double imageRatio;

  const ScaleConfig(this.k, this.imageRatio);

  /// Tạo cấu hình theo độ rộng màn hình
  factory ScaleConfig.forWidth(double w) {
    if (w < 380) {
      // Compact: mobile nhỏ
      return const ScaleConfig(0.90, 0.32);
    } else if (w < 768) {
      // Medium: mobile lớn / tablet nhỏ
      return const ScaleConfig(1.00, 0.28);
    } else {
      // Spacious: tablet / desktop
      return const ScaleConfig(1.15, 0.22);
    }
  }
}
