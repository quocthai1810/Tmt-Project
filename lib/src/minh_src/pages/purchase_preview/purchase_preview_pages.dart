import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:tmt_project/core/widgets/minh/customToast.dart';

class PurchasePreviewPages extends StatefulWidget {
  const PurchasePreviewPages({super.key});

  @override
  State<PurchasePreviewPages> createState() => _PurchasePreviewPagesState();
}

class _PurchasePreviewPagesState extends State<PurchasePreviewPages> {
  bool isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

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
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  "https://picsum.photos/400/200",
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phim: Người Phụ Nữ",
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
                          "VIP, Thường, Couple",
                          color.primary,
                        ),
                        _infoColumn("Hàng", "11, 12, 16", color.primary),
                        _infoColumn("Ngày", "2 Thg 12", color.primary),
                        _infoColumn("Giờ", "19:30", color.primary),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text("Địa chỉ rạp", style: TextStyle(color: color.primary)),
                    const SizedBox(height: 4),
                    Text(
                      "CineMax, Hoàng Văn Thụ, Quận Gò Vấp",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _tableHeader(color.primary),
                    _ticketRow(color.primary),
                    const SizedBox(height: 12),
                    Divider(thickness: 1, color: color.outline),
                    const SizedBox(height: 4),
                    Text(
                      "Phương thức thanh toán: Chuyển khoản",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color.primary,
                      ),
                    ),
                  ],
                ),
              ),
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
                            (context) => AlertDialog(
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
                            "Mã vé: 25177255",
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

  Widget _ticketRow(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "Vé xem phim, Vé Couple, Vé Combo",
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ),
          Expanded(
            child: Text(
              "8 ghế",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ),
          Expanded(
            child: Text(
              "Bắp + Nước + Quà tặng",
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ),
          Expanded(
            child: Text(
              "990.000₫",
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
