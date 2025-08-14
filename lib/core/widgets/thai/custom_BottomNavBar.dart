import 'package:flutter/material.dart';

/// Custom Bottom Navigation Bar có hiệu ứng notch bo tròn cho icon được chọn.
/// Hỗ trợ danh sách icon và danh sách trang tương ứng.
class CustomBottomnavbar extends StatefulWidget {
  /// Chỉ số item đang chọn (current page)
  final int currentIndex;

  /// Callback khi chọn item, trả về index của item được chọn
  final ValueChanged<int> onTap;

  /// Danh sách icon cho bottom navbar
  final List<IconData> items;

  /// Danh sách page tương ứng với từng item
  final List<Widget> pages;

  /// Constructor, kiểm tra items và pages có cùng số lượng
  const CustomBottomnavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    required this.pages,
  }) : assert(
         items.length == pages.length,
         'Số lượng items và pages phải bằng nhau',
       );

  @override
  State<CustomBottomnavbar> createState() => _CustomBottomnavbarState();
}

class _CustomBottomnavbarState extends State<CustomBottomnavbar>
    with TickerProviderStateMixin {
  // Controller cho hiệu ứng bounce icon
  late AnimationController _iconController;

  // Controller cho hiệu ứng di chuyển icon giữa các vị trí
  late AnimationController _moveController;

  // Animation tính vị trí ngang (x-axis) của icon được chọn
  late Animation<double> _xAnim;

  // Lưu lại index cũ để tính animation di chuyển
  int _oldIndex = 0;

  @override
  void initState() {
    super.initState();

    // Animation bounce icon
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() {
      setState(() {}); // cập nhật UI khi animation thay đổi
    });

    // Animation di chuyển icon
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() {
      setState(() {}); // cập nhật UI khi animation thay đổi
    });

    // Tính vị trí x ban đầu của icon được chọn
    final width =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
    final itemWidth = width / widget.items.length;
    final initCenter = widget.currentIndex * itemWidth + (itemWidth / 2);
    _xAnim = AlwaysStoppedAnimation(initCenter);

    _oldIndex = widget.currentIndex;
  }

  @override
  void dispose() {
    _iconController.dispose();
    _moveController.dispose();
    super.dispose();
  }

  /// Xử lý khi người dùng tap vào một item
  void _onItemTapped(int index) {
    if (index == widget.currentIndex) {
      // Nếu tap lại icon hiện tại → chỉ bounce lại
      _iconController.forward(from: 0);
      return;
    }

    // Gọi callback trả về index mới
    widget.onTap(index);

    final width = MediaQuery.of(context).size.width;
    final itemWidth = width / widget.items.length;

    final oldCenter = _oldIndex * itemWidth + (itemWidth / 2);
    final newCenter = index * itemWidth + (itemWidth / 2);

    // Tạo animation di chuyển icon từ old → new
    _xAnim = Tween<double>(
      begin: oldCenter,
      end: newCenter,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_moveController);

    _oldIndex = index;

    // Bắt đầu animation bounce và di chuyển
    _iconController.forward(from: 0);
    _moveController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 100,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Nền navbar với notch bo tròn cho icon được chọn
          AnimatedBuilder(
            animation: _iconController,
            builder: (_, __) {
              return CustomPaint(
                size: Size(width, 80),
                painter: NavBarPainter(
                  widget.currentIndex,
                  widget.items.length,
                  Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),

          // Icon tròn nổi lên cho item đang chọn
          AnimatedBuilder(
            animation: _moveController,
            builder: (_, __) {
              return Positioned(
                bottom: 24,
                left: _xAnim.value - 27.5, // giữ icon ở giữa notch
                child: Container(
                  width: 55,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.items[widget.currentIndex],
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                ),
              );
            },
          ),

          // Các icon còn lại (không được chọn)
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(widget.items.length, (index) {
                final isSelected = index == widget.currentIndex;
                return GestureDetector(
                  onTap: () => _onItemTapped(index),
                  behavior: HitTestBehavior.translucent,
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.only(bottom: isSelected ? 40 : 10),
                    child: Icon(
                      widget.items[index],
                      color:
                          isSelected
                              ? Colors.transparent
                              : Theme.of(context).colorScheme.primaryContainer,
                      size: 28,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter để vẽ notch lõm cho bottom navbar
class NavBarPainter extends CustomPainter {
  final int selectedIndex;
  final int totalItems;
  final Color color;

  /// selectedIndex: index của item đang chọn
  /// totalItems: tổng số item
  /// color: màu nền navbar
  NavBarPainter(this.selectedIndex, this.totalItems, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

    final path = Path();
    final itemWidth = size.width / totalItems;
    final centerX = selectedIndex * itemWidth + (itemWidth / 2);

    const notchWidth = 120.0; // chiều rộng notch
    const notchDepth = 50.0; // độ sâu notch

    // Vẽ đường path nền navbar
    path.moveTo(0, 0);
    path.lineTo(centerX - notchWidth / 2, 0);

    // Cong xuống notch
    path.cubicTo(
      centerX - notchWidth / 3,
      0,
      centerX - notchWidth / 3,
      notchDepth,
      centerX,
      notchDepth,
    );

    // Cong lên notch
    path.cubicTo(
      centerX + notchWidth / 3,
      notchDepth,
      centerX + notchWidth / 3,
      0,
      centerX + notchWidth / 2,
      0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Vẽ shadow và path
    canvas.drawShadow(path, Colors.black26, 4, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
