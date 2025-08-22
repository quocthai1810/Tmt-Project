import 'package:flutter/material.dart';

class CustomListItemHorizontal extends StatelessWidget {
  final List<Widget> items;
  final double spacing;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics? physics;
  final bool reverse;
  final Axis scrollDirection;
  final bool shrinkWrap;

  const CustomListItemHorizontal({
    super.key,
    required this.items,
    this.spacing = 8.0,
    this.padding = const EdgeInsets.all(8.0),
    this.physics,
    this.reverse = false,
    this.scrollDirection = Axis.horizontal,
    this.shrinkWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: ListView.separated(
        scrollDirection: scrollDirection,
        reverse: reverse,
        shrinkWrap: shrinkWrap,
        physics: physics ?? const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder:
            (context, index) => SizedBox(
              width: scrollDirection == Axis.horizontal ? spacing : 0,
              height: scrollDirection == Axis.vertical ? spacing : 0,
            ),
        itemBuilder: (context, index) {
          return items[index];
        },
      ),
    );
  }

  // Static method để tạo Card Item
  static Widget createCardItem({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    Color? color,
    double elevation = 2.0,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 4.0),
      child: Card(
        elevation: elevation,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8.0),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(8.0),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(12.0),
            child: child,
          ),
        ),
      ),
    );
  }

  // Static method để tạo Container Item
  static Widget createContainerItem({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    VoidCallback? onTap,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 4.0),
      padding: padding ?? const EdgeInsets.all(12.0),
      decoration:
          decoration ??
          BoxDecoration(
            color: color ?? Colors.grey[100],
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: child,
      ),
    );
  }

  // Static method để tạo Movie Item giống poster phim
  static Widget createMovieItem({
    required String title,
    required String genre,
    required String rating,
    required int reviewCount,
    String ageRating = "13+",
    Color ageRatingColor = Colors.orange,
    double? width,
    double? height,
    VoidCallback? onTap,
    String imageUrl = "",
  }) {
    return Container(
      width: width ?? 180,
      height: height ?? 280,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Stack(
              children: [
                // Background image/placeholder
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.grey[300]!, Colors.grey[600]!],
                    ),
                  ),
                  child: const Icon(
                    Icons.movie,
                    size: 60,
                    color: Colors.white70,
                  ),
                ),

                // Age rating badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ageRatingColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ageRating,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                // Movie info overlay at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Rating
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '($reviewCount đánh giá)',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Title
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Genre
                        Text(
                          genre,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Example usage class
class CustomListItemHorizontalExample extends StatelessWidget {
  const CustomListItemHorizontalExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom List Item Horizontal')),
      body: Column(
        children: [
          // Example with Card items
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Card Items Example:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          CustomListItemHorizontal(
            items: [
              CustomListItemHorizontal.createCardItem(
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home, size: 40, color: Colors.blue),
                    SizedBox(height: 8),
                    Text('Home'),
                  ],
                ),
                width: 100,
                height: 100,
                onTap: () => print('Home tapped'),
              ),
              CustomListItemHorizontal.createCardItem(
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.settings, size: 40, color: Colors.green),
                    SizedBox(height: 8),
                    Text('Settings'),
                  ],
                ),
                width: 100,
                height: 100,
                onTap: () => print('Settings tapped'),
              ),
              CustomListItemHorizontal.createCardItem(
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: 40, color: Colors.orange),
                    SizedBox(height: 8),
                    Text('Profile'),
                  ],
                ),
                width: 100,
                height: 100,
                onTap: () => print('Profile tapped'),
              ),
              CustomListItemHorizontal.createCardItem(
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications, size: 40, color: Colors.red),
                    SizedBox(height: 8),
                    Text('Notifications'),
                  ],
                ),
                width: 100,
                height: 100,
                onTap: () => print('Notifications tapped'),
              ),
            ],
            spacing: 12.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
          ),

          const SizedBox(height: 32),

          // Example with Container items
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Container Items Example:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          CustomListItemHorizontal(
            items: [
              CustomListItemHorizontal.createContainerItem(
                child: const Text(
                  'Item 1',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                color: Colors.blue[100],
                width: 80,
                height: 60,
                onTap: () => print('Container Item 1 tapped'),
              ),
              CustomListItemHorizontal.createContainerItem(
                child: const Text(
                  'Item 2',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                color: Colors.green[100],
                width: 80,
                height: 60,
                onTap: () => print('Container Item 2 tapped'),
              ),
              CustomListItemHorizontal.createContainerItem(
                child: const Text(
                  'Item 3',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                color: Colors.orange[100],
                width: 80,
                height: 60,
                onTap: () => print('Container Item 3 tapped'),
              ),
              CustomListItemHorizontal.createContainerItem(
                child: const Text(
                  'Item 4',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                color: Colors.purple[100],
                width: 80,
                height: 60,
                onTap: () => print('Container Item 4 tapped'),
              ),
              CustomListItemHorizontal.createContainerItem(
                child: const Text(
                  'Item 5',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                color: Colors.red[100],
                width: 80,
                height: 60,
                onTap: () => print('Container Item 5 tapped'),
              ),
            ],
            spacing: 10.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
          ),

          const SizedBox(height: 32),

          // Example with reverse direction
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Reverse Direction Example:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          CustomListItemHorizontal(
            reverse: true, // Hiển thị ngược từ phải sang trái
            items: List.generate(
              6,
              (index) => CustomListItemHorizontal.createCardItem(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                width: 60,
                height: 60,
                color: Colors.primaries[index % Colors.primaries.length][100],
                onTap: () => print('Reverse Item ${index + 1} tapped'),
              ),
            ),
            spacing: 8.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ],
      ),
    );
  }
}
