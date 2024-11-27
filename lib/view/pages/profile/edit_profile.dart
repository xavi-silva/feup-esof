import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweepspot/control/auth/auth_controller.dart';
import 'dart:io';

import 'package:sweepspot/control/data_controller.dart';
import 'package:sweepspot/main.dart';
import 'package:sweepspot/view/pages/auth/forgot_email_page.dart';
import 'package:sweepspot/view/pages/auth/forgot_password_page.dart';
import 'package:sweepspot/view/pages/events/create_event_page.dart';

class EditProfile extends StatefulWidget {
  final DataController dataController;
  final String username;
  final String first;
  final String last;
  final Function refreshCallback;

  EditProfile({
    required this.dataController,
    required this.first,
    required this.last,
    required this.username,
    required this.refreshCallback,
  });

  @override
  _EditProfileState createState() => _EditProfileState();
  AuthController authController = AuthController(FirebaseAuth.instance);
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? profileImage;
  @override
  void initState() {
    super.initState();

    // Inicialize os controladores de texto com os valores existentes
    _firstNameController.text = widget.first;
    _lastNameController.text = widget.last;
    _usernameController.text = widget.username;
  }

  pickImage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload your photo'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    profileImage = File(image.path);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: Icon(
                  Icons.camera_alt,
                  size: 30,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    profileImage = File(image.path);
                    setState(() {});
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

  Future<void> _saveChanges() async {
    // Consultar o Firestore para encontrar o documento com o username correspondente
    await widget.dataController.getUserInfo();

    String url = ''; // Inicializar a URL com uma string vazia por padrão

    if (profileImage != null) {
      // Se uma nova imagem foi selecionada, faça o upload para o Firebase Storage
      url = await widget.authController
          .uploadImageToFirebaseStorage(profileImage!);
    }

    // Atualizar os dados no Firestore com os novos valores dos campos de texto
    try {
      // Crie um mapa para os campos a serem atualizados
      Map<String, dynamic> updateData = {
        'first': _firstNameController.text,
        'last': _lastNameController.text,
        'username': _usernameController.text,
      };

      if (url.isNotEmpty) {
        updateData['image'] = url;
      }

      // Atualize os dados no Firestore
      await _firestore
          .collection('users')
          .doc(widget.dataController.userInfo!.id)
          .update(updateData);
    } catch (e) {
      print('Error updating data in Firebase: $e');
    }
    widget.refreshCallback();
  }

  void _resetEmail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotEmailPage(
            authController: AuthController(FirebaseAuth.instance)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 165, 228, 198),
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Color.fromARGB(255, 225, 247, 219),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text('First Name', style: TextStyle(color: Colors.black)),
              TextFormField(
                controller: _firstNameController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 225, 247, 219),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text('Last Name', style: TextStyle(color: Colors.black)),
              TextFormField(
                controller: _lastNameController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 225, 247, 219),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text('Username', style: TextStyle(color: Colors.black)),
              TextFormField(
                controller: _usernameController,
                style: TextStyle(color: Colors.black), // Cor do texto
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 225, 247, 219),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              EventImagePicker(
                eventImage: profileImage,
                onTap: pickImage,
                width: double.infinity,
                height: 100.0,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordPage(
                          authController:
                              AuthController(FirebaseAuth.instance)),
                    ),
                  );
                },
                child: Text(
                  'If you wish to reset your password, click here',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _resetEmail,
                child: Text(
                  'If you wish to reset your email, click here',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: SizedBox(
          width: 80,
          height: 80,
          child: FloatingActionButton(
            onPressed: () async {
              await _saveChanges();
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Success!'),
                  content: Text('Your profile has been edited.'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
              navigatorKey.currentState!.popUntil((route) => route.isFirst);
            },
            shape: CircleBorder(eccentricity: 1),
            backgroundColor: Color.fromARGB(255, 225, 247, 219),
            child: Icon(Icons.save, size: 40),
          ),
        ),
      ),
    );
  }
}
