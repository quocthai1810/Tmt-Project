import 'package:flutter/material.dart';

/// customButton này xài như sau
/// CustomButton(
///            text: "ghi tên cái nút",
///            onPressed: () {
///              CustomToast.show( //gọi cái khứa này để xuất hiện nếu cần toast
///                context,
///                message: "nè bé", // nó xuất hiện toast kèm message
///                type: ToastType.success, // lựa chọn loại toast ( success,failed)
///            );
///            print("Anh vừa bấm đó nghen 😘");// in ra terminal
///            },//sau đây là những cái muốn thì tùy chỉnh tùy theo nhu cầu
///            width: 280, // hoặc bỏ để tự responsive
///            height: 60,
///            backgroundColor: Colors.green.shade700,
///            textColor: Colors.white,
///            borderRadius: 20,
///            fontWeight: FontWeight.w500,
///          ),
class CustomButton extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final Color? backgroundColor; // <-- sửa nè
  final Color textColor;
  final double borderRadius;
  final FontWeight fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    this.width,
    this.height,
    this.onPressed,
    this.backgroundColor, // <-- bỏ default ở đây
    this.textColor = Colors.white,
    this.borderRadius = 12,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    // Kích thước màn hình
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Nếu không set thì mặc định theo tỷ lệ màn hình
    final buttonWidth = width ?? screenWidth * 0.6;
    final buttonHeight = height ?? screenHeight * 0.06;

    // Auto fontSize theo chiều cao
    final fontSize = buttonHeight * 0.4;

    // Nếu không truyền backgroundColor thì dùng inversePrimary từ theme
    final bgColor =
        backgroundColor ?? Theme.of(context).colorScheme.inversePrimary;

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.4),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 4), // vị trí bóng
          ),
        ],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor, // <-- dùng bgColor
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0, // vì đã có boxShadow ngoài rồi
        ),
        onPressed: onPressed,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
