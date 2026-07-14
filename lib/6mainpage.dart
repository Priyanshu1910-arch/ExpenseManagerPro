import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensemanager/0uihelper.dart';
import 'package:expensemanager/8edit.dart';
import 'package:flutter/material.dart';
import 'package:expensemanager/7add.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {


  const MainPage(   {super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();
    getExpenses();
  }

  List < dynamic > expenses = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(

    appBar: AppBar(
      toolbarHeight: 30,
      backgroundColor: Colors.grey.shade700,
      leading: IconButton(onPressed: (){}, icon: Icon(Icons.menu) , color: Colors.black.withValues(alpha: 0.9),),
      title: Text("Money Tracker" , style: TextStyle(fontWeight: FontWeight.bold),), centerTitle: true,
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.search) , color: Colors.black.withValues(alpha: 0.5),),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(onPressed: (){}, icon: Icon(Icons.edit_calendar) , color: Colors.black.withValues(alpha: 0.5), ),
        ),
      ],
    ),

      body:
      Container(
        color:  Colors.grey,
        child: Column(

          children: [

             Container(height: 61, color: Colors.grey.shade700,  child:
            Row(

              children: [
                InkWell(
                  onTap: (){},
                  child: Container(
                    width: 90,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20 , top: 3 ),
                          child: Text("2026" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w600), ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("JULY" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w600), ),
                            ),
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("Expenses" , style: TextStyle(fontSize: 17 , fontWeight: FontWeight.w400 , ), ),
                            ),
                            Text("100" , style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("Income" , style: TextStyle(fontSize: 17 , fontWeight: FontWeight.w400),),
                            ),
                            Text("100" , style: TextStyle(fontSize: 20  )),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("Balance" , style: TextStyle(fontSize: 17 , fontWeight: FontWeight.w400),),
                            ),
                            Text("100", style: TextStyle(fontSize: 20 ),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),


              ],
            ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row( children: [
                      Text("Jul 8", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
                      SizedBox(width: 5),
                      Text("Wednesday", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
                       ],
                  ),
                  Row(
                    children: [
                      Text("Expenses: 113"),
                      SizedBox(width: 10),
                      Text("Income: 120"),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 2,),

            Expanded(
              child: ListView.separated(itemBuilder: (context , index) {
                final expense = expenses[index];
                return InkWell(

                  onTap: () async {
                    final result = await
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return EDIT( expense : expense);
                    }));
                    if ( result == true){
                      await getExpenses();
                    }
                  },

                  child: UiHelper.TransactionTile(
                      IconData(
                        expense["category"]["icon"],
                        fontFamily: "MaterialIcons",
                      ),
                      Colors.black,
                    expense["category"]["name"],
                    //expense["description"],
                    expense["amount"].toString(),),
                );
              },
                  separatorBuilder: (context , index ){
                  return Divider(height: 30 , thickness: 2,);
                  }, itemCount: expenses.length ),
            ),



            Container(
              color: Colors.white, height: 70,
               child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15 , top: 10),
                      child: Container(
                        child: Column(
                          children: [
                            Icon(Icons.home),
                            Text("Home"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15 , top: 10),
                      child: Container(
                        child: Column(
                          children: [
                            Icon(Icons.pie_chart),
                            Text("Charts"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                    final id = await  Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ADD();
                       }), );

                    if (id != null) {
                      await getExpenses();
                    }

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15 ),
                     child: CircleAvatar(
                       radius: 35,
                       backgroundColor: Colors.lightGreenAccent,
                       child: Icon(
                         Icons.add, color: Colors.black,
                       ),
                     ),
                    ),
                  ),

                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15 , top: 10),
                      child: Container(
                        child: Column(
                          children: [
                            Icon(Icons.description),
                            Text("Report"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15 , top: 10 , right: 15),
                      child: Container(
                        child: Column(
                          children: [
                            Icon(Icons.person),
                            Text("Profile"),
                          ],
                        ),
                      ),
                    ),
                  ),



                ],
              ),

            )


          ],
        ),
      )
      ,

    );
  }

  Future<void> getExpenses() async {
    try {
      final response = await http.get(Uri.parse("http://10.0.2.2:8080/expense"),
      );


      if (response.statusCode == 200) {

        setState(() {
          expenses = jsonDecode(response.body);
        });

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
