import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmt_project/src/minh_src/pages/change_pay_ticket/change_pay_ticket.dart';
import 'package:tmt_project/src/minh_src/pages/takeSeat/take_seat_pages.dart';
// ✅ import model dùng chung
import 'package:tmt_project/src/minh_src/models/combo_item.dart';

class TakeComboPages extends StatefulWidget {
  final String theaterName;
  final String receiveDate;
  final String movieTitle;
  final List<String> selectedSeats; // ✅ ghế chọn từ SeatMapPage

  const TakeComboPages({
    super.key,
    required this.theaterName,
    required this.receiveDate,
    required this.movieTitle,
    required this.selectedSeats,
  });

  @override
  State<TakeComboPages> createState() => _TakeComboPagesState();
}

class _TakeComboPagesState extends State<TakeComboPages> {
  final currencyFormat = NumberFormat('#,###', 'vi_VN');
  List<ComboItem> selectedCombos = [];

  final combos = [
    {
      'name': 'Combo Siêu Rạp',
      'desc': '1 bắp ngọt lớn + 2 nước + quà tặng',
      'price': 110000,
    },
    {'name': 'Combo Cặp Đôi', 'desc': '2 bắp + 2 nước', 'price': 150000},
    {
      'name': 'Combo Sinh Viên',
      'desc': '1 bắp vừa + 1 nước Sting',
      'price': 79000,
    },
    {
      'name': 'Combo Gia Đình',
      'desc': '2 bắp lớn + 4 nước + snack',
      'price': 199000,
    },
    {
      'name': 'Combo Trẻ Em',
      'desc': '1 bắp nhỏ + 1 sữa chua uống',
      'price': 59000,
    },
    {
      'name': 'Combo Party',
      'desc': '3 bắp + 3 nước + 1 khoai tây chiên',
      'price': 230000,
    },
  ];

  void _showReviewPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1B22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => StatefulBuilder(
            builder: (context, setModalState) {
              if (selectedCombos.isEmpty) {
                // === GIỎ RỖNG ===
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Hiện không có sản phẩm nào trong giỏ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // đóng popup
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ChangePayTicket(
                                    movieTitle: widget.movieTitle,
                                    theaterName: widget.theaterName,
                                    receiveDate: widget.receiveDate,
                                    showTime: "Chưa chọn suất chiếu",
                                    selectedSeats: widget.selectedSeats,
                                    selectedCombos:
                                        const [], // ✅ không có combo
                                  ),
                            ),
                          );
                        },
                        child: const Text('Tiếp tục'),
                      ),
                    ],
                  ),
                );
              }

              // === GIỎ CÓ HÀNG ===
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Xác nhận thông tin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...selectedCombos.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2931),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${item.popcorn} + ${item.drink}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'x${item.quantity} - ${currencyFormat.format(item.price * item.quantity)}đ',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (item.quantity > 1) {
                                      setModalState(() => item.quantity--);
                                    } else {
                                      _confirmDelete(item, setModalState);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: Colors.white,
                                  ),
                                  onPressed:
                                      () =>
                                          setModalState(() => item.quantity++),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () => _confirmDelete(item, setModalState),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // đóng popup
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ChangePayTicket(
                                  movieTitle: widget.movieTitle,
                                  theaterName: widget.theaterName,
                                  receiveDate: widget.receiveDate,
                                  showTime: "Chưa chọn suất chiếu",
                                  selectedSeats: widget.selectedSeats, // ✅ ghế
                                  selectedCombos: selectedCombos, // ✅ combo
                                ),
                          ),
                        );
                      },
                      child: const Text('Tiếp tục'),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  void _confirmDelete(
    ComboItem item,
    void Function(void Function()) setModalState,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Xác nhận'),
            content: const Text('Bạn có chắc chắn muốn xoá combo này không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Xoá'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      setState(() => selectedCombos.remove(item));
      setModalState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = selectedCombos.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B22),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1B22),
        title: const Text(
          'Mua bắp nước',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm loại bắp nước gì',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2A2931),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDropdown(title: 'Nhận tại', value: widget.theaterName),
                const SizedBox(height: 10),
                _buildDropdown(
                  title: 'Ngày nhận bắp nước',
                  value: widget.receiveDate,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: combos.length,
              itemBuilder: (_, i) => _buildComboCard(combos[i]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF2A2931),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tạm tính', style: TextStyle(color: Colors.grey)),
                Text(
                  '${currencyFormat.format(totalPrice)}đ',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showReviewPopup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Tiếp tục', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2931),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComboCard(Map<String, dynamic> combo) {
    return GestureDetector(
      onTap: () async {
        final result = await showDialog<ComboItem>(
          context: context,
          builder: (_) => _buildComboDialog(combo['name'], combo['price']),
        );
        if (result != null) {
          setState(() {
            selectedCombos.add(result);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2931),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text(
              combo['name'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              combo['desc'],
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            const Text(
              'Áp dụng giá Lễ, Tết...',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
            const Spacer(),
            Text(
              '${currencyFormat.format(combo['price'])}đ',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComboDialog(String comboName, int price) {
    String selectedDrink = 'Pepsi';
    String selectedPopcorn = 'Bắp ngọt';
    int quantity = 1;

    return AlertDialog(
      backgroundColor: const Color(0xFF1C1B22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Chọn $comboName',
        style: const TextStyle(color: Colors.white),
      ),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                dropdownColor: Colors.black,
                value: selectedDrink,
                isExpanded: true,
                onChanged:
                    (value) => setDialogState(() => selectedDrink = value!),
                items:
                    ['Pepsi', '7Up', 'Sting']
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 12),
              DropdownButton<String>(
                dropdownColor: Colors.black,
                value: selectedPopcorn,
                isExpanded: true,
                onChanged:
                    (value) => setDialogState(() => selectedPopcorn = value!),
                items:
                    ['Bắp ngọt', 'Bắp phô mai']
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Số lượng', style: TextStyle(color: Colors.white)),
                  Row(
                    children: [
                      IconButton(
                        onPressed:
                            () => setDialogState(
                              () =>
                                  quantity = (quantity > 1) ? quantity - 1 : 1,
                            ),
                        icon: const Icon(Icons.remove, color: Colors.white),
                      ),
                      Text(
                        quantity.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () => setDialogState(() => quantity++),
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              ComboItem(
                name: comboName,
                drink: selectedDrink,
                popcorn: selectedPopcorn,
                quantity: quantity,
                price: price,
              ),
            );
          },
          child: const Text('Xác nhận'),
        ),
      ],
    );
  }
}
