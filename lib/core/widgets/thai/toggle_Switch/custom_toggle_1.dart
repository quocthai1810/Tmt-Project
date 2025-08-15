import 'package:flutter/material.dart';

typedef OnToggleChanged = void Function(bool value);

class CustomToggleSwitch extends StatefulWidget {
  /// Trạng thái ban đầu của công tắc
  final bool initialValue;

  /// Callback khi trạng thái thay đổi
  final OnToggleChanged? onChanged;

  /// Màu nền khi bật (ON)
  final Color? activeColor;

  /// Màu nền khi tắt (OFF)
  final Color? inactiveColor;

  /// Màu nút tròn
  final Color knobColor;

  /// Kích thước chiều rộng
  final double width;

  /// Kích thước chiều cao
  final double height;

  /// Thời gian animation
  final Duration animationDuration;

  const CustomToggleSwitch({
    Key? key,
    this.initialValue = false,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.knobColor = Colors.white,
    this.width = 50,
    this.height = 30,
    this.animationDuration = const Duration(milliseconds: 250),
  }) : super(key: key);

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch>
    with SingleTickerProviderStateMixin {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.initialValue;
  }

  void _toggleSwitch() {
    setState(() {
      _isOn = !_isOn;
    });
    widget.onChanged?.call(_isOn);
  }

  @override
  Widget build(BuildContext context) {
    final activeColor =
        widget.activeColor ?? Theme.of(context).colorScheme.inversePrimary;
    final inactiveColor =
        widget.inactiveColor ?? Theme.of(context).colorScheme.primaryContainer;
    final knobSize = widget.height - 6;

    return GestureDetector(
      onTap: _toggleSwitch,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.height / 2),
          color: _isOn ? activeColor : inactiveColor,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: widget.animationDuration,
              curve: Curves.easeInOut,
              left: _isOn ? widget.width - knobSize - 6 : 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: knobSize,
                height: knobSize,
                decoration: BoxDecoration(
                  color: widget.knobColor,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
