import 'dart:async';
import 'package:flutter/material.dart';

/// Animation hiển thị quảng cáo
class CustomAnimation extends StatefulWidget {
  final List<Map<String, dynamic>> newsList;
  const CustomAnimation({super.key, required this.newsList});

  @override
  State<CustomAnimation> createState() => _CustomAnimationState();
}

class _CustomAnimationState extends State<CustomAnimation> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.newsList.isNotEmpty) {
      _startAutoSlide();
    }
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || widget.newsList.isEmpty) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.newsList.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.newsList.isEmpty) {
      return const SizedBox();
    }

    final news = widget.newsList[_currentIndex];

    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: Card(
                key: ValueKey(news["id"] ?? _currentIndex),
                margin: const EdgeInsets.all(16),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // ảnh
                    Image.network(
                      news["hinh_anh"] ?? "",
                      fit: BoxFit.cover,
                      errorBuilder:
                          (c, e, s) =>
                              const Center(child: Icon(Icons.broken_image)),
                    ),
                    // overlay gradient
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black54, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    // text
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news["tieu_de"] ?? "",
                            maxLines: 2,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            news["ngay_tao"] ?? "",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.newsList.length, (index) {
              bool isActive = _currentIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 10, // khi active sẽ dài hơn
                height: 10,
                decoration: BoxDecoration(
                  color:
                      isActive
                          ? Theme.of(context)
                              .colorScheme
                              .primary // màu khi chọn
                          : Theme.of(
                            context,
                          ).colorScheme.primaryContainer, // màu khi chưa chọn
                  borderRadius: BorderRadius.circular(20), // bo tròn 2 đầu
                ),
              );
            }),
          ),

          // Indicator (chấm tròn)
        ],
      ),
    );
  }
}
