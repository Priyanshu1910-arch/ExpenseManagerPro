import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DateEdit extends StatefulWidget {

  final DateTime selectedDate;

  const DateEdit({super.key , required this.selectedDate});

  @override
  State<DateEdit> createState() => _DateEditState();
}

class _DateEditState extends State<DateEdit> {
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

              //  Text("Expense : $expenseTotal", style: TextStyle(color: Colors.grey),),
                SizedBox(width: 10,),
              //  Text("Income : $incomeTotal", style: TextStyle(color: Colors.grey),),
              ],
            ),
          ],
        ),
      ),
    );
  }



}
