import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensemanager/0uihelper.dart';
import 'package:expensemanager/8edit.dart';
import 'package:expensemanager/9calendar.dart';
import 'package:flutter/material.dart';
import 'package:expensemanager/7add.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expensemanager/9calendar.dart';

class MainPage extends StatefulWidget {


  const MainPage(   {super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {


  Map<String, List<dynamic>> groupedExpenses = {};

  DateTime selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    getExpenses(now.month, now.year);

  }

  List <dynamic> expenses = [];


  @override
  Widget build(BuildContext context) {

    double monthlyExpense = 0;
    double monthlyIncome = 0;

    for (var expense in expenses) {
      double amount = expense["amount"];

      if (expense["type"] == "Expense") {
        monthlyExpense += amount;
      } else if (expense["type"] == "Income") {
        monthlyIncome += amount;
      }
    }

    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 30,
        backgroundColor: Colors.grey.shade900,

        title: Text(
          "Money Tracker", style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white,),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {},
            icon: Icon(Icons.search),
            color: Colors.white),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(onPressed: () async{
              final refresh = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                 return Calendar();
               }));
               if (refresh == true) {
                 await getExpenses(selectedMonth.month, selectedMonth.year);
               }
            },
              icon: Icon(Icons.edit_calendar),
              color: Colors.white),
          ),
        ],
      ),

      body: Container( color: Colors.black,
        child: Column(
          children: [

            Container(height: 61, color: Colors.grey.shade900,

              child: Row(
              children: [
                InkWell(
                  onTap: () async{
                    final picked = await showMonthPicker(context: context ,
                    initialDate: selectedMonth,  // when the dialog opens, July 2026 is already selected.
                    firstDate: DateTime(1999),
                    lastDate: DateTime(2099));

                    if(picked != null){
                      setState(() {
                        selectedMonth = picked;
                      });

                      getExpenses(selectedMonth.month, selectedMonth.year);
                    }
                  },
                  child: SizedBox(
                    width: 90,
                    child: Column(
                      children: [
                           Padding(
                          padding: const EdgeInsets.only(right: 20, top: 3),
                          child: Text(DateFormat('yyyy').format(selectedMonth), style: TextStyle( color: Colors.grey,
                              fontSize: 20, fontWeight: FontWeight.w600),),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text( DateFormat('MMM').format(selectedMonth), style: TextStyle(color: Colors.white,
                                  fontSize: 20, fontWeight: FontWeight.w600),),
                            ),
                            Icon(Icons.keyboard_arrow_down , color: Colors.white,),
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
                      SizedBox(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("Expenses", style: TextStyle( color: Colors.grey,
                                fontSize: 17, fontWeight: FontWeight.w400,),),
                            ),
                            Text( monthlyExpense.toString() , style: TextStyle(fontSize: 20 , color: Colors.white,)),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("Income", style: TextStyle( color: Colors.grey,
                                  fontSize: 17, fontWeight: FontWeight.w400),),
                            ),
                            Text(monthlyIncome.toString(), style: TextStyle(fontSize: 20 , color: Colors.white,)),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("Balance", style: TextStyle( color: Colors.grey,
                                  fontSize: 17, fontWeight: FontWeight.w400),),
                            ),
                            Text( (monthlyIncome-monthlyExpense).toString(), style: TextStyle(fontSize: 20 , color: Colors.white,),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            ),

            Expanded(

              child: ListView.builder(
                 itemCount: groupedExpenses.length,
                 itemBuilder: (context , index ){


                   String date = groupedExpenses.keys.elementAt((index));       // Get the current date because of init state
                   List < dynamic > dayExpenses = groupedExpenses[date]!;

                   DateTime dt = DateTime.parse(date);
                   String month = DateFormat('MMM').format(dt);
                   String dateNo = DateFormat('d').format(dt);
                   String day = DateFormat('EEE').format(dt);

                   double expenseTotal = 0;
                   double incomeTotal = 0;

                   for (var expense in dayExpenses) {
                     double amount = expense["amount"];
                     if (expense["type"] == "Expense") {
                       expenseTotal += amount;
                     } else if (expense["type"] == "Income") {
                       incomeTotal += amount;
                     }
                   }

                   return Column(
                     children: [

                       Row(
                         children: [

                           Text(

                             "$month $dateNo $day",
                             style: const TextStyle(
                               color: Colors.white,
                               fontSize: 20,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                        //   SizedBox(width: 110,),
                           Spacer(),

                           Text("Expense : $expenseTotal", style: TextStyle(color: Colors.grey),),
                           SizedBox(width: 10,),
                           Text("Income : $incomeTotal", style: TextStyle(color: Colors.grey),),
                         ],
                       ),

                       ListView.separated(
                           itemCount: dayExpenses.length,
                           shrinkWrap: true,                                  // Only take as much height as your children need
                           physics: const NeverScrollableScrollPhysics(),     // Don't let this inner list scroll. Let the outer list handle all scrolling
                           itemBuilder: (context, index) {

                         final expense = dayExpenses[index];
                         return GestureDetector(

                           onTap: () async {
                             final result = await
                             Navigator.push(context, MaterialPageRoute(
                                 builder: (context) {
                                   return EDIT(expense: expense);
                                 }));
                             if (result == true) {
                              await getExpenses(selectedMonth.month, selectedMonth.year,);

                             }
                           },
                           onLongPressStart: (details) {
                             showMenu(
                               context: context,
                               position: RelativeRect.fromLTRB(
                                 details.globalPosition.dx,
                                 details.globalPosition.dy,
                                 details.globalPosition.dx,
                                 details.globalPosition.dy,
                               ),
                               items: const [
                                 PopupMenuItem(
                                   value: "edit",
                                   child: Text("Edit"),
                                 ),
                                 PopupMenuItem(
                                   value: "delete",
                                   child: Text("Delete"),
                                 ),
                               ], ).then((value) async {

                               if (value == "edit") {
                                 final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                   return EDIT(expense: expense , openSheet: true,);
                                 }));

                                 if( result == true){
                                 await  getExpenses(selectedMonth.month,
                                   selectedMonth.year,);
                                 }
                               }

                               else if (value == "delete") {
                                 await deleteExpense(expense["id"]);
                               }
                             });
                           },


                           child: UiHelper.TransactionTile(

                             IconData(
                               expense["category"]["icon"],
                               fontFamily: "MaterialIcons",
                             ),
                             Colors.yellow.shade500,
                             expense["category"]["name"],

                             //expense["description"],
                             expense["amount"].toString(),),
                         );
                       },
                           separatorBuilder: (context, index) {
                             return Divider(height: 20, thickness: 0.6,);
                           }  ),

                       Divider(height: 0.2,)

                     ],
                   );


                 }),

            ),

            const Divider(height: 2,),

            Container(
              color: Colors.grey.shade900, height: 70,
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(Icons.home , color: Colors.grey.shade300,),
                            Text("Home" ,style:  TextStyle(fontWeight:  FontWeight.w300, color: Colors.grey.shade300,)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(Icons.pie_chart ,color: Colors.grey.shade300),
                            Text("Charts" ,style:  TextStyle(fontWeight:  FontWeight.w300, color: Colors.grey.shade300,)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final id = await Navigator.push(
                        context, MaterialPageRoute(builder: (context) {
                        return ADD();
                      }),);

                      if (id != null) {
                       await getExpenses(selectedMonth.month,
                         selectedMonth.year,);

                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
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
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(Icons.description , color: Colors.grey.shade300,),
                            Text("Report"  ,style:  TextStyle(fontWeight:  FontWeight.w300, color: Colors.grey.shade300,)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 10, right: 15),
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(Icons.person , color: Colors.grey.shade300,),
                            Text("Profile" ,style:  TextStyle(fontWeight:  FontWeight.w300, color: Colors.grey.shade300,)),
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
    );
  }

  Future<void> getExpenses(int month, int year) async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final response = await http.get(
      Uri.parse(
        "http://10.0.2.2:8080/expense/monthly"
            "?firebaseUid=${user.uid}"
            "&month=$month"
            "&year=$year",
      ),
    );

    if (response.statusCode == 200) {

      setState(() {

        expenses = jsonDecode(response.body);
        groupedExpenses.clear();

        for (var expense in expenses) {

          String date = expense["date"];

          groupedExpenses.putIfAbsent(date, () => []);   // Creating date keys

          groupedExpenses[date]!.add(expense);
        }

      });

    }
  }

  Future<void> deleteExpense(int id) async {
    final response = await http.delete(
      Uri.parse(
          "http://10.0.2.2:8080/expense/$id"),
    );

    if (response.statusCode == 200) {
      await getExpenses(
        selectedMonth.month,
        selectedMonth.year,
      );

    } else {
      print("Delete Failed");
      print(response.body);
    }
  }




}
