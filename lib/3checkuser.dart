import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expensemanager/4.0login_page.dart';
import 'package:expensemanager/1main.dart';
import 'package:expensemanager/5home_page.dart';

class Checkuser extends StatelessWidget {
  const Checkuser({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}