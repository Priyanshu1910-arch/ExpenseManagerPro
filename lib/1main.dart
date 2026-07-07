import 'package:expensemanager/3checkuser.dart';
import 'package:expensemanager/4.0login_page.dart';
import 'package:expensemanager/2splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Manager Pro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
    );
  }
}


/*

Cause: You have not generated firebase_options.dart.

You must run:

cd C:\ExpenseManager

then

C:\Users\priya\AppData\Local\Pub\Cache\bin\flutterfire.bat configure

After it finishes, you'll get:

lib/
   firebase_options.dart

This error must be fixed first.
 */

