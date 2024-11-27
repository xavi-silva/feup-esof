import 'package:flutter/material.dart';
import 'package:sweepspot/control/auth/auth_controller.dart';
import 'package:sweepspot/main.dart';
import 'package:sweepspot/view/pages/auth/add_profile_page.dart';
import 'package:sweepspot/view/pages/profile/edit_profile.dart';
import 'package:sweepspot/view/widget/profile/logout_dialog.dart';
import 'package:sweepspot/view/widget/profile/profile_app_bar.dart';
import 'package:sweepspot/view/widget/profile/profile_content.dart';
import 'package:sweepspot/control/data_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class ProfilePage extends StatefulWidget {
  final DataController dataController;

  ProfilePage({Key? key, required this.dataController}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List<DocumentSnapshot>? filteredEvents;
  String image = '';
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await widget.dataController.getUserInfo();
    await widget.dataController.getUserEvents();

    _populateControllers(); // Populate the controllers
  }

  void _refreshData() {
    _fetchData();
  }

  void _populateControllers() {
    if (widget.dataController.userInfo != null) {
      try {
        setState(() {
          firstNameController.text = widget.dataController.userInfo!['first'];
          lastNameController.text = widget.dataController.userInfo!['last'];
          usernameController.text = widget.dataController.userInfo!['username'];
          image = widget.dataController.userInfo!['image'] ?? '';
          _dataLoaded =
              true; // Set _dataLoaded to true after populating controllers
        });
      } catch (e) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AddProfilePage(
              authController: AuthController(FirebaseAuth.instance),
              dataController: DataController(
                uid: FirebaseAuth.instance.currentUser!.uid,
                firestore: FirebaseFirestore.instance,
              ),
            ),
          ),
        );
      }
    }

    if (widget.dataController.userEvents != null) {
      setState(() {
        filteredEvents = widget.dataController.userEvents!.where((event) {
          DateTime eventDateTime = DateTime.parse(event['datetime'] + ":30");
          return eventDateTime.isBefore(DateTime.now());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      });

      return Container();
    }

    if (FirebaseAuth.instance.currentUser?.uid != null) {
      widget.dataController
          .updateUidAndReloadData(FirebaseAuth.instance.currentUser!.uid);
    }
    _refreshData();
    return Scaffold(
      backgroundColor: Color(0xFFA5E4C6),
      appBar: ProfileAppBar(
        onLogout: _showLogoutDialog,
        onEditProfile: () => _editProfile(context),
        onNotification: _initializeNotificationService,
      ),
      body: SafeArea(
        top: true,
        child: _dataLoaded
            ? ProfileContent(
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                username: usernameController.text,
                image: image,
                cleanupsCount: filteredEvents?.length ?? 0,
                filteredEvents: filteredEvents,
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutDialog();
      },
    );
  }

  void _initializeNotificationService() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void _editProfile(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfile(
          dataController: widget.dataController,
          first: firstNameController.text,
          last: lastNameController.text,
          username: usernameController.text,
          refreshCallback: _refreshData,
        ),
      ),
    );
  }
}
