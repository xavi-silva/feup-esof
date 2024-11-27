import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirm Logout"),
      content: Text("Are you sure you want to log out?"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Text("Logout"),
        ),
      ],
    );
  }
}
