import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const CustomCheckbox({
    super.key,
    this.initialValue = false,
    required this.onChanged,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  void _toggleCheckbox() {
    setState(() => _isChecked = !_isChecked);
    widget.onChanged(_isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCheckbox,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: _isChecked ? Colors.pinkAccent : Colors.transparent,
          border: Border.all(color: Colors.pinkAccent, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child:
            _isChecked
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
      ),
    );
  }
}
