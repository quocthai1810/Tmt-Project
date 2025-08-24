import 'dart:math' as math;
import 'package:flutter/material.dart';

/// OrbitLoadingLogo - phiên bản Overlay tự động
/// - Gọi `OrbitLoadingLogo()` là hiện overlay phủ đen, khóa toàn bộ tương tác
/// - Hai chấm đối diện nhau quay đồng bộ + trail mờ
/// - Không cần truyền gì thêm; vẫn có option nếu muốn tùy chỉnh
class OrbitLoadingLogo extends StatefulWidget {
  /// Ảnh (asset) hiển thị ở giữa
  final String imageAsset;

  /// Kích thước loader (vuông) ở giữa màn
  final double size;

  /// Bán kính quỹ đạo (từ tâm logo tới chấm). Nếu null -> auto theo size
  final double? orbitRadius;

  /// Kích thước logo ở giữa. Nếu null -> auto theo size
  final double? logoSize;

  /// Kích thước chấm quay
  final double dotSize;

  /// Màu chấm quay (nếu null -> Theme.of(context).colorScheme.primary)
  final Color? dotColor;

  /// Thời gian hoàn thành 1 vòng
  final Duration period;

  /// Vẽ vòng quỹ đạo hay không
  final bool showOrbitRing;
  final double orbitStrokeWidth;
  final Color orbitColor;

  /// ====== Tuỳ chỉnh nâng cao ======
  /// Số lượng vệ tinh (bỏ qua nếu dualOpposite = true)
  final int satelliteCount;

  /// Số vệt mờ phía sau mỗi vệ tinh
  final int trailCount;

  /// Khoảng cách góc giữa các vệt (độ)
  final double trailGapDeg;

  /// Độ mờ bắt đầu của vệt mờ (0..1)
  final double trailOpacityStart;

  /// Vệt mờ sau cùng sẽ scale xuống còn bao nhiêu so với dotSize
  final double trailMinScale;

  /// Bật chế độ 2 chấm đối diện (0° & 180°) quay đồng bộ
  final bool dualOpposite;

  /// Cấu hình overlay
  final bool barrier; // có phủ đen & khóa tương tác không
  final bool
  barrierDismissible; // có cho chạm để tắt overlay không (mặc định: không)
  final Color barrierColor;

  const OrbitLoadingLogo({
    super.key,
    this.imageAsset = 'assets/img/logo.png',
    this.size = 220,
    this.orbitRadius,
    this.logoSize,
    this.dotSize = 14,
    this.dotColor,
    this.period = const Duration(seconds: 2),
    this.showOrbitRing = false,
    this.orbitStrokeWidth = 2.0,
    this.orbitColor = const Color(0x44FFFFFF),
    this.satelliteCount = 1,
    this.trailCount = 6,
    this.trailGapDeg = 10,
    this.trailOpacityStart = 0.45,
    this.trailMinScale = 0.35,
    this.dualOpposite = true,
    // overlay defaults
    this.barrier = true,
    this.barrierDismissible = false,
    this.barrierColor = const Color(0x55000000),
  });

  @override
  State<OrbitLoadingLogo> createState() => _OrbitLoadingLogoState();
}

class _OrbitLoadingLogoState extends State<OrbitLoadingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: widget.period,
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // loader visual
    final visual = _OrbitVisual(
      imageAsset: widget.imageAsset,
      size: widget.size,
      orbitRadius: widget.orbitRadius,
      logoSize: widget.logoSize,
      dotSize: widget.dotSize,
      dotColor: widget.dotColor ?? Theme.of(context).colorScheme.primary,
      period: widget.period,
      showOrbitRing: widget.showOrbitRing,
      orbitStrokeWidth: widget.orbitStrokeWidth,
      orbitColor: widget.orbitColor,
      satelliteCount: widget.satelliteCount,
      trailCount: widget.trailCount,
      trailGapDeg: widget.trailGapDeg,
      trailOpacityStart: widget.trailOpacityStart,
      trailMinScale: widget.trailMinScale,
      dualOpposite: widget.dualOpposite,
      controller: _ctrl,
    );

    // Overlay full-screen + khóa tương tác
    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.barrier)
          ModalBarrier(
            dismissible: widget.barrierDismissible,
            color: widget.barrierColor,
          ),
        Center(
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: visual,
          ),
        ),
      ],
    );
  }
}

/// ============ Phần visual nguyên bản (không xử lý overlay) ============
class _OrbitVisual extends StatelessWidget {
  final String imageAsset;
  final double size;
  final double? orbitRadius;
  final double? logoSize;
  final double dotSize;
  final Color dotColor;
  final Duration period;
  final bool showOrbitRing;
  final double orbitStrokeWidth;
  final Color orbitColor;
  final int satelliteCount;
  final int trailCount;
  final double trailGapDeg;
  final double trailOpacityStart;
  final double trailMinScale;
  final bool dualOpposite;
  final AnimationController controller;

