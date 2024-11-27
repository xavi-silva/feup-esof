import 'package:firebase_auth/firebase_auth.dart';
import 'package:sweepspot/control/auth/auth_controller.dart';
import 'package:sweepspot/view/widget/auth/login_widget.dart';
import 'package:sweepspot/view/widget/auth/signup_widget.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(0xFFA5E4C6),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthImageSection(),
              isLogin
                  ? LoginWidget(
                      onClickedSignUp: toggle,
                      authController: AuthController(_auth),
                    )
                  : SignUpWidget(
                      onClickedSignIn: toggle,
                      authController: AuthController(_auth),
                    ),
            ],
          ),
        ),
      );

  void toggle() => setState(() => isLogin = !isLogin);
}

class AuthImageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 60),
        Image.asset(
          "assets/login_icon.png",
          width: 300,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
