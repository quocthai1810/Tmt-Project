import 'package:flutter/material.dart';

typedef OnToggleChanged = void Function(bool value);

class CustomToggleSwitch3 extends StatefulWidget {
  final bool initialValue;
  final OnToggleChanged? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color knobColor;
  final double width;
  final double height;
  final Duration animationDuration;

  const CustomToggleSwitch3({
    Key? key,
    this.initialValue = false,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.knobColor = Colors.white,
    this.width = 40,
    this.height = 20,
    this.animationDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  State<CustomToggleSwitch3> createState() => _CustomToggleSwitch3State();
}

class _CustomToggleSwitch3State extends State<CustomToggleSwitch3>
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

    return GestureDetector(
      onTap: _toggleSwitch,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.height / 2),
          color: _isOn ? activeColor : inactiveColor,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: widget.animationDuration,
              curve: Curves.easeInOut,
              left: _isOn ? widget.width - widget.height : 0,
              top: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: widget.animationDuration,
                width: widget.height,
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.knobColor,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 1),
                      blurRadius: 1.5,
                    ),
                  ],
                ),
                transform: Matrix4.identity()..scale(_isOn ? 1.0 : 1.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
