import 'package:flutter/material.dart';

typedef OnRadioChanged = void Function(int value);

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.selectedColor,
    this.unselectedColor,
    this.direction = Axis.horizontal,
    this.spacing = 16,
  });

  /// Danh sách lựa chọn: key là giá trị int gửi backend, value là label hiển thị(String)
  final Map<int, String> options;

  /// Giá trị đang chọn (int)
  final int selectedValue;

  /// Callback khi chọn option mới (dùng setstate để thay đổi trạng thái hoặc state management)
  final OnRadioChanged onChanged;

  /// Màu khi radio được chọn
  final Color? selectedColor;

  /// Màu khi radio chưa được chọn
  final Color? unselectedColor;

  /// Hướng hiển thị
  final Axis direction;

  /// Khoảng cách giữa các radio button
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final selectedClr = selectedColor ?? Theme.of(context).colorScheme.inversePrimary;
    final unselectedClr =
        unselectedColor ??
        Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

    final children =
        options.entries.map((entry) {
          final isSelected = entry.key == selectedValue;

          return InkWell(
            onTap: () => onChanged(entry.key),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<int>(
                    value: entry.key,
                    groupValue: selectedValue,
                    onChanged: (val) => onChanged(val!),
                    activeColor: selectedClr,
                  ),
                  Text(
                    entry.value,
                    style: TextStyle(
                      color: isSelected ? selectedClr : unselectedClr,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();

    return direction == Axis.horizontal
        ? Wrap(spacing: spacing, children: children)
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              children
                  .map(
                    (child) => Padding(
                      padding: EdgeInsets.only(bottom: spacing),
                      child: child,
                    ),
                  )
                  .toList(),
        );
  }
}
