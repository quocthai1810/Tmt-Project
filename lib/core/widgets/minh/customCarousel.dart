import 'package:flutter/rendering.dart'; // ScrollDirection
import 'dart:async'; // 🆕 Timer cho autoplay
import 'package:flutter/material.dart';

class Movie {
  final String imageUrl;
  final String title;
  final DateTime releaseDate;
  final bool isSneakshow;
  final bool is16Plus;
  final List<String> genres;
  final int topRank; // 🆕 phim thuộc Top mấy (1 = cao nhất)

  Movie({
    required this.imageUrl,
    required this.title,
    required this.releaseDate,
    required this.isSneakshow,
    required this.is16Plus,
    required this.genres,
    required this.topRank, // 🆕
  });
}

/// sử dung CustomCarousel để hiển thị danh sách phim
class UseCustomCarousel extends StatelessWidget {
  const UseCustomCarousel({super.key});

  // =================== DATA MẪU (có topRank) ===================
  List<Movie> get movieList => [
    Movie(
      imageUrl: "https://picsum.photos/id/1027/800/500",
      title: "Hành Trình Vũ Trụ",
      releaseDate: DateTime(2025, 8, 20),
      isSneakshow: true,
      is16Plus: false,
      genres: ["Hoạt hình", "Phiêu lưu", "Gia đình"],
      topRank: 1,
    ),
    Movie(
      imageUrl: "https://picsum.photos/id/1015/800/500",
      title: "Bí Ẩn Rừng Sâu",
      releaseDate: DateTime(2025, 7, 10),
      isSneakshow: false,
      is16Plus: true,
      genres: ["Kinh dị", "Ly kỳ"],
      topRank: 2,
    ),
    Movie(
      imageUrl: "https://picsum.photos/id/1003/800/500",
      title: "Cuộc Chiến Thời Gian",
      releaseDate: DateTime(2025, 6, 5),
      isSneakshow: true,
      is16Plus: true,
      genres: ["Hành động", "Khoa học viễn tưởng"],
      topRank: 3,
    ),
    Movie(
      imageUrl: "https://picsum.photos/id/1005/800/500",
      title: "Tình Yêu Và Bão Táp",
      releaseDate: DateTime(2025, 5, 1),
      isSneakshow: false,
      is16Plus: false,
      genres: ["Tình cảm", "Chính kịch"],
      topRank: 4,
    ),
    Movie(
      imageUrl: "https://picsum.photos/id/1021/800/500",
      title: "Thành Phố Mất Tích",
      releaseDate: DateTime(2025, 4, 12),
      isSneakshow: false,
      is16Plus: false,
      genres: ["Phiêu lưu", "Hành động"],
      topRank: 5,
    ),
    Movie(
      imageUrl: "https://picsum.photos/id/1035/800/500",
      title: "Cơn Mưa Sao Băng",
      releaseDate: DateTime(2025, 3, 3),
      isSneakshow: true,
      is16Plus: false,
      genres: ["Lãng mạn", "Giả tưởng"],
      topRank: 6,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomCarousel(movies: movieList);
  }
}

// =================== DATA MẪU (có topRank) ===================
List<Movie> get movieList => [
  Movie(
    imageUrl: "https://picsum.photos/id/1027/800/500",
    title: "Hành Trình Vũ Trụ",
    releaseDate: DateTime(2025, 8, 20),
    isSneakshow: true,
    is16Plus: false,
    genres: ["Hoạt hình", "Phiêu lưu", "Gia đình"],
    topRank: 1,
  ),
  Movie(
    imageUrl: "https://picsum.photos/id/1015/800/500",
    title: "Bí Ẩn Rừng Sâu",
    releaseDate: DateTime(2025, 7, 10),
    isSneakshow: false,
    is16Plus: true,
    genres: ["Kinh dị", "Ly kỳ"],
    topRank: 2,
  ),
  Movie(
    imageUrl: "https://picsum.photos/id/1003/800/500",
    title: "Cuộc Chiến Thời Gian",
    releaseDate: DateTime(2025, 6, 5),
    isSneakshow: true,
    is16Plus: true,
    genres: ["Hành động", "Khoa học viễn tưởng"],
    topRank: 3,
  ),
  Movie(
    imageUrl: "https://picsum.photos/id/1005/800/500",
    title: "Tình Yêu Và Bão Táp",
    releaseDate: DateTime(2025, 5, 1),
    isSneakshow: false,
    is16Plus: false,
    genres: ["Tình cảm", "Chính kịch"],
    topRank: 4,
  ),
  Movie(
    imageUrl: "https://picsum.photos/id/1021/800/500",
    title: "Thành Phố Mất Tích",
    releaseDate: DateTime(2025, 4, 12),
    isSneakshow: false,
    is16Plus: false,
    genres: ["Phiêu lưu", "Hành động"],
    topRank: 5,
  ),
  Movie(
    imageUrl: "https://picsum.photos/id/1035/800/500",
    title: "Cơn Mưa Sao Băng",
    releaseDate: DateTime(2025, 3, 3),
    isSneakshow: true,
    is16Plus: false,
    genres: ["Lãng mạn", "Giả tưởng"],
    topRank: 6,
  ),
];

@override
Widget build(BuildContext context) {
  return CustomCarousel(movies: movieList);
}

/// =================== CAROUSEL WRAPPER ===================
// =================== CUSTOM CAROUSEL CÓ RESPONSIVE ===================
class CustomCarousel extends StatelessWidget {
  final List<Movie> movies;
  const CustomCarousel({super.key, required this.movies});

