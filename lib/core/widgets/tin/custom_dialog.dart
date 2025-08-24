import 'package:flutter/material.dart';
import 'custom_button.dart';

/// [isCancel] - Nếu `true` thì hiển thị cả nút "Huỷ" và "Xác nhận",
///              nếu `false` chỉ hiển thị nút "Xác nhận".
Future<void> showCustomDialog(
  BuildContext context, {
  String title = "XÁC THỰC",
  String content = "Bạn có muốn thực hiện hành động này ?",
  required VoidCallback onConfirm,

  
  required bool isCancel,
  VoidCallback? onCancel,
  String confirmText = 'Xác nhận',
  String cancelText = 'Hủy',
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28), // chuẩn Material 3
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Content
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    isCancel
                        ? Expanded(
                          child: CustomButton(
                            text: cancelText,
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (onCancel != null) onCancel();
                            },
                          ),
                        )
                        : SizedBox.shrink(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: confirmText,
                        onPressed: () {
                          Navigator.of(context).pop();
                          onConfirm();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
  );
}
