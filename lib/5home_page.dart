import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expensemanager/4.0login_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(

          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child:
              Container( width: 150, height: 150,
                decoration: BoxDecoration( color: Colors.green.shade400, shape: BoxShape.circle,),

                 child: Padding(
                   padding: const EdgeInsets.all(40),
                   child: Opacity( opacity: 0.6,
                     child: Image.asset( "assets/images/money.png", ),
                   ),
                 ),


              ),
            ),
            SizedBox(height: 30),
            Text("Select base currency" ,style: TextStyle(fontSize: 23),),

            SizedBox(height: 30,),

            DropdownButtonFormField<String>(
              value: "INR",
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              items: const [
                DropdownMenuItem(
                  value: "INR",
                  child: Text("INR - Indian Rupee"),
                ),
                DropdownMenuItem(
                  value: "USD",
                  child: Text("USD - US Dollar"),
                ),
                DropdownMenuItem(
                  value: "EUR",
                  child: Text("EUR - Euro"),
                ),
              ],
              onChanged: (value) {},
            ),

            SizedBox(height: 10,),

            Text(
              "Your base currency should ideally be the one you use most often. "
                  "Your balance and statistics will be shown in this currency.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),




          ],
        ),
      ),

    );



  }

  Future<void>  logOut() async{ await
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) {
      return LoginPage();
    }));
  }
}