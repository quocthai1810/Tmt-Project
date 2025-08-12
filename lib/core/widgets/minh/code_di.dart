//Làm đi Minh nèeeeeeeeeeee

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';

class codeDiMinhoi extends StatefulWidget {
  const codeDiMinhoi({super.key});

  @override
  State<codeDiMinhoi> createState() => _codeDiMinhoiState();
}

class _codeDiMinhoiState extends State<codeDiMinhoi> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [SizedBox(height: 12), CustomCarousel(images: [])],
      ),
    );
  }
}

/// Carousel
class CustomCarousel extends StatelessWidget {
  final List<String> images;
  const CustomCarousel({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    final data =
        (images.isEmpty)
            ? [
              'https://picsum.photos/id/1027/800/500',
              'https://picsum.photos/id/1015/800/500',
              'https://picsum.photos/id/1003/800/500',
              'https://picsum.photos/id/1005/800/500',
              'https://picsum.photos/id/1021/800/500',
              'https://picsum.photos/id/1035/800/500',
            ]
            : images;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ZoomFadeCarousel(
        images: data,
        height: 280,
        viewportFraction: 0.67, // thấy rõ 2 bên, khít vừa
        minScale: 0.7, // fallback nếu không dùng scaleBuilder
        maxScale: 1.0,
        sideOpacity: 0.25,
        borderRadius: 10,

        // ✅ Tùy biến scale bằng callback:
        // t = 0 (ở giữa)  -> scale = 1.0
        // t = 1 (xa nhất) -> scale = 0.66 (≈ 2/3)
        scaleBuilder: (t) {
          // dùng easing để cảm giác mượt: giữa phình mạnh, ra rìa co nhanh
          final eased = Curves.easeOutCubic.transform(t.clamp(0, 1));
          return 1.02 -
              0.25 * eased; // trả dữ liệu về cho việc scale của widget to ra
        },
      ),
    );
  }
}

class ZoomFadeCarousel extends StatefulWidget {
  const ZoomFadeCarousel({
    super.key,
    required this.images,
    this.height = 280,
    this.viewportFraction = .67,
    this.minScale = .66,
    this.maxScale = 1.0,
    this.sideOpacity = .25,
    this.borderRadius = 16,
    this.onPageChanged,

    /// callback cho phép custom scale theo khoảng cách t (0..1)
    this.scaleBuilder,
  });

  final List<String> images;
  final double height;
  final double viewportFraction;
  final double minScale;
  final double maxScale;
  final double sideOpacity;
  final double borderRadius;
  final ValueChanged<int>? onPageChanged;

  /// Nếu set, sẽ dùng để tính scale thay vì minScale/maxScale.
  /// t: 0 (ở giữa) -> 1 (xa nhất)
  final double Function(double t)? scaleBuilder;

  @override
  State<ZoomFadeCarousel> createState() => _ZoomFadeCarouselState();
}

class _ZoomFadeCarouselState extends State<ZoomFadeCarousel> {
  late final PageController _controller;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: _current,
    );
    _controller.addListener(_onScroll);
  }

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
    super.dispose();
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: Text('Không có ảnh để hiển thị')),
      );
    }

    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final side =
              (constraints.maxWidth * (1 - widget.viewportFraction)) / 2;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: side),
            child: PageView.builder(
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.images.length,
              padEnds: true, // ảnh đầu/cuối vẫn căn giữa
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

                    // ✅ scale tùy biến
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

                    return Transform.translate(
                      offset: Offset(0, translateY),
                      child: Transform.scale(
                        scale: scale,
                        alignment: Alignment.center,
                        child: Opacity(
                          opacity: opacity,
                          child: _CarouselCard(
                            imageUrl: widget.images[index],
                            indexText: 'No. ${index + 1} image',
                            borderRadius: widget.borderRadius,
                            shadow: shadow,
                            isActive: dist < 0.5,
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
              },
            ),
          );
        },
      ),
    );
  }
}

class _CarouselCard extends StatelessWidget {
  const _CarouselCard({
    required this.imageUrl,
    required this.indexText,
    required this.borderRadius,
    required this.shadow,
    required this.isActive,
  });

  final String imageUrl;
  final String indexText;
  final double borderRadius;
  final BoxShadow shadow;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [shadow],
      ),
      // ❌ đừng clip container, để badge tràn ra ngoài
      // clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none, // ✅ cho phép tràn
        children: [
          // Chỉ clip riêng tấm ảnh để giữ bo góc
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),

          // overlay mờ chữ
          Container(color: Colors.black.withOpacity(isActive ? 0.15 : 0.25)),

          // ====== BADGES GÓC TRÊN-TRÁI (tràn ra ngoài) ======
          Positioned(
            left: -6, // ✅ âm để tràn ra ngoài như hình 2
            top: -2,
            child: Row(
              children: const [
                SneakshowBadge(), // pill xanh có mỏ nhọn
                SizedBox(width: 8),
                _PillBadge(label: '16+', bg: Color(0xFFFFA000)),
              ],
            ),
          ),

          // caption
          Positioned(
            left: 12,
            bottom: 12,
            child: Text(
              indexText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Pill cam reuse
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

// Pill xanh có mỏ nhọn bên trái
class SneakshowBadge extends StatelessWidget {
  const SneakshowBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _SneakshowClipper(), // tạo mỏ nhọn
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
    final rRight = 4.0; // bo nhẹ góc phải

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width - rRight, 0);
    path.quadraticBezierTo(size.width, 0, size.width, rRight);
    path.lineTo(size.width, size.height - rRight);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - rRight,
      size.height,
    );
    path.lineTo(0, size.height);

    // Mũi nhọn ngược vào trong
    path.lineTo(8, size.height / 2 + 6);
    path.lineTo(0, size.height / 2);
    path.lineTo(8, size.height / 2 - 6);

    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
