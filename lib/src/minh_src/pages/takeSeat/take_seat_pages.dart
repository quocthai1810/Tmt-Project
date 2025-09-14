import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:tmt_project/core/widgets/minh/customToast.dart';
import 'package:tmt_project/core/widgets/tin/custom_button.dart';
import 'package:tmt_project/src/minh_src/pages/takeCombo/take_combo_pages.dart';

class SeatModel {
  final int row;
  final int col;
  final String name;
  bool isSelected;
  final bool isVip;
  final bool isCouple;

  SeatModel({
    required this.row,
    required this.col,
    required this.name,
    this.isSelected = false,
    this.isVip = false,
    this.isCouple = false,
  });
}

class SeatMapPage extends StatefulWidget {
  final String movieTitle;
  final String theaterName;
  final String receiveDate;
  final String showTime;

  const SeatMapPage({
    super.key,
    required this.movieTitle,
    required this.theaterName,
    required this.receiveDate,
    required this.showTime,
  });

  @override
  State<SeatMapPage> createState() => _SeatMapPageState();
}

class _SeatMapPageState extends State<SeatMapPage> {
  final int numRows = 16;
  final int numCols = 14;
  final List<int> aisleCols = [3, 7, 10];
  final List<int> aisleRows = [4, 7, 13];
  final double seatSize = 50.0;
  late TransformationController _transformationController;
  double _zoomValue = 1.0;
  bool showMiniMap = false;
  List<SeatModel> seats = [];

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _transformationController.addListener(_onZoomChange);
    seats = _generateSeats();
  }

  void _onZoomChange() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    setState(() {
      _zoomValue = scale;
      showMiniMap = scale > 1.0;
    });
  }

  List<SeatModel> _generateSeats() {
    List<SeatModel> list = [];
    const seatLetters = 'ABCDEFGHIJKLMNOPQR';

    for (int row = 0; row < numRows; row++) {
      for (int col = 0; col < numCols; col++) {
        if (aisleCols.contains(col) || aisleRows.contains(row)) continue;
        if (seatLetters[row] == 'P') continue;

        String seatLetter = seatLetters[row];

        if (seatLetter == 'A' && col == 6) {
          list.add(SeatModel(row: row, col: col, name: 'A7'));
          continue;
        }
        if (seatLetter == 'A' && col == 5) {
          list.add(SeatModel(row: row, col: col, name: 'A6'));
          continue;
        }

        if (seatLetter == 'O' && (col == 0 || col == 4 || col == 11)) continue;

        int seatNumber = (col < numCols ~/ 2) ? col + 1 : col + 8;
        String name = '$seatLetter$seatNumber';

        bool isVip =
            seatLetter.compareTo('F') >= 0 &&
            seatLetter.compareTo('M') <= 0 &&
            seatNumber >= 5 &&
            seatNumber <= 18;

        bool isCouple = seatLetter == 'O';

        list.add(
          SeatModel(
            row: row,
            col: col,
            name: name,
            isVip: isVip,
            isCouple: isCouple,
          ),
        );
      }
    }
    return list;
  }

  List<SeatModel> get selectedSeats =>
      seats.where((e) => e.isSelected).toList();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size seatMapSize = Size(seatSize * numCols, seatSize * numRows);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.movieTitle, style: const TextStyle(fontSize: 16)),
            Text(
              "${widget.theaterName} • ${widget.receiveDate} • ${widget.showTime}",
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text('Khu vực màn hình', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Slider(
              value: _zoomValue,
              min: 0.6,
              max: 2.8,
              divisions: 22,
              label: 'Zoom sơ đồ: ${_zoomValue.toStringAsFixed(2)}x',
              onChanged: (val) {
                setState(() {
                  _zoomValue = val;
                  _transformationController.value =
                      Matrix4.identity()..scale(val);
                });
              },
            ),
            Text('Zoom sơ đồ: ${_zoomValue.toStringAsFixed(2)}x'),
            const SizedBox(height: 8),
            Expanded(
              child: Stack(
                children: [
                  InteractiveViewer(
                    transformationController: _transformationController,
                    boundaryMargin: const EdgeInsets.all(100),
                    minScale: 0.6,
                    maxScale: 2.8,
                    child: Center(
                      child: SizedBox(
                        width: seatMapSize.width,
                        height: seatMapSize.height,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: numCols,
                                mainAxisSpacing: 6,
                                crossAxisSpacing: 6,
                              ),
                          itemCount: numRows * numCols,
                          itemBuilder: (context, index) {
                            int row = index ~/ numCols;
                            int col = index % numCols;
                            if (aisleCols.contains(col) ||
                                aisleRows.contains(row)) {
                              return const SizedBox.shrink();
                            }
                            SeatModel seat = seats.firstWhere(
                              (e) => e.row == row && e.col == col,
                              orElse:
                                  () => SeatModel(row: row, col: col, name: ''),
                            );
                            if (seat.name.isEmpty)
                              return const SizedBox.shrink();
                            return GestureDetector(
                              onTap: () {
                                setState(
                                  () => seat.isSelected = !seat.isSelected,
                                );
                                if (seat.isVip && seat.isSelected) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Bạn đang chọn ghế VIP 🎟️',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                width: seatSize,
                                height: seatSize,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        seat.isVip
                                            ? Colors.red
                                            : (seat.isCouple
                                                ? Colors.purple
                                                : Colors.green),
                                    width: 2,
                                  ),
                                  color:
                                      seat.isSelected
                                          ? (seat.isVip
                                              ? Colors.red
                                              : (seat.isCouple
                                                  ? Colors.purple
                                                  : Colors.pinkAccent))
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: FittedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      seat.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (showMiniMap)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: _buildMiniMap(seatMapSize),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildLegend(color: Colors.grey.shade400, label: "Unselected"),
                _buildLegend(color: Colors.pinkAccent, label: "Selected"),
                _buildLegend(color: Colors.green, label: "Normal"),
                _buildLegend(color: Colors.red, label: "VIP"),
                _buildLegend(color: Colors.purple, label: "Couple"),
              ],
            ),
            const SizedBox(height: 10),

            // ✅ Custom Button - Tiếp tục
            CustomButton(
              text: "Tiếp tục",
              onPressed: () {
                if (selectedSeats.isEmpty) {
                  CustomToast.show(
                    context,
                    message: "Chưa chọn ghế nào hết trơn á 😢",
                    type: ToastType.warning,
                  );
                  return;
                }

                CustomToast.show(
                  context,
                  message: "Ghế đã được chọn rồi nè bé 😘",
                  type: ToastType.success,
                );

                print("Anh vừa bấm tiếp tục nè 😎");

                // Open sheet
                _showConfirmSheet(context);
              },
              width: 280,
              height: 60,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              borderRadius: 20,
              fontWeight: FontWeight.w500,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ✅ Đoạn code bên dưới là phần cập nhật bên trong `_showConfirmSheet` của `SeatMapPage`
  // ✅ Bao gồm thêm nút "Huỷ" để người dùng chọn lại ghế

  void _showConfirmSheet(BuildContext context) {
    const priceVip = 120000;
    const priceNormal = 80000;
    const priceCouple = 200000;

    Map<String, List<String>> groupedSeats = {
      "VIP": [],
      "Thường": [],
      "Couple": [],
    };

    int seatTotal = 0;
    for (var seat in selectedSeats) {
      if (seat.isVip) {
        groupedSeats["VIP"]!.add(seat.name);
        seatTotal += priceVip;
      } else if (seat.isCouple) {
        groupedSeats["Couple"]!.add(seat.name);
        seatTotal += priceCouple;
      } else {
        groupedSeats["Thường"]!.add(seat.name);
        seatTotal += priceNormal;
      }
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Xác nhận đặt vé",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...groupedSeats.entries.where((e) => e.value.isNotEmpty).map((
                entry,
              ) {
                int price =
                    entry.key == "VIP"
                        ? priceVip
                        : entry.key == "Thường"
                        ? priceNormal
                        : priceCouple;

                return ListTile(
                  title: Text("${entry.key} (${entry.value.length} ghế)"),
                  subtitle: Text("Ghế: ${entry.value.join(", ")}"),
                  trailing: Text(
                    "${NumberFormat('#,###', 'vi_VN').format(price)}đ",
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }),
              const Divider(),

              // ✅ Row chứa 2 nút: Huỷ + Xác nhận
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Huỷ",
                      onPressed: () {
                        CustomToast.show(
                          context,
                          message: "Bạn có thể chọn lại ghế nha 😗",
                          type: ToastType.warning,
                        );
                        print("Người dùng đã bấm huỷ chọn ghế ❌");
                        Navigator.pop(context);
                      },
                      backgroundColor: Colors.grey.shade300,
                      textColor: Colors.black87,
                      borderRadius: 20,
                      fontWeight: FontWeight.w500,
                      height: 50,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: "Xác nhận",
                      onPressed: () {
                        CustomToast.show(
                          context,
                          message: "Chuyển sang chọn combo bé 😘",
                          type: ToastType.success,
                        );
                        print("Bấm xác nhận để qua bước chọn combo nha 😏");

                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => TakeComboPages(
                                  theaterName: widget.theaterName,
                                  receiveDate: widget.receiveDate,
                                  movieTitle: widget.movieTitle,
                                  selectedSeats:
                                      selectedSeats.map((e) => e.name).toList(),
                                ),
                          ),
                        );
                      },
                      backgroundColor: Colors.green.shade700,
                      textColor: Colors.white,
                      borderRadius: 20,
                      fontWeight: FontWeight.w500,
                      height: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegend({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black26),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildMiniMap(Size seatMapSize) {
    final Matrix4 matrix = _transformationController.value;
    final double scale = matrix.getMaxScaleOnAxis();
    final Offset translation = Offset(matrix[12], matrix[13]);
    const double miniMapWidth = 100;
    final double ratio = miniMapWidth / seatMapSize.width;
    final double miniMapHeight = seatMapSize.height * ratio;
    final double viewportWidth =
        MediaQuery.of(context).size.width / scale * ratio;
    final double viewportHeight =
        MediaQuery.of(context).size.height / scale * ratio;
    final double dx = -translation.dx * ratio / scale;
    final double dy = -translation.dy * ratio / scale;

    return Container(
      width: miniMapWidth,
      height: miniMapHeight,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _SeatMapPainter(seats, seatMapSize, ratio),
            ),
          ),
          Positioned(
            left: dx,
            top: dy,
            child: Container(
              width: viewportWidth,
              height: viewportHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow, width: 1.2),
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeatMapPainter extends CustomPainter {
  final List<SeatModel> seats;
  final Size originalSize;
  final double ratio;

  _SeatMapPainter(this.seats, this.originalSize, this.ratio);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (var seat in seats) {
      final double x = seat.col * 50 * ratio;
      final double y = seat.row * 50 * ratio;
      paint.color =
          seat.isVip
              ? Colors.red
              : (seat.isCouple ? Colors.purple : Colors.green);
      canvas.drawRect(Rect.fromLTWH(x, y, 12, 12), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
