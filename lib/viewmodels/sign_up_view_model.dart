import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:w3dev/views/home_screen.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpViewModel extends ChangeNotifier {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? fullNameError;
  bool agreePersonalData = true;

  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Constructor: Attach listeners for real-time validation
  SignUpViewModel() {
    fullNameController.addListener(() => validateFullName(fullNameController.text));
    emailController.addListener(() => validateEmail(emailController.text));
    passwordController.addListener(() => validatePassword(passwordController.text));
  }

  // Google Sign-In
  Future<void> signInWithGoogle(BuildContext context) async {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print("Google authentication failed: Token is null");
        return;
      }

      final firebase_auth.OAuthCredential credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebase_auth.UserCredential userCredential = await _auth.signInWithCredential(credential);
      final firebase_auth.User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        print("Google Sign-In successful: ${firebaseUser.email}");

        // Check if user already exists in Firestore
        final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();

        if (!userDoc.exists) {
          // Add user to Firestore with only name & email
          await _firestore.collection('users').doc(firebaseUser.uid).set({
            'name': firebaseUser.displayName ?? "Unknown",
            'email': firebaseUser.email ?? "",
          });
        }

        // Navigate to HomeScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
        );
      }
  }

  // Email Validation
  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError = 'Please enter your Email';
    } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
      emailError = 'Enter a valid email address';
    } else {
      emailError = null;
    }
    notifyListeners();
  }

  // Password Validation
  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError = 'Please enter your Password';
    } else if (value.length < 8) {
      passwordError = 'Password must be at least 8 characters';
    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(value)) {
      passwordError = 'Password must contain at least 1 uppercase letter and 1 number';
    } else {
      passwordError = null;
    }
    notifyListeners();
  }

  // Full Name Validation
  void validateFullName(String value) {
    if (value.isEmpty) {
      fullNameError = 'Please enter your Full Name';
    } else {
      fullNameError = null;
    }
    notifyListeners();
  }

  // Email/Password Sign-Up with Existing User Check
  Future<void> signUp(BuildContext context) async {
    validateEmail(emailController.text);
    validatePassword(passwordController.text);
    validateFullName(fullNameController.text);

    if (emailError == null && passwordError == null && fullNameError == null) {
      String email = emailController.text.trim();

      try {
        // Check if user already exists in Firestore
        var existingUser = await _firestore.collection('users').where('email', isEqualTo: email).get();

        if (existingUser.docs.isNotEmpty) {
          Fluttertoast.showToast(
            msg: 'User already exists. Please sign in.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return;
        }

        // Create new user
        User user = User(
          fullName: fullNameController.text,
          email: email,
          password: passwordController.text,
        );

        await AuthService().signup(
          email: user.email,
          password: user.password,
          name: user.fullName,
          context: context,
        ).then((_) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false,
          );
        });

      } on firebase_auth.FirebaseAuthException catch (e) {
        String message = 'Signup failed. Please try again.';
        if (e.code == 'email-already-in-use') {
          message = 'An account already exists with this email. Please sign in.';
        }
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
        );
      } catch (e) {
        print("Error during signup: $e");
      }
    }
  }

  // Dispose method to free memory
  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
