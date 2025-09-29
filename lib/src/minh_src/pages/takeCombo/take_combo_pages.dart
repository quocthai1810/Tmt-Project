import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tmt_project/src/minh_src/models/modelGhe.dart';
import 'package:tmt_project/src/minh_src/pages/change_pay_ticket/change_pay_ticket.dart';
import 'package:tmt_project/src/minh_src/pages/takeCombo/takeComboProvider.dart';
import 'package:tmt_project/src/minh_src/models/takeComboModel.dart';

class TakeComboPages extends StatefulWidget {
  final String theaterName;
  final String receiveDate;
  final String movieTitle;
  final String showTime;
  final String poster; // ✅ thêm poster
  final List<GheModel> selectedSeats;
  final int maHeThong;

  const TakeComboPages({
    super.key,
    required this.theaterName,
    required this.receiveDate,
    required this.movieTitle,
    required this.showTime,
    required this.poster, // ✅ required
    required this.selectedSeats,
    required this.maHeThong,
  });

  @override
  State<TakeComboPages> createState() => _TakeComboPagesState();
}

class _TakeComboPagesState extends State<TakeComboPages> {
  final currencyFormat = NumberFormat('#,###', 'vi_VN');
  List<ComboModel> selectedCombos = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<ComboProvider>().fetchCombos(maHeThong: widget.maHeThong);
    });
  }

  // ================== POPUP REVIEW ==================
  void _showReviewPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => StatefulBuilder(
            builder: (context, setModalState) {
              if (selectedCombos.isEmpty) {
                return _buildEmptyPopup();
              }
              return _buildConfirmPopup(setModalState);
            },
          ),
    );
  }

  Widget _buildEmptyPopup() => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Hiện không có sản phẩm nào trong giỏ',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => ChangePayTicket(
                      movieTitle: widget.movieTitle,
                      theaterName: widget.theaterName,
                      receiveDate: widget.receiveDate,
                      showTime: widget.showTime,
                      poster: widget.poster, // ✅ truyền poster
                      selectedSeats: widget.selectedSeats,
                      selectedCombos: const [],
                    ),
              ),
            );
          },
          child: const Text('Tiếp tục'),
        ),
      ],
    ),
  );

  Widget _buildConfirmPopup(void Function(void Function()) setModalState) =>
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Xác nhận thông tin',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...selectedCombos.map(
              (item) => _buildComboTile(item, setModalState),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ChangePayTicket(
                          movieTitle: widget.movieTitle,
                          theaterName: widget.theaterName,
                          receiveDate: widget.receiveDate,
                          showTime: widget.showTime,
                          poster: widget.poster, // ✅ truyền poster
                          selectedSeats: widget.selectedSeats,
                          selectedCombos: selectedCombos,
                        ),
                  ),
                );
              },
              child: const Text('Tiếp tục'),
            ),
          ],
        ),
      );

  Widget _buildComboTile(
    ComboModel item,
    void Function(void Function()) setModalState,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.tenCombo,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'x${item.quantity} - ${currencyFormat.format(item.gia * item.quantity)}đ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove_circle,
                  color: Theme.of(context).colorScheme.primary,
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
                icon: Icon(
                  Icons.add_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => setModalState(() => item.quantity++),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(item, setModalState),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
    ComboModel item,
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

  // ================== MAIN UI ==================
  @override
  Widget build(BuildContext context) {
    final comboProvider = context.watch<ComboProvider>();
    final totalPrice = selectedCombos.fold(
      0,
      (sum, item) => sum + item.gia * item.quantity,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Mua bắp nước",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          // search box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm loại bắp nước gì',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Theme.of(context).colorScheme.primaryContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // dropdown nhận tại + ngày
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
          // list combos
          Expanded(
            child: Builder(
              builder: (_) {
                if (comboProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (comboProvider.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(
                      comboProvider.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (comboProvider.combos.isEmpty) {
                  return const Center(
                    child: Text("Không có combo nào khả dụng"),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: comboProvider.combos.length,
                  itemBuilder:
                      (_, i) => _buildComboCard(comboProvider.combos[i]),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tạm tính',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
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
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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

  // ================== WIDGET BUILDERS ==================
  Widget _buildDropdown({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(value, overflow: TextOverflow.ellipsis)),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComboCard(ComboModel combo) {
    return GestureDetector(
      onTap: () async {
        final result = await showDialog<ComboModel>(
          context: context,
          builder: (_) => _buildComboDialog(combo),
        );
        if (result != null) {
          setState(() {
            final index = selectedCombos.indexWhere(
              (c) => c.maDoAn == result.maDoAn,
            );
            if (index >= 0) {
              selectedCombos[index].quantity += result.quantity;
            } else {
              selectedCombos.add(result);
            }
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              combo.hinhAnh,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              combo.tenCombo,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              combo.moTa,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              '${currencyFormat.format(combo.gia)}đ',
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

  Widget _buildComboDialog(ComboModel combo) {
    int quantity = 1;

    return AlertDialog(
      title: Text('Chọn ${combo.tenCombo}'),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed:
                    () => setDialogState(
                      () => quantity = (quantity > 1) ? quantity - 1 : 1,
                    ),
              ),
              Text(quantity.toString()),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setDialogState(() => quantity++),
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Huỷ"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, combo.copyWith(quantity: quantity));
          },
          child: const Text("Xác nhận"),
        ),
      ],
    );
  }
}
