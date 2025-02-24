import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:w3dev/services/notification_service.dart';
import 'package:w3dev/themes/app_theme.dart';
import 'package:w3dev/views/home_screen.dart';
import 'package:w3dev/views/signin_screen.dart';
import 'package:w3dev/views/signup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  await NotificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: AuthCheck(), // Dynamically determine the starting screen
      routes: {
        '/SignUp': (context) => SignUpScreen(),
        '/SignIn': (context) => SignInScreen(),
        '/Home': (context) => HomeScreen(),
      },
    );
  }
}

// Check authentication status and decide which screen to show
class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<firebase_auth.User?>(
      stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator())); // Show loading screen
        }
        if (snapshot.hasData && snapshot.data != null) {
          return HomeScreen(); // If logged in, go to home
        } else {
          return SignUpScreen(); // If not logged in, go to sign-up
        }
      },
    );
  }
}
