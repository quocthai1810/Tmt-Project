import 'package:flutter/material.dart';

enum ToastType { success, error, warning, confirm }

/// sử dụng hàm này như sau:
/// CustomToast.show(
///   context,
///   message: "Lưu dữ liệu thành công!",
///   type: ToastType.success,
/// );
///
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

    final bgColor = backgroundColor ?? _getDefaultColor(type);
    final iconData = icon ?? _getDefaultIcon(type);
    final defaultTextColor = textColor ?? Colors.white;

    late OverlayEntry entry; // ⚠️ khai báo trước để gán callback

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
            onRemove: () => entry.remove(), // 🆕 remove chuẩn
          ),
    );

    overlay.insert(entry);
  }

  static Color _getDefaultColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Colors.pink;
      case ToastType.error:
        return Colors.pink;
      case ToastType.warning:
        return Colors.orange;
      case ToastType.confirm:
        return Colors.blueAccent;
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
      if (mounted) widget.onRemove(); // ✅ remove đúng cách
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: MediaQuery.of(context).size.width / 2 - widget.width / 2,
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
                    [
                      const BoxShadow(
                        color: Colors.black38,
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(4, 6), // 🔥 bóng nghiêng xuống phải
                      ),
                    ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, color: widget.textStyle.color),
                  const SizedBox(width: 12),
                  Expanded(
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
