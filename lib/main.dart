import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maya_bot/providers/openai_service_provider.dart';
import 'package:maya_bot/views/screens/home_screen.dart';
import 'package:maya_bot/views/screens/login_screen.dart';
import 'package:maya_bot/views/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp() ;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OpenAiServiceProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Maya",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,

        ),
        home: const SplashScreen(),
      ),
    );
  }
}
