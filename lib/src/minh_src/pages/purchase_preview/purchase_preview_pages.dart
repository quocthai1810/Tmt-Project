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
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Quay về trang trước
          },
        ),
        title: const Text("Vé xem phim", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Poster
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
              // Nội dung chính
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Phim: Người Phụ Nữ",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ghế",
                              style: TextStyle(color: Colors.black54),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "VIP, Thường, Couple",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Hàng",
                              style: TextStyle(color: Colors.black54),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "11, 12, 16",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Ngày",
                              style: TextStyle(color: Colors.black54),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "2 Thg 12",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Giờ",
                              style: TextStyle(color: Colors.black54),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "19:30",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Địa chỉ rạp",
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "CineMax, Hoàng Văn Thụ, Quận Gò Vấp",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    // HEADER table
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade300),
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            child: Text(
                              "Tên vé",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Số lượng",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Tên combo",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              "Giá tiền",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            child: Text(
                              "Vé xem phim, Vé Couple, Vé Combo",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "8 ghế",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Bắp + Nước + Quà tặng",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              "990.000₫",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(thickness: 1, color: Colors.black87),
                    const SizedBox(height: 4),
                    const Text(
                      "Phương thức thanh toán: Chuyển khoản",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                        setState(() {
                          isConfirmed = true;
                        });
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
                      return const Center(
                        child: Text(
                          "Vuốt sang trái để chỉnh sửa\nVuốt sang phải để xác nhận",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
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
                          const Text(
                            "Mã vé: 25177255",
                            style: TextStyle(color: Colors.black54),
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
