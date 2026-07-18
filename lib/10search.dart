import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expensemanager/0uihelper.dart';
import 'package:expensemanager/8edit.dart';

class SearchDate extends StatefulWidget {
  const SearchDate({super.key});

  @override
  State<SearchDate> createState() => _SearchDateState();
}

class _SearchDateState extends State<SearchDate> {

  List<dynamic> allExpenses = [];
  List<dynamic> filteredExpenses = [];
  String query = "";

  Set<String> selectedTypes = {"All"};


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.grey.shade800,
        foregroundColor: Colors.white,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Search"), centerTitle: true,

      ),

      body: Column(
        children: [

          Container(
            color: Colors.grey.shade800,
            height: 70,

            child: Padding(
              padding: const EdgeInsets.only(bottom: 20 , top: 5, left: 10 , right: 10),
              child: TextField(



                onChanged: (value) async {
                  query = value;

                  if (allExpenses.isEmpty) {
                    await searchExpenses();
                  }
                  applyFilters();


                },

                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search , color: Colors.white,),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),),
            ),
          ),

          Expanded(
              child: Container(
                color: Colors.grey.shade900,
                child: Column(
                            children : [
                Container(
                  height: 70, color: Colors.grey.shade900,
                  child: Row( children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text("Type" , style: TextStyle(color: Colors.white , fontSize: 20,
                       fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(width: 10),
                    typeChip("All" , 40),
                    SizedBox(width: 20),
                    typeChip("Expense" , 80),
                    SizedBox(width: 10),
                    typeChip("Income" , 80),
                    SizedBox(width: 10),
                    typeChip("Transfer" , 80),



                  ],),
                ),

                Expanded(

                    child:
                ListView.separated(itemBuilder: (context,index){



                  final expense = filteredExpenses[index];

                  return GestureDetector(

                    onTap: () async {
                      final result = await
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return EDIT(expense: expense);
                          }));
                      if (result == true) {
                        await searchExpenses();
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
                            await  searchExpenses();
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
                      expense["amount"].toString(),
                    ),
                  );
                },
                    separatorBuilder:  (context, index) {
                  return const Divider();  },

                    itemCount: filteredExpenses.length))

                            ],
                          ),
              ))

        ],
      ),

    );
  }

  Widget typeChip (String text , double wid){
    return GestureDetector(
      onTap: (){
        setState(() {

          if(text == "All"){
            if(selectedTypes.contains("All")) {
              selectedTypes.clear();
            }
            else{
              selectedTypes = {"All", "Expense", "Income", "Transfer",
              };
            }
          }

          else{
            if (selectedTypes.contains(text)) {
              selectedTypes.remove(text);
            } else {
              selectedTypes.add(text);
            }
          }



          if (selectedTypes.containsAll({
            "Expense",
            "Income",
            "Transfer",
          })) {
            selectedTypes.add("All");
          } else {
            selectedTypes.remove("All");
          }

          applyFilters();


        });
      },

      child: Container(
        height: 40,  width: wid,
      decoration: BoxDecoration(
        color: selectedTypes.contains(text) ? Colors.yellow : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(30),
      ),

       child: Center(
         child: Text(text, style: TextStyle(
           color:  selectedTypes.contains(text) ? Colors.black : Colors.white,
           fontWeight: FontWeight.w600,),),
       ),

      ),

    );
  }

  Future<void> searchExpenses() async {

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final response = await http.get(
      Uri.parse(
        "http://10.0.2.2:8080/expense?firebaseUid=${user.uid}"
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        allExpenses = jsonDecode(response.body);
        filteredExpenses = List.from(allExpenses);
      });
    }
  }

  void applyFilters() {
    setState(() {
      filteredExpenses = allExpenses.where((expense) {

        bool descriptionMatch = expense["description"]
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase());

        bool typeMatch = selectedTypes.contains("All") ||
            selectedTypes.contains(expense["type"]);

        return descriptionMatch && typeMatch;

      }).toList();
    });
  }

  Future<void> deleteExpense(int id) async {
    final response = await http.delete(
      Uri.parse(
          "http://10.0.2.2:8080/expense/$id"),
    );

    if (response.statusCode == 200) {
      await searchExpenses();

    }
  }

}
