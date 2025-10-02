import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/thai/toggle_Switch/custom_toggle_1.dart';

import '../../../routers/app_route.dart';

class CustomProfile extends StatelessWidget {
  final String username;
  final String email;
  final String avatarUrl;

  const CustomProfile({
    super.key,
    required this.username,
    required this.email,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Avatar + User Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouteNames.editProfilePage);
                  },
                  icon: Icon(
                    Icons.edit_square,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// Account Section
          _buildSectionTitle(context, "Tài khoản"),
          _buildMenuItem(
            context,
            Icons.notifications,
            "Thông báo",
            toggle_switch: CustomToggleSwitch(),
          ),
          _buildMenuItem(
            context,
            Icons.lock,
            "Đổi mật khẩu",
            onTap: () {
              Navigator.pushNamed(context, AppRouteNames.createNewPasswordPage);
            },
          ),
          _buildMenuItem(
            context,
            Icons.confirmation_num,
            "Vé xem phim",
            onTap: () {
              Navigator.pushNamed(context, AppRouteNames.myTicketPage);
            },
          ),
          const SizedBox(height: 20),

          /// More Section
          _buildSectionTitle(context, "Mở rộng"),
          _buildMenuItem(
            context,
            Icons.shield_moon_rounded,
            "Điều khoản và chính sách",
            onTap: () {
              Navigator.pushNamed(context, AppRouteNames.privacyPolicyPage);
            },
          ),
          _buildMenuItem(
            context,
            Icons.info,
            "Về chúng tôi",
            onTap: () {
              Navigator.pushNamed(context, AppRouteNames.privacyPolicyPage);
            },
          ),
        ],
      ),
    );
  }

  /// Tiêu đề cho section
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  /// Item Menu (Icon + Text + Arrow)
  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title, {
    Widget? toggle_switch,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            toggle_switch ??
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
          ],
        ),
      ),
    );
  }
}
