import 'package:flutter/material.dart';
import 'package:expensemanager/6mainpage.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:expensemanager/7add.dart';
import '9.1dateedit.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  List <dynamic> expenses = [];
  Map<DateTime, Map<String, double>> dailyTotals = {};
  
  DateTime dateTime = DateTime.now();
  DateTime? selectedDay;


  @override
  void initState() {
    super.initState();
    getExpenses(dateTime.month, dateTime.year);
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

        title: Text("Calendar" ), centerTitle: true,
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,

        actions: [
          InkWell(
            child: Row(
              children: [
                Text(DateFormat('MMM').format(dateTime) , style: TextStyle(fontSize: 20),),
                SizedBox(width: 5,),
                Text(DateFormat('yyyy').format(dateTime) ,  style: TextStyle(fontSize: 20)),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
            onTap: () async{

              final picked = await showMonthPicker(context: context,
                initialDate: dateTime,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (!mounted) return;
              if (picked != null) {
                setState(() {
                  dateTime = picked;
                });
                await getExpenses( picked.month, picked.year,);
              }
            },
          )
        ],
      ),

      body:
      Container(
        color: Colors.black,

        child: TableCalendar(
          rowHeight: 80,

          firstDay: DateTime(2000),
          lastDay: DateTime(2100),
          focusedDay: dateTime,
          headerVisible: false,
          calendarFormat: CalendarFormat.month,

          calendarStyle: const CalendarStyle(
            outsideDaysVisible: false,
          ),

          onDaySelected: (selectedDay, focusDay) async {
            final result = await Navigator.push(context, MaterialPageRoute(builder: (context){
              return DateEdit(selectedDate: selectedDay,);
            }));

            if (result == true) {
              await getExpenses(dateTime.month, dateTime.year);
            }

          },

          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              return buildDay(day );
            },
            todayBuilder: (context, day, focusedDay) {
              return buildDay(day );
            },
            selectedBuilder: (context, day, focusedDay) {
              return buildDay(day );
            },


          ),

        ),
      ),

      floatingActionButton:
      FloatingActionButton(onPressed: () async{

        final id = await Navigator.push(
          context, MaterialPageRoute(builder: (context) {
          return ADD();
        }),);

        if (id != null) {
          await getExpenses(dateTime.month, dateTime.year,);
        }

      } ,
      backgroundColor: Colors.yellow,
        child: Icon(Icons.add ),
      ),

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



        dailyTotals.clear();

        for ( var expense in expenses ){
          DateTime date = DateTime.parse(expense["date"]);
          date = DateTime(date.year , date.month , date.day);

          dailyTotals.putIfAbsent(date, () => {
            "income": 0,
            "expense": 0,
          });
          if (expense["type"] == "Income") {
            dailyTotals[date]!["income"] =
                dailyTotals[date]!["income"]! + expense["amount"];
          } else {
            dailyTotals[date]!["expense"] =
                dailyTotals[date]!["expense"]! + expense["amount"];
          }

        }

      /*  groupedExpenses.clear();

        for (var expense in expenses) {

          String date = expense["date"];

          groupedExpenses.putIfAbsent(date, () => []);   // Creating date keys

          groupedExpenses[date]!.add(expense);
        }  */

      });

    }
  }

  Widget buildDay(DateTime day) {
    final currDay =
    dailyTotals[DateTime(day.year, day.month, day.day)];

    double income = currDay?["income"] ?? 0;
    double expense = currDay?["expense"] ?? 0;

    Color bgColor = Colors.grey.shade900;
    if (currDay != null) {
      bgColor = Colors.grey.shade800;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day.day.toString(),
            style: const TextStyle(color: Colors.white),
          ),

          Text(
            income == 0 ? "" : income.toStringAsFixed(0),
            style: const TextStyle(
              color: Colors.green,
              fontSize: 10,
            ),
          ),

          Text(
            expense == 0 ? "" : expense.toStringAsFixed(0),
            style: const TextStyle(
              color: Colors.red,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }




}
