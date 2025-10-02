import 'package:flutter/material.dart';

class CustomIcon {
  ///chuyền icon vào, VD: Icons.[tên icon]
  final IconData iconData;

  ///Khi click vào icon đó thì xảy ra event gì
  final VoidCallback onPressed;

  /// chuyền icons và onPress tương ứng
  CustomIcon({required this.iconData, required this.onPressed});
}

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  /// tên đầu Navbar
  final String textTitle;

  /// lớp nhận các iconButton ae tự điền icon
  final List<CustomIcon> listIcon;

  /// hiển thị nút leading(button back về) có hoặc không
  final bool showLeading;

  /// custom Appbar dùng cho toàn app
  const CustomAppbar({
    super.key,
    this.textTitle = "Tmt Project",
    required this.listIcon,
    required this.showLeading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showLeading,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(
        textTitle,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      leading:
          showLeading
              ? IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
              : null,
      actions:
          listIcon
              .map(
                (icon) => IconButton(
                  onPressed: icon.onPressed,
                  icon: Icon(icon.iconData),
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
              .toList(),
    );
  }
}
