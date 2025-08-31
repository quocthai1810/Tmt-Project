import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomCardNews extends StatelessWidget {
  final String title;

  /// Tiêu đề bài viết
  final String channel;

  /// Thời gian đăng
  final String timeAgo;

  /// Thời gian đăng
  final List<String> images;

  /// Danh sách ảnh (1 hoặc nhiều ảnh)
  final String description;
  final String urlDetail;

  const CustomCardNews({
    super.key,
    required this.title,
    required this.channel,
    required this.timeAgo,
    required this.images,
    required this.description,
    required this.urlDetail,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(urlDetail);
        try {
          await launchUrl(uri);
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title & Info
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 22,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  channel,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),

            /// Images layout
            if (images.isNotEmpty) _buildImagesLayout(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesLayout() {
    if (images.length == 1) {
      /// 1 ảnh full width
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          images.first,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else if (images.length == 2) {
      /// 2 ảnh chia đôi
      return Row(
        children:
            images.map((img) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(img, height: 150, fit: BoxFit.cover),
                  ),
                ),
              );
            }).toList(),
      );
    } else if (images.length >= 3) {
      /// 3 ảnh chia 3
      return Row(
        children:
            images.take(3).map((img) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(img, height: 120, fit: BoxFit.cover),
                  ),
                ),
              );
            }).toList(),
      );
    }
    return const SizedBox.shrink();
  }
}
