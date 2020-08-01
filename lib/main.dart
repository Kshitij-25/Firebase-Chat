import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/Login/login_screen.dart';
import 'package:chat_app/screens/Signup/signup_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (userSnapshot.hasData) {
            return HomeScreen();
          }
          return LoginScreen();
        },
      ),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        SignUpScreen.routeName: (ctx) => SignUpScreen(),
      },
    );
  }
}
