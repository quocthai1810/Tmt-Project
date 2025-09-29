import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tmt_project/core/widgets/minh/customToast.dart';
import 'package:tmt_project/core/widgets/tin/custom_button.dart';
import 'package:tmt_project/core/widgets/tin/custom_loading.dart';
import 'package:tmt_project/src/minh_src/pages/takeCombo/take_combo_pages.dart';
import 'package:tmt_project/src/minh_src/models/modelGhe.dart';
import 'package:tmt_project/src/minh_src/pages/takeSeat/takeSeatProvider.dart';

class TakeSeatPages extends StatefulWidget {
  final int maPhong;
  final int maSuatChieu;
  final String movieTitle;
  final String theaterName;
  final String receiveDate;
  final String showTime;
  final int maHeThong;

  const TakeSeatPages({
    super.key,
    required this.maPhong,
    required this.maSuatChieu,
    required this.movieTitle,
    required this.theaterName,
    required this.receiveDate,
    required this.showTime,
    required this.maHeThong,
  });

  @override
  State<TakeSeatPages> createState() => _TakeSeatPagesState();
}

class _TakeSeatPagesState extends State<TakeSeatPages> {
  late TransformationController _transformationController;
  double _zoomValue = 1.0;
  bool showMiniMap = false;
  List<GheModel> selectedSeats = [];

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _transformationController.addListener(_onZoomChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GheProvider>().fetchGheTheoPhong(
        maPhong: widget.maPhong,
        maSuatChieu: widget.maSuatChieu,
      );
    });
  }

  void _onZoomChange() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    setState(() {
      _zoomValue = scale;
      showMiniMap = scale > 1.0;
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: const BackButton(color: Colors.white),
      ),
      body: Consumer<GheProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CustomLoading(width: 88, height: 88));
          } else if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          } else {
            final danhSachGhe = provider.danhSachGhe;

            final int numCols = 6;
            final int numRows = (danhSachGhe.map((e) => e.row).toSet().length);
            final double seatSize = 80;
            final Size seatMapSize = Size(
              seatSize * numCols,
              seatSize * numRows,
            );

            return Column(
              children: [
                const SizedBox(height: 16),
                const Text('Khu vực màn hình', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Slider(
                  value: _zoomValue,
                  min: 0.6,
                  max: 2.8,
                  divisions: 30,
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
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 6,
                                  ),
                              itemCount: danhSachGhe.length,
                              itemBuilder: (_, i) {
                                final ghe = danhSachGhe[i];
                                final isSelected = selectedSeats.contains(ghe);

                                Color borderColor = Colors.green;
                                if (ghe.tenLoaiGhe == "Ghế VIP")
                                  borderColor = Colors.red;
                                if (ghe.tenLoaiGhe == "Ghế đôi")
                                  borderColor = Colors.purple;

                                Color fillColor =
                                    isSelected
                                        ? (ghe.tenLoaiGhe == "Ghế VIP"
                                            ? Colors.red
                                            : ghe.tenLoaiGhe == "Ghế đôi"
                                            ? Colors.purple
                                            : Colors.pinkAccent)
                                        : Colors.transparent;

                                return GestureDetector(
                                  onTap:
                                      ghe.daDat
                                          ? null
                                          : () {
                                            setState(() {
                                              if (isSelected) {
                                                selectedSeats.remove(ghe);
                                              } else {
                                                selectedSeats.add(ghe);
                                              }
                                            });
                                          },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: borderColor,
                                        width: 3,
                                      ),
                                      color: fillColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      ghe.viTriGhe,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
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
                          child: _buildMiniMap(
                            seatMapSize,
                            danhSachGhe,
                            numCols,
                            seatSize,
                          ),
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
                    _legend(color: Colors.grey.shade400, label: "Chưa chọn"),
                    _legend(color: Colors.pinkAccent, label: "Đã chọn"),
                    _legend(color: Colors.green, label: "Thường"),
                    _legend(color: Colors.red, label: "VIP"),
                    _legend(color: Colors.purple, label: "Couple"),
                  ],
                ),
                const SizedBox(height: 10),
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

                    int tongTien = selectedSeats.fold(
                      0,
                      (sum, ghe) => sum + ghe.giaTien,
                    );

                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text("Xác nhận ghế đã chọn"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "🎟️ Số ghế đã chọn: ${selectedSeats.length}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 160,
                                  width: double.maxFinite,
                                  child: ListView.separated(
                                    itemCount: selectedSeats.length,
                                    separatorBuilder:
                                        (_, __) => const Divider(height: 8),
                                    itemBuilder: (_, i) {
                                      final ghe = selectedSeats[i];
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Ghế: ${ghe.viTriGhe}"),
                                          Text(
                                            ghe.tenLoaiGhe,
                                            style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            NumberFormat.currency(
                                              locale: 'vi_VN',
                                              symbol: 'đ',
                                            ).format(ghe.giaTien),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "💰 Tạm tính:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'vi_VN',
                                        symbol: 'đ',
                                      ).format(tongTien),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Huỷ"),
                              ),
                              CustomButton(
                                text: "Xác nhận",
                                onPressed: () {
                                  CustomToast.show(
                                    context,
                                    message: "nè bé",
                                    type: ToastType.confirm,
                                  );
                                  print("Anh vừa bấm đó nghen 😘");

                                  Navigator.pop(context); // đóng dialog
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => TakeComboPages(
                                            maHeThong: widget.maHeThong,
                                            theaterName: widget.theaterName,
                                            receiveDate: widget.receiveDate,
                                            movieTitle: widget.movieTitle,
                                            showTime: widget.showTime,
                                            selectedSeats:
                                                selectedSeats
                                                    .map((e) => e.viTriGhe)
                                                    .toList(),
                                          ),
                                    ),
                                  );
                                },
                                width: 100,
                                height: 40,
                                backgroundColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.inversePrimary,
                                textColor: Colors.white,
                                borderRadius: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                    );
                  },

                  width: 280,
                  height: 60,
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  textColor: Colors.white,
                  borderRadius: 20,
                ),
                const SizedBox(height: 20),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _legend({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
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

  Widget _buildMiniMap(
    Size seatMapSize,
    List<GheModel> danhSachGhe,
    int numCols,
    double seatSize,
  ) {
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
              painter: _SeatMapPainter(danhSachGhe, ratio, seatSize, numCols),
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
  final List<GheModel> seats;
  final double ratio;
  final double seatSize;
  final int numCols;

  _SeatMapPainter(this.seats, this.ratio, this.seatSize, this.numCols);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (var seat in seats) {
      final double x = seat.col * seatSize * ratio;
      final double y = seat.row * seatSize * ratio;
      paint.color =
          seat.tenLoaiGhe == "Ghế VIP"
              ? Colors.red
              : (seat.tenLoaiGhe == "Ghế đôi" ? Colors.purple : Colors.green);
      canvas.drawRect(Rect.fromLTWH(x, y, 12, 12), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
