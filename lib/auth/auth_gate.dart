import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ocr_2/auth/login_or_register.dart';
import 'package:ocr_2/pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    print("Auth state: ${snapshot.connectionState}, User: ${snapshot.data}");

    if (snapshot.hasData) {
      return HomePage();
    } else {
      return const LoginOrRegister();
    }
  },
)

    );
  }
}