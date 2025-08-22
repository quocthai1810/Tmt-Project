import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double borderRadius;
  final double height;
  final double width;

  final bool enabled;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.borderRadius = 12,
    this.height = 48,
    this.width = double.infinity,
    this.enabled = true, // Mặc định bật
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              enabled
                  ? Theme.of(context)
                      .colorScheme
                      .primary // Màu chính khi enabled
                  : Theme.of(
                    context,
                  ).colorScheme.primaryFixedDim, // Màu xám nhạt khi disable
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        ),
        onPressed: enabled ? onPressed : null, // Vô hiệu hoá khi disabled
        child: Text(
          text,
          style: TextStyle(
            color:
                enabled
                    ? Colors.white
                    : colorScheme.onSurface.withOpacity(0.38),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
