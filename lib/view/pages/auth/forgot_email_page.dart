import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sweepspot/main.dart';
import 'package:flutter/material.dart';
import 'package:sweepspot/control/auth/auth_controller.dart';
import 'package:sweepspot/utils/utils.dart';
import 'package:sweepspot/view/widget/auth/auth_templates.dart';

class ForgotEmailPage extends StatefulWidget {
  final AuthController authController;
  ForgotEmailPage({Key? key, required this.authController}) : super(key: key);

  @override
  _ForgotEmailPageState createState() => _ForgotEmailPageState();
}

class _ForgotEmailPageState extends State<ForgotEmailPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final newemailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    newemailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(0xFFA5E4C6),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Reset Email'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Reset your Email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  'Enter your current email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 10),
                AuthInputField(
                    controller: emailController,
                    hintText: "Email",
                    validator: widget.authController.validateEmail),
                SizedBox(height: 40),
                Text(
                  'Enter your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 10),
                AuthInputField(
                    controller: passwordController,
                    hintText: "Password",
                    validator: widget.authController.validatePassword),
                SizedBox(height: 40),
                Text(
                  'Enter your new email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 10),
                AuthInputField(
                    controller: newemailController,
                    hintText: "New Email",
                    validator: widget.authController.validateEmail),
                SizedBox(height: 70),
                AuthIconButton(
                    onPressed: () async {
                      if (emailController.text.isEmpty ||
                          emailController.text !=
                              FirebaseAuth.instance.currentUser?.email) {
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Please input the correct email'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      } else if (passwordController.text.isEmpty) {
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Please input the correct password'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      } else if (newemailController.text.isEmpty ||
                          !EmailValidator.validate(newemailController.text)) {
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Please input a valid new email'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      } else {
                        try {
                          await resetEmail();
                        } catch (e) {
                          print(e);
                          Utils.showSnackBar('Failed to reset email: $e');
                        }
                      }
                    },
                    icon: Icon(Icons.email_outlined, size: 30),
                    label: "Reset Email"),
              ],
            ),
          ),
        ),
      );

  Future resetEmail() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      await userCredential.user!
          .verifyBeforeUpdateEmail(newemailController.text.trim());

      Navigator.of(context).pop(); // Close the progress indicator

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success!'),
          content: Text('Please go to your email box for more instructions.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Navigator.of(context)
          .pop(); // Close the progress indicator if there is an error
      print(e);
      Utils.showSnackBar(e.message);
    }
  }
}
