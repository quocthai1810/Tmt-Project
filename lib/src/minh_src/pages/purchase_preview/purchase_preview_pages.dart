import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmt_project/src/minh_src/models/modelGhe.dart';
import 'package:tmt_project/src/minh_src/models/takeComboModel.dart';

class PurchasePreviewPages extends StatefulWidget {
  final String movieTitle;
  final String poster;
  final String theaterName;
  final String receiveDate;
  final String showTime;
  final List<GheModel> selectedSeats;
  final List<ComboModel> selectedCombos;

  const PurchasePreviewPages({
    super.key,
    required this.movieTitle,
    required this.poster,
    required this.theaterName,
    required this.receiveDate,
    required this.showTime,
    required this.selectedSeats,
    required this.selectedCombos,
  });

  @override
  State<PurchasePreviewPages> createState() => _PurchasePreviewPagesState();
}

class _PurchasePreviewPagesState extends State<PurchasePreviewPages>
    with SingleTickerProviderStateMixin {
  bool _isTorn = false;
  late final AnimationController _animController;
  late final Animation<double> _topShift;
  late final Animation<double> _bottomShift;

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
    final currencyFormat = NumberFormat('#,###', 'vi_VN');
    final width = MediaQuery.of(context).size.width * 0.85;
    const height = 880.0;
    const tearY = height * 0.7;

    final seatTotal = widget.selectedSeats.fold(0, (sum, g) => sum + g.giaTien);
    final comboTotal = widget.selectedCombos.fold(
      0,
      (sum, c) => sum + (c.gia * c.quantity),
    );
    final totalAll = seatTotal + comboTotal;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Xác nhận vé & QR')),
      body: Stack(
        children: [
          // ➕ QR code ở phía sau khi xé
          if (_isTorn)
            Positioned(
              top: tearY - 90,
              left: width / 2 - 100,
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
                      "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=TMT_Cinema_Ticket",
                      width: 200,
                      height: 150,
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Mã QR cho vé xem phim",
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

          // 🧾 Vé chính (kéo để xé)
          Center(
            child: GestureDetector(
              onHorizontalDragEnd: (_) => _completeTear(),
              child: SizedBox(
                width: width,
                height: height,
                child: Stack(
                  children: [
                    // 🔼 Nửa trên có scroll bên trong
                    Positioned(
                      top: _isTorn ? _topShift.value : 0,
                      child: ClipPath(
                        clipper: TicketTopClipper(
                          tearY: tearY,
                          jaggle: 10,
                          gap: 20,
                        ),
                        child: Container(
                          width: width,
                          height: height,
                          color: ticketBgColor,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 80),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: Image.network(
                                    widget.poster,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.movieTitle,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Rạp: ${widget.theaterName}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "Ngày: ${widget.receiveDate}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "Giờ: ${widget.showTime}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "Ghế: ${widget.selectedSeats.map((e) => e.viTriGhe).join(', ')}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ...widget.selectedSeats.map(
                                        (s) => Text(
                                          "• Vé ${s.tenLoaiGhe} - ${currencyFormat.format(s.giaTien)}đ",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ...widget.selectedCombos.map(
                                        (c) => Text(
                                          "• ${c.quantity}x ${c.tenCombo} - ${currencyFormat.format(c.gia * c.quantity)}đ",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Tổng cộng: ${currencyFormat.format(totalAll)}đ",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 🔽 Nửa dưới
                    Positioned(
                      top: _isTorn ? _bottomShift.value : 0,
                      child: ClipPath(
                        clipper: TicketBottomClipper(
                          tearY: tearY,
                          jaggle: 10,
                          gap: 20,
                        ),
                        child: Container(
                          width: width,
                          height: height,
                          color: ticketBgColor,
                        ),
                      ),
                    ),

                    // 👉 Hướng dẫn kéo
                    if (!_isTorn)
                      Positioned(
                        top: tearY + 15,
                        left: width / 2 - 40,
                        child: Row(
                          children: const [
                            Icon(Icons.swipe, size: 20, color: Colors.white70),
                            SizedBox(width: 4),
                            Text(
                              "Kéo để xé vé",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🎟️ CLIPPER - Nửa trên
class TicketTopClipper extends CustomClipper<Path> {
  final double tearY;
  final double jaggle;
  final double gap;

  TicketTopClipper({
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
  bool shouldReclip(TicketTopClipper old) => old.tearY != tearY;
}

// 🎟️ CLIPPER - Nửa dưới
class TicketBottomClipper extends CustomClipper<Path> {
  final double tearY;
  final double jaggle;
  final double gap;

  TicketBottomClipper({
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
  bool shouldReclip(TicketBottomClipper old) => old.tearY != tearY;
}
