import 'dart:math' as math;
import 'package:flutter/material.dart';

/// CustomLoading
/// - Hai chấm đối diện (dualOpposite) quay đồng bộ
/// - Trail mờ phía sau mỗi chấm
/// - BẮT BUỘC truyền width/height (không còn 'size' vuông)
class CustomLoading extends StatefulWidget {
  /// Ảnh (asset) hiển thị ở giữa
  final String imageAsset;

  /// Kích thước tổng thể
  final double width;
  final double height;

  /// Bán kính quỹ đạo (từ tâm logo tới chấm). Nếu null -> auto theo cạnh ngắn.
  final double? orbitRadius;

  /// Kích thước logo ở giữa. Nếu null -> auto theo cạnh ngắn.
  final double? logoSize;

  /// Kích thước chấm quay
  final double dotSize;

  /// Màu chấm quay (nếu null -> dùng Theme.of(context).colorScheme.primary)
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

  /// Bật chế độ 2 chấm đối diện nhau (0° & 180°) quay đồng bộ
  final bool dualOpposite;

  const CustomLoading({
    super.key,
    this.imageAsset = "assets/img/logo.png",
    required this.width,
    required this.height,
    this.orbitRadius,
    this.logoSize,
    this.dotSize = 14,
    this.dotColor,
    this.period = const Duration(seconds: 2),
    this.showOrbitRing = false, // tắt viền mặc định cho gọn
    this.orbitStrokeWidth = 2.0,
    this.orbitColor = const Color(0x44FFFFFF),
    this.satelliteCount = 1,
    this.trailCount = 6,
    this.trailGapDeg = 10,
    this.trailOpacityStart = 0.45,
    this.trailMinScale = 0.35,
    this.dualOpposite = true, // mặc định 2 chấm đối diện
  });

  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading>
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
    final w = widget.width;
    final h = widget.height;
    final shortest = math.min(w, h);

    // Auto tính nếu không truyền
    final radius = (widget.orbitRadius ?? shortest * 0.4).clamp(
      0.0,
      shortest / 2 - 2.0,
    );
    final logoSize = widget.logoSize ?? shortest * 0.64;

    // Màu chấm lấy từ Theme nếu không override
    final dotColor = widget.dotColor ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Logo ở giữa
          SizedBox(
            width: logoSize,
            height: logoSize,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(widget.imageAsset, fit: BoxFit.cover),
            ),
          ),

          // Vòng quỹ đạo mờ (tuỳ chọn)
          if (widget.showOrbitRing)
            CustomPaint(
              size: Size(w, h),
              painter: _OrbitRingPainter(
                radius: radius.toDouble(),
                strokeWidth: widget.orbitStrokeWidth,
                color: widget.orbitColor,
              ),
            ),

          // Vệ tinh + trail
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) {
              final baseAngle = _ctrl.value * 2 * math.pi; // 0 -> 2π

              List<double> phases;
              if (widget.dualOpposite) {
                // Hai chấm đối diện nhau, cùng quay đồng bộ
                phases = const [0, math.pi];
              } else {
                // Phân bố đều tuỳ theo satelliteCount
                phases = List.generate(
                  widget.satelliteCount,
                  (i) => (2 * math.pi / widget.satelliteCount) * i,
                );
              }

              return Stack(
                alignment: Alignment.center,
                children: [
                  for (final p in phases)
                    _OrbitDotWithTrail(
                      angle: baseAngle + p,
                      radius: radius.toDouble(),
                      dotSize: widget.dotSize,
                      color: dotColor,
                      trailCount: widget.trailCount,
                      trailGapRad: (widget.trailGapDeg * math.pi) / 180,
                      trailOpacityStart: widget.trailOpacityStart,
                      trailMinScale: widget.trailMinScale,
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Vẽ vòng quỹ đạo (hình tròn)
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

/// Một vệ tinh + chuỗi trail mờ phía sau
class _OrbitDotWithTrail extends StatelessWidget {
  final double angle; // góc hiện tại của vệ tinh
  final double radius; // bán kính quỹ đạo
  final double dotSize;
  final Color color;
  final int trailCount;
  final double trailGapRad; // khoảng cách góc giữa các vệt
  final double trailOpacityStart; // alpha bắt đầu của vệt đầu tiên
  final double trailMinScale; // scale nhỏ nhất của vệt cuối

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
    // Khung bao quanh quỹ đạo để dễ đặt Align(topCenter)
    final orbitBox = Size(radius * 2, radius * 2);

    // Tính các vệt trail lùi sau theo góc âm
    final trails = List.generate(trailCount, (i) {
      final t = (i + 1) / (trailCount + 1);
      final opacity = trailOpacityStart * (1 - t); // giảm dần
      final scale =
          (1 - t) * (1 - trailMinScale) +
          trailMinScale; // từ ~1 -> trailMinScale
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

    // Chấm chính (đặt cuối để ở trên cùng)
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

/// Chấm tròn có bóng mờ
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
        color: color, // đã lấy theo theme ở trên nếu không override
        shape: BoxShape.circle,
        boxShadow: shadow,
      ),
    );
  }
}
