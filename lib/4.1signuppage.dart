import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expensemanager/0uihelper.dart';
import 'package:expensemanager/0uihelper.dart';
import 'package:expensemanager/5home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController nameController = TextEditingController();
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
        
        User user = usercredential.user!;
        
        final response =  await http.post(
          Uri.parse("http://10.0.2.2:8080/user"),
          headers: {"Content-Type": "application/json",},
          body: jsonEncode({
             "firebaseUid" : user.uid,
              "email" : user.email,
              "name" : nameController.text,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          print("User saved successfully");

          Navigator.push( context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );

        } else {
          print("Failed to save user");
          print(response.body);
        }


      }

      on FirebaseAuthException catch(ex){
        return UiHelper.CustomAlertBox(context, ex.code.toString());
      }

      catch (e) {   // If Spring Boot is not running, http.post() can throw an exception.
        UiHelper.CustomAlertBox(context, e.toString());
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
            UiHelper.CustomTextField(controller:  nameController,hintText:  "Name",iconData:  Icons.person,toHide:  false),
            UiHelper.CustomTextField(controller:  emailController,hintText:  "Email",iconData:  Icons.mail,toHide:  false),
            UiHelper.CustomTextField(controller:  passController,hintText:  "Password",iconData:  Icons.password,toHide:  true),
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
