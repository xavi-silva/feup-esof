import 'package:flutter/material.dart';
import 'package:sweepspot/view/widget/profile/notification_button.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onLogout;
  final VoidCallback onEditProfile;
  final VoidCallback onNotification;

  ProfileAppBar({
    required this.onLogout,
    required this.onEditProfile,
    required this.onNotification,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.logout, color: Colors.black, size: 24),
        onPressed: onLogout,
      ),
      toolbarHeight: 80,
      backgroundColor: Color(0xFFE1F7DB),
      iconTheme: IconThemeData(color: Color(0xFFE1F7DB)),
      actions: [
        NotificationButton(),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.black, size: 24),
          onPressed: onEditProfile,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);
}
