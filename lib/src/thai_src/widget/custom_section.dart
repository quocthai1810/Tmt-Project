import 'package:flutter/material.dart';

class CustomSectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback? onTap;
  final bool isTap;

  const CustomSectionHeader({
    super.key,
    required this.title,
    this.actionText = "Xem tất cả >",
    this.onTap,
    this.isTap = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          isTap == true
              ? OutlinedButton(
                onPressed: onTap,
                child: Text(
                  actionText,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12,
                  ),
                ),
              )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
