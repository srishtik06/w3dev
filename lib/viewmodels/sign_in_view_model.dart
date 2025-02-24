import 'package:flutter/material.dart';
import 'package:w3dev/views/home_screen.dart';
import '../services/auth_service.dart';

class SignInViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool rememberPassword = true;

  // Validate Email
  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError = 'Please enter Email';
    } else if (!value.contains('@')) {
      emailError = 'Email must contain "@"';
    } else {
      emailError = null;
    }
    notifyListeners();
  }

  // Validate Password
  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError = 'Please enter Password';
    } else {
      passwordError = null;
    }
    notifyListeners();
  }

  // Sign in action
  Future<void> signIn(BuildContext context) async {
    validateEmail(emailController.text);
    validatePassword(passwordController.text);

    if (emailError == null && passwordError == null) {
      await AuthService().signin(
        email: emailController.text,
        password: passwordController.text,
        context: context,
      ).then((_) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
        );
      });
    }
  }
}
