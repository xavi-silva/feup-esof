import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sweepspot/control/data_controller.dart';
import 'package:sweepspot/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sweepspot/control/auth/auth_controller.dart';
import 'package:sweepspot/view/pages/home_page.dart';
import 'package:sweepspot/view/widget/auth/auth_templates.dart';
import 'package:image_picker/image_picker.dart';

class AddProfilePage extends StatefulWidget {
  final AuthController authController;
  final DataController dataController;

  AddProfilePage(
      {Key? key, required this.authController, required this.dataController})
      : super(key: key);

  @override
  _AddProfilePageState createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  bool isProfileFinished = false;
  bool isLoading = true;
  File? profileImage;
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkProfileFinished();
  }

  @override
  void dispose() {
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  Future<void> checkProfileFinished() async {
    await widget.dataController.getUserInfo();
    if (widget.dataController.userInfo != null) {
      try {
        firstNameController.text = widget.dataController.userInfo!.get('first');
        setState(() {
          isProfileFinished = true;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA5E4C6),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isProfileFinished
              ? HomePage()
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 110),
                        ProfileImagePicker(
                          onTap: pickImage,
                          profileImage: profileImage,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Finish setting up your account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                        SizedBox(height: 20),
                        AuthInputField(
                          controller: usernameController,
                          hintText: "Username",
                          validator: (username) =>
                              username != null && username.length < 6
                                  ? 'Enter min. 6 characters for username'
                                  : null,
                        ),
                        SizedBox(height: 16),
                        AuthInputField(
                          controller: firstNameController,
                          hintText: "First Name",
                          validator: (firstName) =>
                              firstName != null && firstName.isEmpty
                                  ? 'First name cannot be empty'
                                  : null,
                        ),
                        SizedBox(height: 16),
                        AuthInputField(
                          controller: lastNameController,
                          hintText: "Last Name",
                          validator: (lastName) =>
                              lastName != null && lastName.isEmpty
                                  ? 'Last name cannot be empty'
                                  : null,
                        ),
                        SizedBox(height: 20),
                        AuthIconButton(
                          onPressed: uploadProfile,
                          icon: Icon(Icons.save_alt, size: 30),
                          label: "Save",
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Future<void> uploadProfile() async {
    String imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/sweepspot-9afed.appspot.com/o/profileImages%2FdefaultImage.jpeg?alt=media&token=d855e623-e31f-411f-b8a8-f6dd2176a6f3';
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      if (profileImage != null) {
        imageUrl = await widget.authController
            .uploadImageToFirebaseStorage(profileImage!);
      }
      await widget.authController.uploadProfileData(
        imageUrl,
        usernameController.text.trim(),
        firstNameController.text.trim(),
        lastNameController.text.trim(),
      );

      // Pop the loading dialog
      Navigator.of(context).pop();

      // Navigate to HomePage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Ensure the loading dialog is dismissed
      print(e);
      Utils.showSnackBar(e.message);
    }
  }

  void pickImage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload your Profile Photo'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      profileImage = File(image.path);
                    });
                    Navigator.pop(context);
                  }
                },
                child: Icon(
                  Icons.camera_alt,
                  size: 30,
                ),
              ),
              SizedBox(width: 20),
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      profileImage = File(image.path);
                    });
                    Navigator.pop(context);
                  }
                },
                child: Icon(
                  Icons.image,
                  size: 30,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileImagePicker extends StatelessWidget {
  final Function()? onTap;
  final File? profileImage;

  const ProfileImagePicker({Key? key, this.onTap, this.profileImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: 120,
            height: 120,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(70),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: profileImage == null
                      ? CircleAvatar(
                          radius: 56,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.add_a_photo,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 50,
                          ),
                        )
                      : CircleAvatar(
                          radius: 56,
                          backgroundColor: Colors.white,
                          backgroundImage: FileImage(profileImage!),
                        ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
