import 'package:flutter/material.dart';

typedef OnToggleChanged = void Function(bool value);

class CustomToggleSwitch4 extends StatefulWidget {
  final bool initialValue;
  final OnToggleChanged? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color knobColor;
  final double width;
  final double height;
  final Duration animationDuration;

  const CustomToggleSwitch4({
    Key? key,
    this.initialValue = false,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.knobColor = Colors.white,
    this.width = 64,
    this.height = 32,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<CustomToggleSwitch4> createState() => _CustomToggleSwitch4State();
}

class _CustomToggleSwitch4State extends State<CustomToggleSwitch4> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.initialValue;
  }

  void _toggleSwitch() {
    setState(() => _isOn = !_isOn);
    widget.onChanged?.call(_isOn);
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = Theme.of(context).colorScheme.primaryContainer;

    return GestureDetector(
      onTap: _toggleSwitch,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.height / 2),
          color: _isOn ? activeColor : inactiveColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: widget.animationDuration,
              left: _isOn ? widget.width - widget.height : 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: widget.height,
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.knobColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 4,
                      offset: Offset(0, 2),
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
