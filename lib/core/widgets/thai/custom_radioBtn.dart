import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final Map<int, String> options;
  final int? selectedValue;
  final ValueChanged<int> onChanged;
  final Map<int, String> images;

  const CustomRadioButton({
    Key? key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final key = options.keys.elementAt(index);
        final value = options[key] ?? "";
        final imagePath = images[key];

        ImageProvider? imageProvider;
        if (imagePath != null && imagePath.isNotEmpty) {
          imageProvider =
              imagePath.startsWith("http")
                  ? NetworkImage(imagePath)
                  : AssetImage(imagePath) as ImageProvider;
        }

        final bool isSelected = selectedValue == key;

        return GestureDetector(
          onTap: () => onChanged(key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
              border: Border.all(
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primaryContainer,
                width: isSelected ? 4 : 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Ảnh nền
                  Container(
                    decoration: BoxDecoration(
                      image:
                          imageProvider != null
                              ? DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              )
                              : null,
                      color: Colors.grey.shade200,
                    ),
                    child:
                        imageProvider == null
                            ? const Center(
                              child: Icon(
                                Icons.image,
                                size: 40,
                                color: Colors.grey,
                              ),
                            )
                            : null,
                  ),
                  // Overlay tối mặc định, khi chọn thì mờ đi
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color:
                          isSelected
                              ? Colors.transparent
                              : Colors.black.withOpacity(0.7),
                    ),
                  ),
                  // Text
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          const Shadow(
                            blurRadius: 4,
                            color: Colors.black54,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
