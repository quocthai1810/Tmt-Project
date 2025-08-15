// Làm đi Minh nèeeeeeeeeeee
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tmt_project/core/widgets/minh/customCarousel.dart';
import 'package:tmt_project/core/widgets/minh/customCheckbox.dart'; // ScrollDirection
import 'package:tmt_project/core/widgets/minh/customTextField.dart';
import 'package:tmt_project/core/widgets/minh/customToast.dart';
//bảng màu sắc
// color.Theme.of(context).colorScheme.inversePrimary ; ===> nền của button hay các bar
// color.Theme.of(context).colorScheme.primary;         ===> chữ hay icon
// color.Theme.of(context).colorScheme.primaryContainer;===> nền card hay nền chứa nội dung

/// =================== DOMAIN MODEL ===================

class codeDiMinhoi extends StatefulWidget {
  const codeDiMinhoi({super.key});

  @override
  State<codeDiMinhoi> createState() => _codeDiMinhoiState();
}

class _codeDiMinhoiState extends State<codeDiMinhoi> {
  final TextEditingController _passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const UseCustomCarousel(), //nắm đầu tên class này ra mà xài
            const SizedBox(height: 24),
            CustomCheckbox(
              initialValue: false,
              onChanged: (value) {
                print("✅ Checked: $value");
              }, // Hàm này sẽ được gọi khi checkbox được bấm
            ), //nắm đầu tên class này ra mà xài
            const SizedBox(height: 12),

            _buildButton(
              label: "✅ Thành công",
              color: Colors.green,
              onPressed: () {
                CustomToast.show(
                  context,
                  message: "Lưu dữ liệu thành công!",
                  type: ToastType.success,
                );
              },
            ),
            const SizedBox(height: 10),
            _buildButton(
              label: "❌ Lỗi",

              color: Colors.red,
              onPressed: () {
                CustomToast.show(
                  context,
                  message: "Đã xảy ra lỗi không mong muốn!",
                  type: ToastType.error,
                );
              },
            ),

            const Divider(
              color: Colors.grey,
              thickness: 2, // Độ dày
              indent: 20, // Thụt đầu dòng trái
              endIndent: 20, // Thụt đầu dòng phải
              height: 40,
            ),

            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: PinkShadowTextField(
                //gọi khứa này ra mà xài
                label:
                    "Họ và tên", //thêm nhãn label vào để cho nó biết đây là ô nhập gì
                controller:
                    TextEditingController(), // điều khiển ô nhập này để làm gì
              ),
            ),
            const SizedBox(height: 20),
            PasswordStrengthTextField(controller: _passwordCtrl),
            const SizedBox(height: 20),

            // Ô nhập lại để kiểm tra khớp
            ConfirmPasswordTextField(originalPasswordController: _passwordCtrl),
          ],
        ),
      ),
    );
  }
}

Widget _buildButton({
  required String label,
  required VoidCallback onPressed,
  required Color color,
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 16)),
    ),
  );
}

// void showDauTayToast(BuildContext context) {
//   CustomToast.show(
//     context,
//     message: "🍓 Anh là dâu tây ngọt ngào nhất!",
//     backgroundColor: Colors.pinkAccent.shade100,
//     textColor: Colors.white,
//     icon: Icons.favorite,
//     width: 320,
//     borderRadius: 16,
//     duration: const Duration(seconds: 4),
//     messageStyle: const TextStyle(
//       fontSize: 16,
//       fontWeight: FontWeight.bold,
//       color: Colors.white,
//     ),
//     boxShadow: [
//       const BoxShadow(
//         color: Colors.pink,
//         blurRadius: 15,
//         spreadRadius: 1,
//         offset: Offset(0, 6),
//       ),
//     ],
//   );
// }
