import 'package:flutter/material.dart';

class Customtextfield extends StatefulWidget {
  const Customtextfield({super.key});

  @override
  State<Customtextfield> createState() => _CustomtextfieldState();
}

class _CustomtextfieldState extends State<Customtextfield> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

/// class này dùng để tạo một TextField với viền hồng và bóng đổ
/// nó sẽ có viền hồng và bóng đổ khi được focus
class PinkShadowTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const PinkShadowTextField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}

/// class này dùng để nhập mật khẩu và hiển thị độ mạnh của mật khẩu
/// nó sẽ hiển thị một thanh tiến độ và một nhãn bên cạnh để cho biết
class PasswordStrengthTextField extends StatefulWidget {
  final TextEditingController? controller;

  const PasswordStrengthTextField({super.key, this.controller});

  @override
  State<PasswordStrengthTextField> createState() =>
      _PasswordStrengthTextFieldState();
}

class _PasswordStrengthTextFieldState extends State<PasswordStrengthTextField> {
  late final TextEditingController _controller;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  double _getStrength() {
    final length = _controller.text.length;
    if (length == 0) return 0;
    if (length < 4) return 0.25;
    if (length < 8) return 0.5;
    if (length < 12) return 0.75;
    return 1.0;
  }

  Color _getStrengthColor() {
    final value = _getStrength();
    if (value <= 0.25) return Colors.red;
    if (value <= 0.5) return Colors.orange;
    if (value <= 0.75) return Colors.yellow.shade700;
    return Colors.green;
  }

  String _getStrengthLabel() {
    final value = _getStrength();
    if (value == 0) return '';
    if (value <= 0.25) return 'Yếu';
    if (value <= 0.5) return 'Trung bình';
    if (value <= 0.75) return 'Khá';
    return 'Mạnh';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          obscureText: _obscureText,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: "Mật khẩu",
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _controller.clear();
                    setState(() {});
                  },
                ),
              ],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 6),
        if (_controller.text.isNotEmpty)
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: _getStrength(),
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getStrengthColor(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _getStrengthLabel(),
                style: TextStyle(
                  color: _getStrengthColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

/// class này dùng để nhập mật khẩu và xác nhận mật khẩu
/// nó sẽ hiển thị một TextField để nhập mật khẩu và một TextField để xác nhận mật khẩu
/// nếu mật khẩu và xác nhận mật khẩu không khớp thì sẽ hiển thị một thông báo lỗi
/// nếu mật khẩu và xác nhận mật khẩu khớp thì sẽ không hiển thị thông báo lỗi
/// nó sẽ gọi hàm onMatchChanged khi mật khẩu và xác nhận mật khẩu khớp
/// hoặc không khớp để thông báo cho widget cha biết
class ConfirmPasswordTextField extends StatefulWidget {
  final TextEditingController originalPasswordController;

  const ConfirmPasswordTextField({
    super.key,
    required this.originalPasswordController,
  });

  @override
  State<ConfirmPasswordTextField> createState() =>
      _ConfirmPasswordTextFieldState();
}

class _ConfirmPasswordTextFieldState extends State<ConfirmPasswordTextField>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _obscureText = true;
  bool _isMatching = true;

  late AnimationController _shakeController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.03, 0),
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    _controller.addListener(_checkMatch);
    widget.originalPasswordController.addListener(_checkMatch);
  }

  void _checkMatch() {
    final match = _controller.text == widget.originalPasswordController.text;

    if (_controller.text.isEmpty) {
      setState(() => _isMatching = true);
      return;
    }

    if (_isMatching != match) {
      setState(() => _isMatching = match);
      if (!match) {
        _shakeController.forward(from: 0); // 🔥 bắt đầu rung
      }
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _controller.dispose();
    widget.originalPasswordController.removeListener(_checkMatch);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: "Nhập lại mật khẩu",
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              errorText:
                  _controller.text.isNotEmpty && !_isMatching
                      ? "❌ Mật khẩu không khớp"
                      : null,
            ),
          ),
          const SizedBox(height: 6),
          if (_controller.text.isNotEmpty && _isMatching)
            Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                SizedBox(width: 6),
                Text(
                  "Mật khẩu khớp",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
