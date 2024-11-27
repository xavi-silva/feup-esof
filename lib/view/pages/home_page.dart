//import 'package:firebase_auth/firebase_auth.dart';
import 'package:sweepspot/utils/navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLogin = true;

  //FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: BottomNavBar(),
      );
}
