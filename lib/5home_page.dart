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


            ElevatedButton(
              onPressed: () async {
                await addStudent();
              },
              child: Text("Add Student"),
            ),
            ElevatedButton(
              onPressed: () async {
                await getStudents(7);
              },
              child: Text("Add Student"),
            ),


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

  Future<void> addStudent() async {
    final response = await http.post( Uri.parse("http://10.0.2.2:8080/addStudent"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        // "name": "priyanshu",
        // "mark": 90,
        // "address1": "Delhi"
        "currency": selectedCurrency,
      }),
    );

    print(response.body);
  }


  Future<void> getStudents(int id) async {
    try {
      final response = await http.get(Uri.parse("http://10.0.2.2:8080/getDetailsById/$id"),
      );

      if (response.statusCode == 200) {
       // print(response.body);

     //   List data = jsonDecode(response.body);
        Map<String, dynamic> student = jsonDecode(response.body);
        print(student);
        print(student["currency"]);

        setState(() {
          selectedCurrency = student["currency"];
        });



        // for (var student in data) {
        //   print(student);
        // }
      }
      else {
        print("Error: ${response.statusCode}");
      }
    }
    catch (e) {
      print(e);
    }
  }

}