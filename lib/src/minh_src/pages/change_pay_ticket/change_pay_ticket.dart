import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmt_project/src/minh_src/models/modelGhe.dart';
import 'package:tmt_project/src/minh_src/models/takeComboModel.dart';
import 'package:tmt_project/src/minh_src/pages/check_bill_pages/checkBill_pages.dart';

class ChangePayTicket extends StatelessWidget {
  final String movieTitle;
  final String theaterName;
  final String receiveDate; // Ngày chiếu
  final String showTime; // Giờ chiếu
  final String poster; // ✅ thêm poster
  final List<GheModel> selectedSeats;
  final List<ComboModel> selectedCombos;

  const ChangePayTicket({
    super.key,
    required this.movieTitle,
    required this.theaterName,
    required this.receiveDate,
    required this.showTime,
    required this.poster, // ✅ bắt buộc
    required this.selectedSeats,
    required this.selectedCombos,
  });

  // 🔹 Hàm chuẩn hóa loại ghế để tránh lệch chữ hoa/thường
  String _normalizeSeatType(String type) {
    final t = type.toLowerCase();
    if (t.contains("vip")) return "VIP";
    if (t.contains("couple")) return "COUPLE";
    return "NORMAL";
  }

  String _getSeatTypeLabel(String type) {
    switch (_normalizeSeatType(type)) {
      case "VIP":
        return "Loại VIP";
      case "COUPLE":
        return "Loại Couple";
      default:
        return "Loại Thường";
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,###', 'vi_VN');

    final colorPrimary = Theme.of(context).colorScheme.primary;
    final colorPrimaryContainer =
        Theme.of(context).colorScheme.primaryContainer;
    final colorInverse = Theme.of(context).colorScheme.inversePrimary;

    // Tách ghế theo loại đã chuẩn hóa
    final vipSeats =
        selectedSeats
            .where((g) => _normalizeSeatType(g.tenLoaiGhe) == 'VIP')
            .toList();
    final coupleSeats =
        selectedSeats
            .where((g) => _normalizeSeatType(g.tenLoaiGhe) == 'COUPLE')
            .toList();
    final normalSeats =
        selectedSeats
            .where((g) => _normalizeSeatType(g.tenLoaiGhe) == 'NORMAL')
            .toList();

    int totalTicket = selectedSeats.fold(0, (sum, g) => sum + g.giaTien);
    double comboTotal = selectedCombos.fold(
      0,
      (sum, combo) => sum + (combo.gia * combo.quantity),
    );

    return Scaffold(
      backgroundColor: colorPrimaryContainer,
      appBar: AppBar(
        title: const Text("Xác nhận & Thanh toán"),
        backgroundColor: colorInverse,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorPrimaryContainer,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "🎬 $movieTitle",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _infoRow(context, Icons.location_city, theaterName, colorPrimary),
              _infoRow(context, Icons.date_range, receiveDate, colorPrimary),
              _infoRow(context, Icons.access_time, showTime, colorPrimary),

              const SizedBox(height: 16),
              if (vipSeats.isNotEmpty)
                _seatGroup(
                  _getSeatTypeLabel("VIP"),
                  vipSeats,
                  currencyFormat,
                  colorPrimary,
                ),
              if (normalSeats.isNotEmpty)
                _seatGroup(
                  _getSeatTypeLabel("NORMAL"),
                  normalSeats,
                  currencyFormat,
                  colorPrimary,
                ),
              if (coupleSeats.isNotEmpty)
                _seatGroup(
                  _getSeatTypeLabel("COUPLE"),
                  coupleSeats,
                  currencyFormat,
                  colorPrimary,
                ),

              const Divider(height: 28, color: Colors.white24),
              Text(
                "Tạm tính (${selectedSeats.length} ghế): ${currencyFormat.format(totalTicket)}đ",
                style: TextStyle(
                  fontSize: 16,
                  color: colorPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),
              if (selectedCombos.isNotEmpty) ...[
                Text(
                  "🍿 Combo đã chọn:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ...selectedCombos.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${c.tenCombo} (${c.moTa}) x${c.quantity}",
                            style: TextStyle(color: colorPrimary),
                          ),
                        ),
                        Text(
                          "${currencyFormat.format(c.gia * c.quantity)}đ",
                          style: TextStyle(
                            color: colorPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 28, color: Colors.white24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tổng combo", style: TextStyle(color: colorPrimary)),
                    Text(
                      "${currencyFormat.format(comboTotal)}đ",
                      style: TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tổng cộng:",
                    style: TextStyle(fontSize: 16, color: colorPrimary),
                  ),
                  Text(
                    "${currencyFormat.format(totalTicket + comboTotal)}đ",
                    style: TextStyle(
                      fontSize: 18,
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorInverse,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => CheckbillPages(
                              movieTitle: movieTitle,
                              theaterName: theaterName,
                              receiveDate: receiveDate,
                              showTime: showTime,
                              poster: poster, // ✅ truyền thêm
                              selectedSeats: selectedSeats,
                              selectedCombos: selectedCombos,
                            ),
                      ),
                    );
                  },
                  child: const Text(
                    "Thanh toán ngay",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String text,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: TextStyle(color: color))),
      ],
    );
  }

  Widget _seatGroup(
    String type,
    List<GheModel> seats,
    NumberFormat format,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              "$type\nGhế: ${seats.map((g) => g.viTriGhe).join(", ")}",
              style: TextStyle(color: color),
            ),
          ),
          Text(
            "${format.format(seats.fold(0, (sum, g) => sum + g.giaTien))}đ\n(${seats.length} ghế)",
            textAlign: TextAlign.right,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
