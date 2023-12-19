import 'package:flutter/material.dart';
import 'package:maya_bot/views/screens/signup_screen.dart';

import '../../services/firebase_service.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
     navigate();
  }

  Future<void> navigate() async {
    try {
      Future.delayed(Duration(seconds: 1));
      await FirebaseService.initializeApp();
      bool isUserLoggedIn = await FirebaseService.checkUser();
      if (isUserLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignupScreen(),
          ),
        );
      }
    } catch (e) {
      print("Error checking user status: $e");
      // Handle the error, e.g., show an error message or redirect to a login screen.
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: const Center(
        child: Text(
          "Maya",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
