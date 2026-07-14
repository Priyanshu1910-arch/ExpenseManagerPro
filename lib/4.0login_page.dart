import 'package:expensemanager/1main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expensemanager/0uihelper.dart';
import 'package:expensemanager/4.1signuppage.dart';
import 'package:expensemanager/5home_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  login ( String email , String pass ) async {

    if (email.isEmpty || pass.isEmpty ){
      return UiHelper.CustomAlertBox(context, "Enter all required fields");
    }
    
    else{
      UserCredential ? usercredentail;
      
      try{
        usercredentail = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email , password: pass );

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomePage();
        }) );
      }

      on FirebaseAuthException catch(ex){
        return UiHelper.CustomAlertBox(context, ex.code.toString());
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  appBar: AppBar(),

        body:

            Column(
              children: [
                Container(color: Colors.green.shade400, height: 300, width: double.infinity,
                
                   child: Icon(Icons.wallet , size: 150, color: Colors.white,),




                
                ),

                Expanded(
                  child: Container( height: 200, width: double.infinity,

                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Text("Sign in or create a secure\naccount" ,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25),),
                        ),

                        UiHelper.CustomTextField(controller:  emailController, hintText: "Email", iconData:  Icons.mail,toHide:  false),
                        UiHelper.CustomTextField(controller:  passController,hintText:  "Password",iconData:  Icons.password,toHide:  true),
                        SizedBox(height: 30,),

                        UiHelper.CustomButton( () {
                          login(emailController.text.toString(), passController.text.toString());
                        } , "Login" , ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [

                            Text("Already have an account?"),
                            TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return SignUp();
                              }));

                            },
                                child: Text("Sign Up" ,
                                  style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),))
                          ],
                        ),

                        SizedBox(height: 20,),

                        // TextButton(onPressed: (){
                        //   Navigator.push(context , MaterialPageRoute(builder: (context) {
                        //     return Resetpass();
                        //   }) );
                        // }, child: Text("Reset Pass"))

                      ],
                    ),


                  ),
                )
              ],
            )





      ,
    );
  }
}