  // Sắp xếp thứ tự top [2, 1, 3, 4, ...]
  List<Movie> orderForCarousel(List<Movie> src) {
    final sorted = [...src]..sort((a, b) => a.topRank.compareTo(b.topRank));
    final top1 = sorted.firstWhere((m) => m.topRank == 1);
    final top2 = sorted.firstWhere((m) => m.topRank == 2, orElse: () => top1);
    final rest = sorted.where((m) => m.topRank >= 3).toList();
    return [if (top2 != top1) top2, top1, ...rest];
  }

  @override
  Widget build(BuildContext context) {
    final ordered = orderForCarousel(movies);
    final screenWidth = MediaQuery.of(context).size.width;

    // =================== CONFIG THEO MÀN ===================
    final config = ResponsiveCarouselConfig.fromWidth(screenWidth);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ZoomFadeCarousel(
        movies: ordered,
        height: config.height,
        viewportFraction: config.viewportFraction,
        minScale: config.minScale,
        maxScale: config.maxScale,
        sideOpacity: 0.25,
        borderRadius: 10,
        autoplay: true,
        autoplayInterval: const Duration(seconds: 4),
        autoplayResumeDelay: const Duration(seconds: 4),
        autoplayAnimationDuration: const Duration(milliseconds: 450),
        autoplayCurve: Curves.easeOut,
        scaleBuilder: (t) {
          final eased = Curves.easeOutCubic.transform(t.clamp(0, 1));
          return config.maxScale - (config.maxScale - config.minScale) * eased;
        },
      ),
    );
  }
}

// =================== CẤU HÌNH THEO KÍCH THƯỚC ===================
class ResponsiveCarouselConfig {
  final double viewportFraction;
  final double height;
  final double minScale;
  final double maxScale;

  ResponsiveCarouselConfig({
    required this.viewportFraction,
    required this.height,
    required this.minScale,
    required this.maxScale,
  });

  factory ResponsiveCarouselConfig.fromWidth(double width) {
    if (width < 400) {
      return ResponsiveCarouselConfig(
        viewportFraction: 0.9,
        height: 300,
        minScale: 0.85,
        maxScale: 1.05,
      );
    } else if (width < 600) {
      return ResponsiveCarouselConfig(
        viewportFraction: 0.75,
        height: 330,
        minScale: 0.8,
        maxScale: 1.0,
      );
    } else {
      return ResponsiveCarouselConfig(
        viewportFraction: 0.6,
        height: 360,
        minScale: 0.75,
        maxScale: 0.95,
      );
    }
  }
}

