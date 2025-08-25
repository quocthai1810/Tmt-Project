import 'package:flutter/material.dart';

typedef OnRadioChanged = void Function(int value);

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.images,
    this.crossAxisCount = 2,
    this.spacing = 16,
    this.onItemTap,
  });

  /// Danh sách lựa chọn: key là giá trị int gửi backend, value là label hiển thị(String)
  final Map<int, String> options;

  /// Giá trị đang chọn (int)
  final int selectedValue;

  /// Callback khi chọn option mới
  final OnRadioChanged onChanged;

  /// Background images cho mỗi option (key trùng với options)
  final Map<int, String>? images;

  /// Grid columns
  final int crossAxisCount;

  /// Khoảng cách giữa các item
  final double spacing;
  /// chuyển trang khi nhấn vào bất kì thể loại nào!!
    final void Function(int value)? onItemTap;

  @override
  Widget build(BuildContext context) {
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 2.0,
      ),
      itemBuilder: (context, index) {
        final key = options.keys.elementAt(index);
        final label = options[key]!;
        final isSelected = key == selectedValue;
        final image = images != null ? images![key] : null;
        return GestureDetector(
          onTap: () {
            onChanged(key);
            if (onItemTap != null) onItemTap!(key);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image:
                  image != null
                      ? DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.60),
                          BlendMode.darken,
                        ),
                      )
                      : null,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 20,
                  top: 22,
                  child: Radio<int>(
                    value: key,
                    groupValue: selectedValue,
                    activeColor: Theme.of(context).colorScheme.primaryContainer,
                    onChanged: (val) => onChanged(val!),
                  ),
                ),
                Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.inversePrimary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: isSelected ? 18 : 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
