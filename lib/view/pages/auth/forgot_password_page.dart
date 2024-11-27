import 'package:firebase_auth/firebase_auth.dart';
import 'package:sweepspot/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sweepspot/control/auth/auth_controller.dart';
import 'package:sweepspot/view/widget/auth/auth_templates.dart';

class ForgotPasswordPage extends StatefulWidget {
  final AuthController authController;
  ForgotPasswordPage({Key? key, required this.authController})
      : super(key: key);
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(0xFFA5E4C6),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Reset Password'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Reset your password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black.withOpacity(0.9),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Enter a valid e-mail to receive instructions on how to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 40),
              AuthInputField(controller: emailController, hintText: "Email"),
              SizedBox(height: 25),
              AuthIconButton(
                  onPressed: resetPassword,
                  icon: Icon(Icons.email_outlined, size: 30),
                  label: "Reset Password"),
            ],
          ),
        ),
      );

  Future resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await widget.authController.resetPassword(emailController.text.trim());
      Utils.showSnackBar('Password Reset Email Sent');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
