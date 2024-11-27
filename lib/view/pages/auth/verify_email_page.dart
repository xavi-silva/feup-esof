import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sweepspot/control/data_controller.dart';
import 'package:sweepspot/view/pages/auth/add_profile_page.dart';
import 'package:sweepspot/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sweepspot/control/auth/auth_controller.dart';
import 'package:sweepspot/view/widget/auth/auth_templates.dart';

class VerifyEmailPage extends StatefulWidget {
  final AuthController authController;
  VerifyEmailPage({Key? key, required this.authController}) : super(key: key);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late AuthController authController;
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    final isVerified = await widget.authController.isEmailVerified();
    if (this.mounted) {
      setState(() {
        isEmailVerified = isVerified;
      });
    }

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      await widget.authController.sendVerificationEmail();
      if (this.mounted) {
        setState(() => canResendEmail = false);
      }
      await Future.delayed(Duration(seconds: 5));
      if (this.mounted) {
        setState(() => canResendEmail = true);
      }
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? AddProfilePage(
          authController: AuthController(FirebaseAuth.instance),
          dataController: DataController(
              uid: FirebaseAuth.instance.currentUser!.uid,
              firestore: FirebaseFirestore.instance),
        )
      : Scaffold(
          backgroundColor: Color(0xFFA5E4C6),
          appBar: AppBar(
            title: Text('Verify Email'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthEmailIconSection(),
                SizedBox(height: 10),
                Text(
                  'Verify your email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "To complete your profile and start participating in clean-up events, you'll need to verify your email address.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 24),
                AuthIconButton(
                    onPressed: canResendEmail ? sendVerificationEmail : null,
                    icon: Icon(Icons.refresh, size: 24),
                    label: "Resend Email"),
                SizedBox(height: 8),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                ),
              ],
            ),
          ),
        );
}

class AuthEmailIconSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/email.png",
          width: 180,
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
