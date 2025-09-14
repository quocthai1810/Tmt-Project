// ✅ Bạn cần khai báo model ComboItem trước đã, hoặc import nếu đã có
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmt_project/src/minh_src/models/combo_item.dart';
import 'package:tmt_project/src/minh_src/pages/purchase_preview/purchase_preview_pages.dart';
import 'dart:async';

class CheckbillPages extends StatelessWidget {
  final String movieTitle;
  final String theaterName;
  final String receiveDate;
  final String showTime;
  final List<String> selectedSeats;
  final List<ComboItem> selectedCombos;

  const CheckbillPages({
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

    final vipSeats =
        selectedSeats.where((seat) => seat.startsWith("M")).toList();
    final coupleSeats =
        selectedSeats.where((seat) => seat.startsWith("O")).toList();
    final normalSeats =
        selectedSeats
            .where((seat) => !seat.startsWith("M") && !seat.startsWith("O"))
            .toList();

    const vipPrice = 120000;
    const couplePrice = 200000;
    const normalPrice = 80000;

    final totalVip = vipSeats.length * vipPrice;
    final totalCouple = coupleSeats.length * couplePrice;
    final totalNormal = normalSeats.length * normalPrice;
    final seatTotal = totalVip + totalCouple + totalNormal;

    final comboTotal = selectedCombos.fold<int>(
      0,
      (s, c) => s + (c.price * c.quantity),
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
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "🎨 $movieTitle",
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
              const Divider(height: 28, color: Colors.white24),
              if (vipSeats.isNotEmpty)
                _buildSeatRow("Loại VIP", vipPrice, vipSeats, currencyFormat),
              if (normalSeats.isNotEmpty)
                _buildSeatRow(
                  "Loại Thường",
                  normalPrice,
                  normalSeats,
                  currencyFormat,
                ),
              if (coupleSeats.isNotEmpty)
                _buildSeatRow(
                  "Loại Couple",
                  couplePrice,
                  coupleSeats,
                  currencyFormat,
                ),
              const SizedBox(height: 10),
              Text(
                "Tổng tạm tính (${selectedSeats.length} ghế): ${currencyFormat.format(seatTotal)}đ",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (selectedCombos.isNotEmpty) ...[
                const Text(
                  " 🍿 Combo đã chọn:",
                  style: TextStyle(fontSize: 16, color: Colors.lightBlueAccent),
                ),
                const SizedBox(height: 8),
                ...selectedCombos.map(
                  (c) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${c.name} (${c.popcorn} + ${c.drink}) x${c.quantity}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          "${currencyFormat.format(c.price * c.quantity)}đ",
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 28, color: Colors.white24),
                _totalRow("Tổng combo", comboTotal, Colors.amber),
              ],
              const SizedBox(height: 16),
              _totalRow(
                "Tổng cộng:",
                seatTotal + comboTotal,
                Colors.greenAccent,
                fontSize: 18,
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),
              const Text(
                "Phương thức thanh toán",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Wrap(
                  spacing: 20,
                  children: [
                    _buildPaymentOption(context, Icons.qr_code, "Mã QR", true),
                    _buildPaymentOption(
                      context,
                      Icons.account_balance_wallet,
                      "Momo",
                      true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) => Row(
    children: [
      Icon(icon, color: Colors.white70, size: 18),
      const SizedBox(width: 6),
      Text(text, style: const TextStyle(color: Colors.white70)),
    ],
  );

  Widget _buildSeatRow(
    String label,
    int price,
    List<String> seats,
    NumberFormat f,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label  ${f.format(price)}đ",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "Ghế: ${seats.join(", ")} (${seats.length} ghế)",
          style: const TextStyle(color: Colors.redAccent),
        ),
      ],
    ),
  );

  Widget _totalRow(
    String label,
    int amount,
    Color color, {
    double fontSize = 16,
  }) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(color: Colors.white, fontSize: fontSize)),
      Text(
        "${NumberFormat('#,###', 'vi_VN').format(amount)}đ",
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );

  Widget _buildPaymentOption(
    BuildContext context,
    IconData icon,
    String label,
    bool isQRCode,
  ) {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Quét mã để thanh toán",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Image.network(
                      "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=thanh_toan_success_${DateTime.now().millisecondsSinceEpoch}",
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Huỷ",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Future.delayed(
                              const Duration(milliseconds: 300),
                              () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => AlertDialog(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        title: const Text(
                                          "Đã thanh khoản thành công",
                                          style: TextStyle(
                                            color: Colors.greenAccent,
                                          ),
                                        ),
                                      ),
                                );
                                Future.delayed(
                                  const Duration(milliseconds: 1500),
                                  () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => const PurchasePreviewPages(),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text("Xác nhận"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        );
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white12,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
