import 'dart:math';
import 'package:flutter/material.dart';

class TicketTearVerticalDemo extends StatefulWidget {
  const TicketTearVerticalDemo({super.key});

  @override
  State<TicketTearVerticalDemo> createState() => _TicketTearVerticalDemoState();
}

class _TicketTearVerticalDemoState extends State<TicketTearVerticalDemo>
    with SingleTickerProviderStateMixin {
  bool _isTorn = false;

  late final AnimationController _animController;
  late final Animation<double> _topShift;
  late final Animation<double> _bottomShift;

  // ✅ Chỗ này đổi màu nền vé nhanh
  final Color ticketBgColor = const Color(0xFF9E3D3D);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _topShift = Tween<double>(
      begin: 0,
      end: -100,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _bottomShift = Tween<double>(
      begin: 0,
      end: 100,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _completeTear() {
    setState(() => _isTorn = true);
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.85;
    const height = 500.0;

    // Vị trí đường xé (30% chiều cao vé)
    const tearY = height * 0.7;

    const poster =
        'https://image.tmdb.org/t/p/w300/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg';

    return Scaffold(
      appBar: AppBar(title: const Text('Tear Vertical Ticket Demo')),
      body: Center(
        child: GestureDetector(
          onHorizontalDragEnd: (_) => _completeTear(),
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: [
                // ✅ QR code bên dưới cùng (ẩn ban đầu, hiện khi xé)
                if (_isTorn)
                  Positioned(
                    top: tearY - 90, // Canh chính giữa khoảng trống xé
                    left: width / 2 - 130,
                    child: Container(
                      width: 250,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Image.network(
                            "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=Demo_Movie_Ticket",
                            width: 200,
                            height: 150,
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Đây là mã code của vé xem phim",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ✅ Nửa trên của vé
                Positioned(
                  top: _isTorn ? _topShift.value : 0,
                  child: ClipPath(
                    clipper: _TicketTopClipper(
                      tearY: tearY,
                      jaggle: 10,
                      gap: 20,
                    ),
                    child: Container(
                      width: width,
                      height: height,
                      color: const Color(0xFF9E3D3D),
                      child: Column(
                        children: [
                          Image.network(poster, height: 200, fit: BoxFit.cover),
                          const SizedBox(height: 20),
                          const Text(
                            "Tên phim",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text("Rạp CGV Nguyễn Huệ"),
                          const Text("Ngày: 20/04/2025"),
                          const Text("Giờ: 19:30"),
                        ],
                      ),
                    ),
                  ),
                ),

                // ✅ Nửa dưới của vé
                Positioned(
                  top: _isTorn ? _bottomShift.value : 0,
                  child: ClipPath(
                    clipper: _TicketBottomClipper(
                      tearY: tearY,
                      jaggle: 10,
                      gap: 20,
                    ),
                    child: Container(
                      width: width,
                      height: height,
                      color: const Color(0xFF9E3D3D),
                    ),
                  ),
                ),

                // ✅ Hướng dẫn kéo
                if (!_isTorn)
                  Positioned(
                    top: tearY + 15,
                    left: width / 2 - 40,
                    child: Row(
                      children: const [
                        Icon(Icons.swipe, size: 20, color: Colors.white70),
                        SizedBox(width: 4),
                        Text(
                          "Kéo để xé",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Clipper nửa trên
class _TicketTopClipper extends CustomClipper<Path> {
  final double tearY;
  final double jaggle;
  final double gap;

  _TicketTopClipper({
    required this.tearY,
    required this.jaggle,
    required this.gap,
  });

  @override
  Path getClip(Size size) {
    final path =
        Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, tearY);

    double x = size.width;
    bool down = true;
    final rng = Random(42);
    while (x > 0) {
      final dx = gap;
      final nx = (x - dx).clamp(0.0, size.width);
      final y = tearY + (down ? jaggle : -jaggle);
      path.lineTo(nx, y);
      x = nx;
      down = !down;
    }

    path.lineTo(0, tearY);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_TicketTopClipper old) => old.tearY != tearY;
}

/// Clipper nửa dưới
class _TicketBottomClipper extends CustomClipper<Path> {
  final double tearY;
  final double jaggle;
  final double gap;

  _TicketBottomClipper({
    required this.tearY,
    required this.jaggle,
    required this.gap,
  });

  @override
  Path getClip(Size size) {
    final path =
        Path()
          ..moveTo(0, size.height)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width, tearY);

    double x = size.width;
    bool down = false;
    final rng = Random(42);
    while (x > 0) {
      final dx = gap;
      final nx = (x - dx).clamp(0.0, size.width);
      final y = tearY + (down ? jaggle : -jaggle);
      path.lineTo(nx, y);
      x = nx;
      down = !down;
    }

    path.lineTo(0, tearY);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_TicketBottomClipper old) => old.tearY != tearY;
}
