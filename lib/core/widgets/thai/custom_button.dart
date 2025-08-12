import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  /// đây là độ rộng button
  /// dùng chỉnh chiều ngang
  final double width;

  final double height;

  final double textSize;

  final String text;

  final VoidCallback onPress;

  final double elevation;

  final BorderRadiusGeometry borderRadius;

  
  const CustomButton({
    super.key,
    this.width = 150,
    this.height = 50,
    this.textSize = 16,
    this.text = 'Button',
    required this.onPress,
    this.elevation = 5,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          shadowColor: Colors.black,
          textStyle: TextStyle(fontSize: textSize),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        onPressed: onPress,
        child: Text(text),
      ),
    );
  }
}
