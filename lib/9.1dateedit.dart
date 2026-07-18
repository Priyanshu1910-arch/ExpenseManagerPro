import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:expensemanager/0uihelper.dart';
import 'package:expensemanager/8edit.dart';
import 'package:expensemanager/7add.dart';
import 'package:expensemanager/10search.dart';

class DateEdit extends StatefulWidget {

  final DateTime selectedDate;

  const DateEdit({super.key , required this.selectedDate});

  @override
  State<DateEdit> createState() => _DateEditState();
}

class _DateEditState extends State<DateEdit> {

  List<dynamic> dayExpenses = [];

  double incomeTotal = 0;
  double expenseTotal = 0;

  @override
  void initState() {
    super.initState();
    getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),

        title: Text(
          DateFormat("MMM dd, yyyy").format(widget.selectedDate),),
        centerTitle: true,

        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,


      ),

      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Row(
              children: [

                Text(
               DateFormat('MMM dd EEEE').format(widget.selectedDate),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                   // fontWeight: FontWeight.bold,
                  ),
                ),

                Spacer(),

               Text("Expense : $expenseTotal", style: TextStyle(color: Colors.grey),),
                SizedBox(width: 10,),
                Text("Income : $incomeTotal", style: TextStyle(color: Colors.grey),),
              ],
            ),


            Expanded(

              child : dayExpenses.isEmpty ?
              Center( child: Text( "No transactions", style: TextStyle(color: Colors.white),),)

                  :  ListView.separated(
                  itemCount: dayExpenses.length,
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
                          await getExpenses();

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
                              await  getExpenses();
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
            ),



          ],
        ),
      ),

      floatingActionButton:
      FloatingActionButton(onPressed: () async{

        final id = await Navigator.push(
          context, MaterialPageRoute(builder: (context) {
          return ADD();
        }),);

        if (id != null) {
          await getExpenses();
        }

      } ,
        backgroundColor: Colors.yellow,
        child: Icon(Icons.add ),
      ),

    );
  }






  Future<void> getExpenses() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final response = await http.get(
      Uri.parse(
        "http://10.0.2.2:8080/expense/daily"
            "?firebaseUid=${user.uid}"
            "&date=${widget.selectedDate.toIso8601String().split("T")[0]}",
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      double income = 0;
      double expense = 0;

      for (var item in data) {
        double amount = (item["amount"] as num).toDouble();

        if (item["type"] == "Income") {
          income += amount;
        } else {
          expense += amount;
        }
      }

      setState(() {
        dayExpenses = data;
        incomeTotal = income;
        expenseTotal = expense;
      });
    }
  }

  Future<void> deleteExpense(int id) async {
    final response = await http.delete(
      Uri.parse(
          "http://10.0.2.2:8080/expense/$id"),
    );

    if (response.statusCode == 200) {
      await getExpenses();

    }
  }


}