/// =================== CAROUSEL CORE ===================
class ZoomFadeCarousel extends StatefulWidget {
  const ZoomFadeCarousel({
    super.key,
    required this.movies,
    this.height = 330,
    this.viewportFraction = .67,
    this.minScale = .66,
    this.maxScale = 1.0,
    this.sideOpacity = .25,
    this.borderRadius = 16,
    this.onPageChanged,
    this.scaleBuilder,
    // Autoplay
    this.autoplay = false,
    this.autoplayInterval = const Duration(seconds: 2),
    this.autoplayAnimationDuration = const Duration(milliseconds: 450),
    this.autoplayCurve = Curves.easeOut,
    this.autoplayResumeDelay = const Duration(
      seconds: 2,
    ), // ⏳ đợi sau khi thả tay
  });

  final List<Movie> movies;
  final double height;
  final double viewportFraction;
  final double minScale;
  final double maxScale;
  final double sideOpacity;
  final double borderRadius;
  final ValueChanged<int>? onPageChanged;
  final double Function(double t)? scaleBuilder;

  // Autoplay options
  final bool autoplay;
  final Duration autoplayInterval;
  final Duration autoplayAnimationDuration;
  final Curve autoplayCurve;
  final Duration autoplayResumeDelay; // ⏳

  @override
  State<ZoomFadeCarousel> createState() => _ZoomFadeCarouselState();
}

class _ZoomFadeCarouselState extends State<ZoomFadeCarousel> {
  late final PageController _controller;
  int _current = 1; // luôn mở ở index 1 (Top1 nằm giữa)

