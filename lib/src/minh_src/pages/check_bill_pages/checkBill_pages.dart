import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmt_project/src/minh_src/models/combo_item.dart';
import 'package:tmt_project/src/minh_src/pages/purchase_preview/purchase_preview_pages.dart';

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

    final vipSeats = selectedSeats.where((s) => s.startsWith("M")).toList();
    final coupleSeats = selectedSeats.where((s) => s.startsWith("O")).toList();
    final normalSeats =
        selectedSeats
            .where((s) => !s.startsWith("M") && !s.startsWith("O"))
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
      (sum, c) => sum + (c.price * c.quantity),
    );

    final totalAll = seatTotal + comboTotal;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        title: const Text("Xác nhận & Thanh toán"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "🎬 $movieTitle",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              _infoRow(context, Icons.location_city, theaterName),
              _infoRow(context, Icons.date_range, receiveDate),
              _infoRow(context, Icons.access_time, showTime),
              const Divider(height: 28, color: Colors.white24),

              if (vipSeats.isNotEmpty)
                _buildSeatRow(
                  context,
                  "Loại VIP",
                  vipPrice,
                  vipSeats,
                  currencyFormat,
                ),
              if (normalSeats.isNotEmpty)
                _buildSeatRow(
                  context,
                  "Loại Thường",
                  normalPrice,
                  normalSeats,
                  currencyFormat,
                ),
              if (coupleSeats.isNotEmpty)
                _buildSeatRow(
                  context,
                  "Loại Couple",
                  couplePrice,
                  coupleSeats,
                  currencyFormat,
                ),

              const SizedBox(height: 10),
              _totalRow(
                context,
                "Tổng tạm tính (${selectedSeats.length} ghế):",
                seatTotal,
              ),

              const SizedBox(height: 20),

              if (selectedCombos.isNotEmpty) ...[
                Text(
                  "🍿 Combo đã chọn:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...selectedCombos.map(
                  (c) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${c.name} (${c.popcorn} + ${c.drink}) x${c.quantity}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Text(
                        "${currencyFormat.format(c.price * c.quantity)}đ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 28, color: Colors.white24),
                _totalRow(context, "Tổng combo", comboTotal),
              ],

              const SizedBox(height: 16),
              _totalRow(context, "Tổng cộng:", totalAll, fontSize: 18),

              const SizedBox(height: 24),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),
              Text(
                "Phương thức thanh toán",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 16,
                children: [
                  _buildPaymentOption(
                    context,
                    Icons.qr_code,
                    "Mã QR",
                    isQRCode: true,
                  ),
                  _buildPaymentOption(
                    context,
                    Icons.wallet,
                    "Momo",
                    isQRCode: true,
                  ),
                  _buildPaymentOption(
                    context,
                    Icons.money,
                    "Tiền mặt",
                    isQRCode: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String text) => Row(
    children: [
      Icon(icon, color: Theme.of(context).colorScheme.primary, size: 18),
      const SizedBox(width: 6),
      Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    ],
  );

  Widget _buildSeatRow(
    BuildContext context,
    String type,
    int price,
    List<String> seats,
    NumberFormat format,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$type ${format.format(price)}đ",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "Ghế: ${seats.join(", ")} (${seats.length} ghế)",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(
    BuildContext context,
    String label,
    int amount, {
    double fontSize = 16,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          "${NumberFormat('#,###', 'vi_VN').format(amount)}đ",
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    IconData icon,
    String label, {
    required bool isQRCode,
  }) {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                content:
                    isQRCode
                        ? _buildQRCodeContent(context)
                        : _buildCashContent(context),
              ),
        );
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildQRCodeContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Quét mã để thanh toán",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 12),
        Image.network(
          "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=pay_${DateTime.now().millisecondsSinceEpoch}",
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder:
                  (_) => AlertDialog(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      "Đã thanh toán thành công",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
            );
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const PurchasePreviewPages()),
              );
            });
          },
          child: const Text("Xác nhận"),
        ),
      ],
    );
  }

  Widget _buildCashContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Hóa đơn đang tiến hành xử lí...",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const PurchasePreviewPages()),
              );
            });
          },
          child: const Text("Xong"),
        ),
      ],
    );
  }
}
