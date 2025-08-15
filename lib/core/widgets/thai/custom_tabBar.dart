import 'package:flutter/material.dart';

typedef OnTabChanged = void Function(int index);

class CustomTabBar extends StatefulWidget {
  /// Danh sách tab (Text, Icon hoặc bất kỳ Widget nào)
  final List<Widget> tabs;

  /// Danh sách nội dung tương ứng từng tab
  final List<Widget> tabViews;

  /// Callback trả về index tab được chọn
  final OnTabChanged? onTabChanged;

  /// Màu sắc cho tab được chọn
  final Color? selectedColor;

  /// Màu sắc cho tab chưa chọn
  final Color? unselectedColor;

  /// nếu muốn nhỏ lại thì định nghĩa kích thước(xét height, width), mặc định chiếm toàn bộ kích thước của cha
  const CustomTabBar({
    Key? key,
    required this.tabs,
    required this.tabViews,
    this.onTabChanged,
    this.selectedColor,
    this.unselectedColor,
  }) : assert(
         tabs.length == tabViews.length,
         "Tabs và TabViews phải bằng nhau thêm tab phải nhớ thêm tabViews",
       ),
       super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: widget.tabs.length, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onTabChanged?.call(_tabController.index);
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabs.length != oldWidget.tabs.length) {
      _tabController.dispose();
      _tabController = TabController(length: widget.tabs.length, vsync: this);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor =
        widget.selectedColor ?? Theme.of(context).colorScheme.primary;
    final unselectedColor =
        widget.unselectedColor ?? Theme.of(context).colorScheme.inversePrimary;

    return Column(
      children: [
        TabBar(
          labelPadding: EdgeInsets.all(10),
          controller: _tabController,
          tabs: widget.tabs,
          labelColor: selectedColor,
          unselectedLabelColor: unselectedColor,
          indicatorColor: selectedColor,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabViews,
          ),
        ),
      ],
    );
  }
}
