import 'package:flutter/material.dart';

class CustomCardTheater extends StatelessWidget {
  final String title;
  final String address;
  final String ward;
  final String? image;
  final VoidCallback? onTap;
  final VoidCallback? onDirectionTap;

  const CustomCardTheater({
    super.key,

    /// tên rạp
    required this.title,

    /// địa chỉ rạp
    required this.address,
    required this.ward,

    /// logo hoặc ảnh rạp
    this.image,
    this.onTap, // nhấn vào card
    this.onDirectionTap, // nhấn vào "Tìm đường"
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Ảnh rạp
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      borderRadius: BorderRadius.circular(12),
                      image:
                          image != null
                              ? DecorationImage(
                                image: NetworkImage(image!),
                                fit: BoxFit.cover,
                              )
                              : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Thông tin rạp
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ward,
                          maxLines: 1,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Nút "Tìm đường"
                  GestureDetector(
                    onTap: onDirectionTap,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Tìm đường",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                address,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
