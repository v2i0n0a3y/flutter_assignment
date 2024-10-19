import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_assignment/profile/firebase_profile_screen.dart';
import 'Home/homescreen.dart';
import 'authenticaton/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      storageBucket: "userauth-deb45.appspot.com",
        apiKey: "AIzaSyBWgAIzbDvsUN2Tu2jvKkaNh2Ls0rTKaZI",
        appId: "1:784066759306:android:16c7c482a1154a6a6a3b73",
        messagingSenderId: "784066759306",
        projectId: "userauth-deb45")
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
}
