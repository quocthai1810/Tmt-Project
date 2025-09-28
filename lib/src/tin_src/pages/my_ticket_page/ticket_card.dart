import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketCard extends StatelessWidget {
  final String movieName;
  final String cinema;
  final String date;
  final String hour;
  final String seats;
  final String bookingCode;
  final String posterPath;

  const TicketCard({
    super.key,
    required this.movieName,
    required this.cinema,
    required this.date,
    required this.hour,
    required this.seats,
    required this.bookingCode,
    required this.posterPath,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketClipper(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C3A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh poster phim
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.asset(
                posterPath,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),

            // Thông tin chi tiết phim
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên phim và logo CGV
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          movieName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "CGV",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Tên rạp
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          cinema,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Thông tin ngày, giờ, ghế
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ThongTinItem(tieu: "Date", giaTri: date),
                      _ThongTinItem(tieu: "Hour", giaTri: hour),
                      _ThongTinItem(tieu: "Seats", giaTri: seats),
                    ],
                  ),
                ],
              ),
            ),

            // Đường phân cách với viền răng cưa
            Container(
              height: 1,
              child: Row(
                children: List.generate(
                  40,
                  (index) => Expanded(
                    child: Container(
                      height: 1,
                      color:
                          index % 2 == 0 ? Colors.white24 : Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),

            // Phần mã vé và QR code
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Mã xuất chiếu",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bookingCode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: QrImageView(
                        data: bookingCode,
                        version: QrVersions.auto,
                        size: 120.0,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThongTinItem extends StatelessWidget {
  final String tieu;
  final String giaTri;

  const _ThongTinItem({required this.tieu, required this.giaTri});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(tieu, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 6),
        Text(
          giaTri,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Tạo hình dạng vé với 2 lỗ tròn ở 2 bên
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const radius = 12.0;
    final path =
        Path()
          ..moveTo(0, 0)
          ..lineTo(0, size.height / 2 - radius)
          ..arcToPoint(
            Offset(0, size.height / 2 + radius),
            radius: const Radius.circular(radius),
            clockwise: false,
          )
          ..lineTo(0, size.height)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width, size.height / 2 + radius)
          ..arcToPoint(
            Offset(size.width, size.height / 2 - radius),
            radius: const Radius.circular(radius),
            clockwise: false,
          )
          ..lineTo(size.width, 0)
          ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
