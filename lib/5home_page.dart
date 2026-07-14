import 'package:expensemanager/0uihelper.dart';
import 'package:expensemanager/6mainpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expensemanager/4.0login_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  String selectedCurrency = "INR - Indian Rupees";
  
  @override
  void initState() {
    super.initState();
    loadCurrency();
  }

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

            SizedBox(height: 15,),

           Text(selectedCurrency, style: TextStyle(fontSize: 18 , color: Colors.grey),),

            SizedBox(height: 10,),

             SizedBox(width: 350,

               child: ElevatedButton(onPressed: () async{

                  String? currency = await
                      UiHelper.chooseCurrency(context, selectedCurrency);

                  if(currency != null){

                    setState(() {
                      selectedCurrency = currency;
                    });

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString("finalcurrency", selectedCurrency);
                  }


               }, child: Text("Choose Currency")),

             ),

             SizedBox(height: 30,),


            Text(
              "Your base currency should ideally be the one you use most often. "
                  "Your balance and statistics will be shown in this currency.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),

             SizedBox(height: 100,),
            ElevatedButton(onPressed: (){
              Navigator.push (context , MaterialPageRoute(builder: (context){
                return MainPage();
              }));
            }, child: Text("NEXT")),





            Text(selectedCurrency),


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

  Future<void> loadCurrency() async {
    var prefs = await SharedPreferences.getInstance();
    var getCurrency = prefs.getString("finalcurrency");
    setState(() {
      selectedCurrency = getCurrency ?? selectedCurrency;
    });
  }




}