// import 'package:aquarium_app/home.dart';
import 'package:aquarium_app/splash_screen.dart';
// import 'package:aquarium_app/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(SmartAquariumApp());
}

class SmartAquariumApp extends StatelessWidget {
  const SmartAquariumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
