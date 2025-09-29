import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:intl/intl.dart';
import 'package:tmt_project/core/widgets/minh/customToast.dart';
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

class _PurchasePreviewPagesState extends State<PurchasePreviewPages> {
  bool isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final currencyFormat = NumberFormat('#,###', 'vi_VN');

    // 🔹 Tính tổng tiền
    final seatTotal = widget.selectedSeats.fold(0, (sum, g) => sum + g.giaTien);
    final comboTotal = widget.selectedCombos.fold(
      0,
      (sum, c) => sum + (c.gia * c.quantity),
    );
    final totalAll = seatTotal + comboTotal;

    return Scaffold(
      backgroundColor: color.inversePrimary,
      appBar: AppBar(
        backgroundColor: color.inversePrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: color.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Vé xem phim", style: TextStyle(color: color.primary)),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // 🔹 Poster phim
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  widget.poster,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        height: 180,
                        color: Colors.grey,
                        child: const Center(child: Icon(Icons.broken_image)),
                      ),
                ),
              ),

              // 🔹 Nội dung scroll
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🎬 ${widget.movieTitle}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoColumn(
                            "Ghế",
                            widget.selectedSeats
                                .map((g) => g.viTriGhe)
                                .join(", "),
                            color.primary,
                          ),
                          _infoColumn(
                            "Ngày",
                            widget.receiveDate,
                            color.primary,
                          ),
                          _infoColumn("Giờ", widget.showTime, color.primary),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Địa chỉ rạp",
                        style: TextStyle(color: color.primary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.theaterName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.primary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 🔹 Bảng vé + combo
                      _tableHeader(color.primary),
                      ...widget.selectedSeats.map(
                        (s) => _ticketRow(
                          color.primary,
                          "Vé ${s.tenLoaiGhe}",
                          "1",
                          "-",
                          "${currencyFormat.format(s.giaTien)}đ",
                        ),
                      ),
                      ...widget.selectedCombos.map(
                        (c) => _ticketRow(
                          color.primary,
                          "Combo",
                          "${c.quantity}",
                          c.tenCombo,
                          "${currencyFormat.format(c.gia * c.quantity)}đ",
                        ),
                      ),
                      const SizedBox(height: 12),
                      Divider(thickness: 1, color: color.outline),
                      const SizedBox(height: 4),
                      Text(
                        "Tổng cộng: ${currencyFormat.format(totalAll)}đ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 🔹 ZigZag
              CustomPaint(
                size: const Size(double.infinity, 10),
                painter: ZigZagPainter(),
              ),
              Transform.rotate(
                angle: 3.1416,
                child: CustomPaint(
                  size: const Size(double.infinity, 10),
                  painter: ZigZagPainter(),
                ),
              ),

              // 🔹 Swiper
              SizedBox(
                height: 150,
                child: Swiper(
                  itemCount: 3,
                  loop: false,
                  onIndexChanged: (index) async {
                    if (index == 1 && !isConfirmed) {
                      final result = await showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text("Xác nhận"),
                              content: const Text(
                                "Bạn có chắc chắn đồng ý với thông tin đã chọn không?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: const Text("Không"),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
                                  child: const Text("Đồng ý"),
                                ),
                              ],
                            ),
                      );
                      if (result == true) {
                        setState(() => isConfirmed = true);
                        CustomToast.show(
                          context,
                          message: "Đã xác nhận thành công!",
                          type: ToastType.success,
                        );
                      }
                    }
                  },
                  itemBuilder: (context, index) {
                    if (!isConfirmed && index == 0) {
                      return Center(
                        child: Text(
                          "Vuốt sang trái để chỉnh sửa\nVuốt sang phải để xác nhận",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: color.primary),
                        ),
                      );
                    } else if (!isConfirmed && index == 2) {
                      return const Center(
                        child: Text("Vui lòng xác nhận trước"),
                      );
                    } else if (isConfirmed && index == 0) {
                      return const Center(
                        child: Text("Trang xác nhận đã bị khoá"),
                      );
                    } else if (index == 1) {
                      return const Center(
                        child: Text(
                          "Tôi đồng ý với thông tin đã chọn",
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      );
                    } else if (index == 2) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            "https://api.qrserver.com/v1/create-qr-code/?size=200x50&data=barcode",
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Mã vé: #${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}",
                            style: TextStyle(color: color.primary),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== WIDGET PHỤ =====
  Widget _infoColumn(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: color)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _tableHeader(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _tableCell("Tên vé", color),
          _tableCell("Số lượng", color),
          _tableCell("Tên combo", color),
          _tableCell("Giá tiền", color),
        ],
      ),
    );
  }

  Widget _tableCell(String text, Color color) {
    return Expanded(
      child: Text(
        text,
        style: TextStyle(color: color),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _ticketRow(
    Color color,
    String tenVe,
    String soLuong,
    String tenCombo,
    String gia,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              tenVe,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ),
          Expanded(
            child: Text(
              soLuong,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ),
          Expanded(
            child: Text(
              tenCombo,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ),
          Expanded(
            child: Text(
              gia,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class ZigZagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.shade200
          ..style = PaintingStyle.fill;
    const zigzagHeight = 10.0;
    const zigzagWidth = 10.0;

    final path = Path()..moveTo(0, 0);
    for (double x = 0; x < size.width; x += zigzagWidth) {
      path.lineTo(x + zigzagWidth / 2, zigzagHeight);
      path.lineTo(x + zigzagWidth, 0);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
