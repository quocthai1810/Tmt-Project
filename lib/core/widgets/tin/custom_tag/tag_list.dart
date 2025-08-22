import 'package:flutter/material.dart';
import 'custom_tag.dart';

class TagList extends StatelessWidget {
  final List<String> tags;
  final void Function(String)? onTagTap;

  const TagList({Key? key, required this.tags, this.onTagTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children:
          tags.map((tag) {
            return CustomTag(
              text: tag,
              onTap: () {
                if (onTagTap != null) {
                  onTagTap!(tag);
                }
              },
            );
          }).toList(),
    );
  }
}
