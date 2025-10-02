import 'package:flutter/material.dart';

enum ToastType { success, error, warning, confirm }

/// Cách dùng:
/// CustomToast.show(
///   context,
///   message: "Lưu dữ liệu thành công!",
///   type: ToastType.success,
/// );
class CustomToast {
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.success,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? messageStyle,
    IconData? icon,
    double width = 300,
    double borderRadius = 10,
    List<BoxShadow>? boxShadow,
    Duration duration = const Duration(seconds: 3),
    Duration animationDuration = const Duration(milliseconds: 350),
  }) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    // ✅ Dùng ColorScheme từ Theme
    final bgColor = backgroundColor ?? _getDefaultColor(context, type);
    final iconData = icon ?? _getDefaultIcon(type);

    // Gợi ý: có thể dùng onPrimary/onSurface tuỳ bgColor, tạm để trắng cho rõ
    final defaultTextColor = textColor ?? Colors.white;

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder:
          (context) => _AnimatedToastOverlay(
            message: message,
            icon: iconData,
            width: width,
            borderRadius: borderRadius,
            bgColor: bgColor,
            textStyle:
                messageStyle ??
                TextStyle(color: defaultTextColor, fontSize: 14),
            boxShadow: boxShadow,
            duration: duration,
            animationDuration: animationDuration,
            onRemove: () => entry.remove(),
          ),
    );

    overlay.insert(entry);
  }

  // 🆕 Lấy màu mặc định theo Theme + loại toast
  static Color _getDefaultColor(BuildContext context, ToastType type) {
    final scheme = Theme.of(context).colorScheme;
    switch (type) {
      case ToastType.success:
        return scheme.primary; // yêu cầu của anh
      case ToastType.error:
        return scheme.error; // màu error theo theme
      case ToastType.warning:
        return scheme.tertiary; // tuỳ biến: cảnh báo
      case ToastType.confirm:
        return scheme.primary; // xác nhận: màu chủ đạo
    }
  }

  static IconData _getDefaultIcon(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.error:
        return Icons.cancel;
      case ToastType.warning:
        return Icons.warning;
      case ToastType.confirm:
        return Icons.info;
    }
  }
}

// ===========================
// ✨ Widget có animation mượt
// ===========================
class _AnimatedToastOverlay extends StatefulWidget {
  final String message;
  final IconData icon;
  final double width;
  final double borderRadius;
  final Color bgColor;
  final TextStyle textStyle;
  final List<BoxShadow>? boxShadow;
  final Duration duration;
  final Duration animationDuration;
  final VoidCallback onRemove;

  const _AnimatedToastOverlay({
    required this.message,
    required this.icon,
    required this.width,
    required this.borderRadius,
    required this.bgColor,
    required this.textStyle,
    required this.boxShadow,
    required this.duration,
    required this.animationDuration,
    required this.onRemove,
  });

  @override
  State<_AnimatedToastOverlay> createState() => _AnimatedToastOverlayState();
}

class _AnimatedToastOverlayState extends State<_AnimatedToastOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.animationDuration,
  );

  late final Animation<Offset> _slideAnimation = Tween<Offset>(
    begin: const Offset(0, -0.2),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  late final Animation<double> _fadeAnimation = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
    _controller.forward();

    Future.delayed(widget.duration, () async {
      await _controller.reverse();
      if (mounted) widget.onRemove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final left = (screen.width - widget.width) / 2;

    return Positioned(
      bottom: 40,
      left: left.clamp(8.0, screen.width - widget.width - 8.0), // an toàn mép
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: widget.width,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.bgColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow:
                    widget.boxShadow ??
                    const [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(4, 6),
                      ),
                    ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, color: widget.textStyle.color),
                  const SizedBox(width: 12),
                  // Expanded để text dài không tràn
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: screen.width * 0.8),
                    child: Text(widget.message, style: widget.textStyle),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
