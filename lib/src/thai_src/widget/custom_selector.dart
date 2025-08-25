import 'package:flutter/material.dart';

class CustomSelector extends StatelessWidget {
  /// tên rạp
  final String names;
  /// hình ảnh
  final String images;
  final isSelected;
  final VoidCallback? onTap;

  const CustomSelector({
    super.key,
    required this.names,
    required this.images,
    this.isSelected = false,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: SizedBox(
          height: 90,
          child:
          // Khung ảnh
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primaryContainer,
                      width: isSelected ? 4 : 1,
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(images, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // tên rạp
              Text(
                names,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: isSelected ? 16 : 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
