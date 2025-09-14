import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmt_project/src/minh_src/models/combo_item.dart';
import 'package:tmt_project/src/minh_src/pages/check_bill_pages/checkBill_pages.dart';

class ChangePayTicket extends StatelessWidget {
  final String movieTitle;
  final String theaterName;
  final String receiveDate;
  final String showTime;
  final List<String> selectedSeats;
  final List<ComboItem> selectedCombos;

  const ChangePayTicket({
    super.key,
    required this.movieTitle,
    required this.theaterName,
    required this.receiveDate,
    required this.showTime,
    required this.selectedSeats,
    required this.selectedCombos,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,###', 'vi_VN');

    // Tách ghế theo loại
    List<String> vipSeats = [];
    List<String> coupleSeats = [];
    List<String> normalSeats = [];

    for (var seat in selectedSeats) {
      if (_isVip(seat)) {
        vipSeats.add(seat);
      } else if (_isCouple(seat)) {
        coupleSeats.add(seat);
      } else {
        normalSeats.add(seat);
      }
    }

    // Đơn giá
    const int vipPrice = 120000;
    const int normalPrice = 80000;
    const int couplePrice = 200000;

    // Tính tiền ghế
    int totalTicket =
        vipSeats.length * vipPrice +
        normalSeats.length * normalPrice +
        coupleSeats.length * couplePrice;

    // Tính tiền combo
    int comboTotal = selectedCombos.fold(
      0,
      (sum, combo) => sum + (combo.price * combo.quantity),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Xác nhận & Thanh toán"),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1B22),
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
                "🎮 $movieTitle",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              _infoRow(Icons.location_city, theaterName),
              _infoRow(Icons.date_range, receiveDate),
              _infoRow(Icons.access_time, showTime),
              const SizedBox(height: 16),

              if (vipSeats.isNotEmpty)
                _seatGroup("Loại VIP", vipSeats, vipPrice, currencyFormat),
              if (normalSeats.isNotEmpty)
                _seatGroup(
                  "Loại Thường",
                  normalSeats,
                  normalPrice,
                  currencyFormat,
                ),
              if (coupleSeats.isNotEmpty)
                _seatGroup(
                  "Loại Couple",
                  coupleSeats,
                  couplePrice,
                  currencyFormat,
                ),

              const Divider(height: 28, color: Colors.white24),

              Text(
                "Tổng tạm tính (${selectedSeats.length} ghế): ${currencyFormat.format(totalTicket)}đ",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),
              if (selectedCombos.isNotEmpty) ...[
                const Text(
                  "🍿 Combo đã chọn:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
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
                            "${c.name} (${c.popcorn} + ${c.drink}) x${c.quantity}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                        Text(
                          "${currencyFormat.format(c.price * c.quantity)}đ",
                          style: const TextStyle(
                            color: Colors.redAccent,
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
                    const Text(
                      "Tổng combo",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "${currencyFormat.format(comboTotal)}đ",
                      style: const TextStyle(
                        color: Colors.amber,
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
                  const Text(
                    "Tổng cộng:",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    "${currencyFormat.format(totalTicket + comboTotal)}đ",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.greenAccent,
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
                    backgroundColor: Colors.green,
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
                            (context) => CheckbillPages(
                              movieTitle: movieTitle,
                              theaterName: theaterName,
                              receiveDate: receiveDate,
                              showTime: showTime,
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

  bool _isVip(String seat) {
    final vipRegex = RegExp(r'^[F-M](1[0-8]|[5-9])\$');
    return vipRegex.hasMatch(seat.toUpperCase());
  }

  bool _isCouple(String seat) => seat.startsWith("O");

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text, style: const TextStyle(color: Colors.white70)),
        ),
      ],
    );
  }

  Widget _seatGroup(
    String type,
    List<String> seats,
    int price,
    NumberFormat format,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              "$type\nGhế: ${seats.join(", ")}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Text(
            "${format.format(price)}đ\n(${seats.length} ghế)",
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
