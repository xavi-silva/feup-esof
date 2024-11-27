import 'package:firebase_auth/firebase_auth.dart';
import 'package:sweepspot/utils/utils.dart';
import 'package:sweepspot/control/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:sweepspot/view/widget/auth/auth_templates.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;
  final AuthController authController;

  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
    required this.authController,
  }) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthInputField(
                controller: emailController,
                hintText: "Email",
                validator: widget.authController.validateEmail,
              ),
              SizedBox(height: 16),
              AuthInputField(
                controller: passwordController,
                hintText: "Password",
                validator: widget.authController.validatePassword,
                visibilityIcon: true,
              ),
              SizedBox(height: 16),
              AuthInputField(
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                validator: (value) =>
                    passwordController.text != confirmPasswordController.text
                        ? 'Passwords do not match'
                        : null,
                visibilityIcon: true,
              ),
              SizedBox(height: 20),
              AuthIconButton(
                  onPressed: signUp,
                  icon: Icon(Icons.arrow_forward, size: 32),
                  label: "Sign Up"),
              SizedBox(height: 20),
              AuthRichText(
                  text: "Already have an account?  ",
                  linkText: "Log In",
                  onPressed: widget.onClickedSignIn),
            ],
          ),
        ),
      );

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await widget.authController.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      Navigator.of(context).pop();
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      Navigator.of(context).pop();
      Utils.showSnackBar(e.message);
    }
  }
}