  const _OrbitVisual({
    required this.imageAsset,
    required this.size,
    required this.orbitRadius,
    required this.logoSize,
    required this.dotSize,
    required this.dotColor,
    required this.period,
    required this.showOrbitRing,
    required this.orbitStrokeWidth,
    required this.orbitColor,
    required this.satelliteCount,
    required this.trailCount,
    required this.trailGapDeg,
    required this.trailOpacityStart,
    required this.trailMinScale,
    required this.dualOpposite,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final shortest = size;
    final radius = (orbitRadius ?? shortest * 0.4).clamp(
      0.0,
      shortest / 2 - 2.0,
    );
    final logo = logoSize ?? shortest * 0.64;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Logo giữa
        SizedBox(
          width: logo,
          height: logo,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child:
                imageAsset != null
                    ? Image.asset(
                      imageAsset!,
                      errorBuilder:
                          (context, error, stackTrace) => const Icon(
                            Icons.movie,
                            size: 64,
                            color: Colors.white,
                          ),
                    )
                    : const Icon(Icons.movie, size: 64, color: Colors.white),
          ),
        ),

        if (showOrbitRing)
          CustomPaint(
            size: Size(size, size),
            painter: _OrbitRingPainter(
              radius: radius.toDouble(),
              strokeWidth: orbitStrokeWidth,
              color: orbitColor,
            ),
          ),

        AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            final baseAngle = controller.value * 2 * math.pi;

            final phases =
                dualOpposite
                    ? const [0.0, math.pi]
                    : List<double>.generate(
                      satelliteCount,
                      (i) => (2 * math.pi / satelliteCount) * i,
                    );

            return Stack(
              alignment: Alignment.center,
              children: [
                for (final p in phases)
                  _OrbitDotWithTrail(
                    angle: baseAngle + p,
                    radius: radius.toDouble(),
                    dotSize: dotSize,
                    color: dotColor,
                    trailCount: trailCount,
                    trailGapRad: (trailGapDeg * math.pi) / 180,
                    trailOpacityStart: trailOpacityStart,
                    trailMinScale: trailMinScale,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _OrbitRingPainter extends CustomPainter {
  final double radius;
  final double strokeWidth;
  final Color color;

  const _OrbitRingPainter({
    required this.radius,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_OrbitRingPainter old) =>
      old.radius != radius ||
      old.strokeWidth != strokeWidth ||
      old.color != color;
}

class _OrbitDotWithTrail extends StatelessWidget {
  final double angle;
  final double radius;
  final double dotSize;
  final Color color;
  final int trailCount;
  final double trailGapRad;
  final double trailOpacityStart;
  final double trailMinScale;

  const _OrbitDotWithTrail({
    required this.angle,
    required this.radius,
    required this.dotSize,
    required this.color,
    required this.trailCount,
    required this.trailGapRad,
    required this.trailOpacityStart,
    required this.trailMinScale,
  });

  @override
  Widget build(BuildContext context) {
    final orbitBox = Size(radius * 2, radius * 2);

    final trails = List.generate(trailCount, (i) {
      final t = (i + 1) / (trailCount + 1);
      final opacity = trailOpacityStart * (1 - t);
      final scale = (1 - t) * (1 - trailMinScale) + trailMinScale;
      final trailAngle = angle - trailGapRad * (i + 1);

      return Transform.rotate(
        angle: trailAngle,
        child: SizedBox(
          width: orbitBox.width,
          height: orbitBox.height,
          child: Align(
            alignment: Alignment.topCenter,
            child: _Dot(
              size: dotSize * scale,
              color: color.withOpacity(opacity),
              shadow: [
                BoxShadow(
                  color: color.withOpacity(opacity * 0.6),
                  blurRadius: 8 * scale,
                  spreadRadius: 0.5,
                ),
              ],
            ),
          ),
        ),
      );
    });

    final mainDot = Transform.rotate(
      angle: angle,
      child: SizedBox(
        width: orbitBox.width,
        height: orbitBox.height,
        child: Align(
          alignment: Alignment.topCenter,
          child: _Dot(
            size: dotSize,
            color: color,
            shadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );

    return Stack(alignment: Alignment.center, children: [...trails, mainDot]);
  }
}

class _Dot extends StatelessWidget {
  final double size;
  final Color color;
  final List<BoxShadow>? shadow;

  const _Dot({required this.size, required this.color, this.shadow});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: shadow,
      ),
    );
  }
}
