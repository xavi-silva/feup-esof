import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sweepspot/control/data_controller.dart';
import 'package:sweepspot/view/pages/events/events_display.dart';
import 'package:sweepspot/view/pages/profile/profile_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    EventsDisplay(
      firestoreInstance: FirebaseFirestore.instance,
    ),
    ProfilePage(
      dataController: DataController(
          uid: FirebaseAuth.instance.currentUser!.uid,
          firestore: FirebaseFirestore.instance),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 225, 247, 219),
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.black,
        elevation: 0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
