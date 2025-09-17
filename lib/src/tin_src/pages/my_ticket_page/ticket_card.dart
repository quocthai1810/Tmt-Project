import 'package:flutter/material.dart';

class TicketCard extends StatelessWidget {
  final String movieName;
  final String cinema;
  final String date;
  final String hour;
  final String seats;
  final String bookingCode;
  final String posterPath;
  final String qrPath;

  const TicketCard({
    super.key,
    required this.movieName,
    required this.cinema,
    required this.date,
    required this.hour,
    required this.seats,
    required this.bookingCode,
    required this.posterPath,
    required this.qrPath,
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
          children: [
            // Poster
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.asset(
                posterPath,
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie + logo CGV
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        movieName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
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
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: Colors.white70),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          cinema,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoItem(title: "Date", value: date),
                      _InfoItem(title: "Hour", value: hour),
                      _InfoItem(title: "Seats", value: seats),
                    ],
                  ),
                ],
              ),
            ),

            // Divider răng cưa
            Container(
              height: 1,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black26, width: 1),
                ),
              ),
            ),

            // Booking + QR
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    "Mã xuất chiếu",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bookingCode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(qrPath),
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

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;
  const _InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// Custom clipper để tạo notch vé (2 lỗ tròn ở cạnh)
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const radius = 12.0;
    Path path = Path()
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
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
