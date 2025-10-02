import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';

class CustomListTile extends StatelessWidget {
  /// Hình ảnh hiển thị bên trái
  final String imageUrl;

  /// Text lớn (tiêu đề, tên sp, tên phim,...)
  final String title;

  /// Text nhỏ (mô tả, phụ đề, giá, số tiền)
  final String subtitle;

  /// Danh sách icon (thêm bao nhiêu tùy)
  final List<CustomIcon> icons;

  /// Sự kiện khi click vào
  final VoidCallback? onTap;

  const CustomListTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.onTap,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Theme.of(context).colorScheme.primaryContainer, // màu cứng chung
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // bo góc cứng
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hình ảnh
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              // Text lớn & nhỏ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              // Danh sách icon
              Row(
                mainAxisSize: MainAxisSize.min,
                children:
                    icons.map((icon) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: IconButton(
                          icon: Icon(
                            icon.iconData,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: icon.onPressed,
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
