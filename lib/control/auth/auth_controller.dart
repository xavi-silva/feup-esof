import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class AuthController {
  final FirebaseAuth _auth;
  AuthController(this._auth);
  Future signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = _auth.currentUser!;
      user.sendEmailVerification();
    } catch (e) {
      throw e;
    }
  }

  Future isEmailVerified() async {
    final user = _auth.currentUser!;
    await user.reload();
    return user.emailVerified;
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<String> uploadImageToFirebaseStorage(File image) async {
    String imageUrl = '';
    String fileName = Path.basename(image.path);

    var reference =
        FirebaseStorage.instance.ref().child('profileImages/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((value) {
      imageUrl = value;
    }).catchError((e) {
      print("Error $e");
    });
    return imageUrl;
  }

  uploadProfileData(
    String imageUrl,
    String username,
    String firstName,
    String lastName,
  ) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': imageUrl,
      'first': firstName,
      'last': lastName,
      'username': username,
      'isAdmin': false,
    });
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email address is required';
    if (!EmailValidator.validate(email)) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty || password.length < 6)
      return 'Enter min. 6 characters';
    return null;
  }

  resetEmail(String trim) {}
}
