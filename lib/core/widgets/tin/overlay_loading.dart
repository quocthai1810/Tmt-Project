import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:tmt_project/core/widgets/tin/custom_loading.dart';

class OverlayLoading {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    if (_overlayEntry != null) return; // Tránh show nhiều lần

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              // Chặn tương tác
              ModalBarrier(
                color: Colors.black.withOpacity(0.3), // nền mờ
                dismissible: false, // không thể click để dismiss
              ),

              // Center loading
              Center(child: CustomLoading(width: 150, height: 150)),
            ],
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
