import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationButton extends StatefulWidget {
  @override
  _NotificationButtonState createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  Future<bool> _isNotificationAllowed = Future.value(false);

  @override
  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  void _checkNotificationStatus() {
    setState(() {
      _isNotificationAllowed = AwesomeNotifications().isNotificationAllowed();
    });
  }

  Future<void> _requestNotificationPermission() async {
    bool isAllowed =
        await AwesomeNotifications().requestPermissionToSendNotifications();
    if (isAllowed) {
      _checkNotificationStatus();
    } else {
      setState(() {
        _isNotificationAllowed = Future.value(isAllowed);
      });
    }
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Notification Settings'),
          content:
              Text('Notifications can only be deactivated in the settings.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isNotificationAllowed,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          bool isAllowed = snapshot.data ?? false;
          return IconButton(
            icon: Icon(
              isAllowed ? Icons.notifications : Icons.notifications_off,
              color: Colors.black,
              size: 24,
            ),
            onPressed: isAllowed
                ? () => _showSettingsDialog(context)
                : () => _requestNotificationPermission(),
          );
        }
      },
    );
  }
}
