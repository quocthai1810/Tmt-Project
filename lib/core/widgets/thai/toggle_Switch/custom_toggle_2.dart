import 'package:flutter/material.dart';

typedef OnToggleChanged = void Function(bool value);

class CustomToggleSwitch2 extends StatefulWidget {
  final bool initialValue;
  final OnToggleChanged? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color knobColor;
  final double width;
  final double height;
  final Duration animationDuration;

  const CustomToggleSwitch2({
    Key? key,
    this.initialValue = false,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.knobColor = Colors.white,
    this.width = 55,
    this.height = 30,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<CustomToggleSwitch2> createState() => _CustomToggleSwitch2State();
}

class _CustomToggleSwitch2State extends State<CustomToggleSwitch2> {
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
        widget.activeColor ?? Theme.of(context).colorScheme.primary;
    ;
    final inactiveColor =
        widget.inactiveColor ?? Theme.of(context).colorScheme.primaryContainer;

    final knobSize = widget.height - 10;

    return GestureDetector(
      onTap: _toggleSwitch,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: _isOn ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(5),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: widget.animationDuration,
              curve: Curves.easeInOut,
              left: _isOn ? widget.width - knobSize - 10 : 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: knobSize,
                height: knobSize,
                decoration: BoxDecoration(
                  color: widget.knobColor,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
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