  Timer? _autoTimer;
  Timer? _resumeTimer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: _current,
    );
    _controller.addListener(_onScroll);
    _startAutoplay();
  }

  // ===== Autoplay helpers =====
  void _startAutoplay() {
    _autoTimer?.cancel();
    if (!widget.autoplay) return;
    _autoTimer = Timer.periodic(widget.autoplayInterval, (_) {
      if (!_controller.hasClients) return;
      final curr = _controller.page?.round() ?? _current;
      int next = curr + 1;
      if (next >= widget.movies.length) next = 0; // loop
      _controller.animateToPage(
        next,
        duration: widget.autoplayAnimationDuration,
        curve: widget.autoplayCurve,
      );
    });
  }

  void _stopAutoplay() {
    _autoTimer?.cancel();
    _autoTimer = null;
  }

  void _scheduleAutoplayResume() {
    _resumeTimer?.cancel();
    if (!widget.autoplay) return;
    _resumeTimer = Timer(widget.autoplayResumeDelay, () {
      if (!mounted) return;
      _startAutoplay();
    });
  }

  void _cancelAutoplayResume() {
    _resumeTimer?.cancel();
    _resumeTimer = null;
  }
  // ============================

  void _onScroll() {
    if (!_controller.hasClients) return;
    final page = _controller.page ?? _current.toDouble();
    final nearest = page.round();
    if (nearest != _current &&
        _controller.position.userScrollDirection == ScrollDirection.idle) {
      setState(() => _current = nearest);
      widget.onPageChanged?.call(_current);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _stopAutoplay();
    _cancelAutoplayResume();
    super.dispose();
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: Text('Không có phim để hiển thị')),
      );
    }

    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final side =
              (constraints.maxWidth * (1 - widget.viewportFraction)) / 2;

          // Pause khi kéo, thả tay -> đợi X giây rồi chạy lại
          return NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (!widget.autoplay) return false;
              if (n is ScrollStartNotification) {
                _stopAutoplay();
                _cancelAutoplayResume();
              } else if (n is ScrollEndNotification ||
                  (n is UserScrollNotification &&
                      n.direction == ScrollDirection.idle)) {
                _scheduleAutoplayResume();
              }
              return false;
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: side),
              child: PageView.builder(
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.movies.length,
                padEnds: true,
                clipBehavior: Clip.none,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      double page;
                      if (_controller.hasClients && _controller.page != null) {
                        page = _controller.page!;
                      } else {
                        page = _current.toDouble();
                      }

                      final dist = (index - page).abs();
                      final t = dist.clamp(0.0, 1.0);

                      final scale =
                          widget.scaleBuilder != null
                              ? widget.scaleBuilder!(t)
                              : _lerp(widget.maxScale, widget.minScale, t);

                      final opacity = _lerp(1.0, widget.sideOpacity, t);
                      final translateY = _lerp(0, 20, t);

                      final shadow = BoxShadow(
                        color: Colors.black.withOpacity(_lerp(.22, .08, t)),
                        blurRadius: _lerp(20, 8, t),
                        spreadRadius: _lerp(0, -1, t),
                        offset: Offset(0, _lerp(8, 2, t)),
                      );

                      final movie = widget.movies[index];

                      return Transform.translate(
                        offset: Offset(0, translateY),
                        child: Transform.scale(
                          scale: scale,
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: opacity,
                            child: _CarouselCard(
                              rank: movie.topRank, // số trong ảnh
                              imageUrl: movie.imageUrl,
                              title: movie.title,
                              genres: movie.genres,
                              borderRadius: widget.borderRadius,
                              shadow: shadow,
                              isActive: dist < 0.5,
                              isSneakshow: movie.isSneakshow,
                              is16Plus: movie.is16Plus,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                onPageChanged: (i) {
                  setState(() => _current = i);
                  widget.onPageChanged?.call(i);
                  if (widget.autoplay) {
                    _cancelAutoplayResume();
                    _scheduleAutoplayResume(); // reset đếm lại
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

/// =================== CARD ITEM ===================
class _CarouselCard extends StatelessWidget {
  const _CarouselCard({
    required this.rank,
    required this.imageUrl,
    required this.title,
    required this.genres,
    required this.borderRadius,
    required this.shadow,
    required this.isActive,
    this.isSneakshow = false,
    this.is16Plus = false,
  });

  final int rank;
  final String imageUrl;
  final String title;
  final List<String> genres;
  final double borderRadius;
  final BoxShadow shadow;
  final bool isActive;
  final bool isSneakshow;
  final bool is16Plus;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [shadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh + badge + số thứ tự
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(isActive ? 0.15 : 0.25),
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
                if (isSneakshow || is16Plus)
                  Positioned(
                    left: -6,
                    top: -2,
                    child: Row(
                      children: [
                        if (isSneakshow) const SneakshowBadge(),
                        if (isSneakshow && is16Plus) const SizedBox(width: 8),
                        if (is16Plus)
                          const _PillBadge(label: '16+', bg: Color(0xFFFFA000)),
                      ],
                    ),
                  ),
                // SỐ THỨ TỰ góc dưới-trái (stroke + fill)
                Positioned(
                  left: 12,
                  bottom: 10,
                  child: Stack(
                    children: [
                      Text(
                        "$rank",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          foreground:
                              Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 4
                                ..color = Colors.white,
                        ),
                      ),
                      Text(
                        "$rank",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // TÊN PHIM
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // THỂ LOẠI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              genres.join(", "),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                height: 1.1,
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// =================== BADGE WIDGETS ===================
class _PillBadge extends StatelessWidget {
  final String label;
  final Color bg;
  const _PillBadge({required this.label, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          height: 1,
        ),
      ),
    );
  }
}

class SneakshowBadge extends StatelessWidget {
  const SneakshowBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _SneakshowClipper(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        color: const Color(0xFF1E88E5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.videocam, size: 14, color: Colors.white),
            SizedBox(width: 6),
            Text(
              'SNEAKSHOW',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SneakshowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const rRight = 4.0;
    final path =
        Path()
          ..moveTo(0, 0)
          ..lineTo(size.width - rRight, 0)
          ..quadraticBezierTo(size.width, 0, size.width, rRight)
          ..lineTo(size.width, size.height - rRight)
          ..quadraticBezierTo(
            size.width,
            size.height,
            size.width - rRight,
            size.height,
          )
          ..lineTo(0, size.height)
          ..lineTo(0, 0)
          ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
