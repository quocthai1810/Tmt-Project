import 'package:flutter/material.dart';

/// Custom Checkbox
/// dùng để tạo checkbox với label
/// có thể tùy chỉnh giá trị ban đầu và callback khi thay đổi
///
///
class CustomCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final String label;

  const CustomCheckbox({
    super.key,
    this.initialValue = false,
    required this.onChanged,
    this.label = '',
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
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
                    ? Transform.translate(
                      offset: const Offset(0, -2), // Dịch icon lên trên
                      child: const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                    )
                    : null,
          ),
          if (widget.label.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(widget.label, style: const TextStyle(fontSize: 14)),
          ],
        ],
      ),
    );
  }
}
