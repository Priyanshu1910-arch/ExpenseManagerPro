import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expensemanager/0uihelper.dart';
import 'package:expensemanager/0uihelper.dart';
import 'package:expensemanager/5home_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passController  = TextEditingController();

  signUp( String email , String password ) async{
    if (email.isEmpty || password.isEmpty) {
      UiHelper.CustomAlertBox(context, "Enter all required fields");
      return; }

    else{
      UserCredential ? usercredential ;

      try{
        usercredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password, );

        Navigator.push( context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
      on FirebaseAuthException catch(ex){
        return UiHelper.CustomAlertBox(context, ex.code.toString());
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
      ),

      body: Column(
          children: [
            UiHelper.CustomTextField(emailController,"Email", Icons.mail, false),
            UiHelper.CustomTextField(passController,"Password", Icons.password, true),
            SizedBox(height: 20,),

            UiHelper.CustomButton( (){
              signUp( emailController.text.trim(), passController.text.toString());
            }, "Sign Up"),
          ]

      )

      ,
    );
  }
}
