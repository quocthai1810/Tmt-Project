import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onChanged;
  final bool showFilter;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.hintText = "Bạn muốn tìm phim nào?",
    this.onFilterTap,
    this.onChanged,
    this.showFilter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            showFilter == true
                ? IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: onFilterTap,
                )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
