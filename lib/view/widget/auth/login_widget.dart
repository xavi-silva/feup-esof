import 'package:firebase_auth/firebase_auth.dart';
import 'package:sweepspot/main.dart';
import 'package:sweepspot/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sweepspot/control/auth/auth_controller.dart';
import 'package:sweepspot/view/pages/auth/forgot_password_page.dart';
import 'package:sweepspot/view/widget/auth/auth_templates.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  final AuthController authController;

  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
    required this.authController,
  }) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscure = true; // Track whether the password is obscured or not

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 22),
            AuthInputField(
              controller: emailController,
              hintText: "Email",
              validator: widget.authController.validateEmail,
            ),
            SizedBox(height: 16),
            AuthInputField(
              controller: passwordController,
              hintText: "Password",
              visibilityIcon: true,
              validator: widget.authController.validatePassword,
            ),
            SizedBox(height: 25),
            AuthIconButton(
                onPressed: signIn,
                icon: Icon(Icons.lock_open, size: 32),
                label: "Sign In"),
            SizedBox(height: 35),
            GestureDetector(
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).colorScheme.secondary,
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 20,
                ),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ForgotPasswordPage(
                    authController: widget.authController,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            AuthRichText(
                text: "No account?  ",
                linkText: "Sign Up",
                onPressed: widget.onClickedSignUp),
          ],
        ),
      );

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    bool exceptionThrown = false;
    try {
      await widget.authController.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      exceptionThrown = true;
      print(e);
      Utils.showSnackBar(e.message);
    } finally {
      // Dismiss the dialog whether an exception occurred or not
      Navigator.of(context).pop(); // Dismiss the CircularProgressIndicator
    }

    if (!exceptionThrown) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }
}
