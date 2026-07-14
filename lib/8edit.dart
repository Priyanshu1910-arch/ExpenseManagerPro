import 'package:flutter/material.dart';
import 'package:expensemanager/0uihelper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EDIT extends StatefulWidget {

  final Map < String , dynamic > expense;

  const EDIT( {required this.expense  , super.key});

  @override
  State<EDIT> createState() => _EDITState();
} 
 
class _EDITState extends State<EDIT> {

  @override
  void dispose() {
    editController.dispose();  // This controller is no longer needed. Free its resources
    descriptionController.dispose();
    editFocus.dispose();
    descriptionFocus.dispose();
    super.dispose();
    //dispose() is called automatically when your widget is removed from memory.
  }

  TextEditingController editController = TextEditingController();
  FocusNode editFocus = FocusNode();

  TextEditingController descriptionController = TextEditingController();
  FocusNode descriptionFocus = FocusNode();

  @override
  void initState() {

    editController.text = widget.expense["amount"].toString();
    descriptionController.text = widget.expense["description"] ?? "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        
        leading: TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Icon(Icons.arrow_back ,color: Colors.white,)),
        
        title: Text("Details" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),

      body:
      Column(

        children: [

           Padding(
             padding: const EdgeInsets.only(left: 20 , top: 30),
             child: Row(
               children: [
                 CircleAvatar( backgroundColor: Colors.amber , radius: 28,
                 child: Icon(
                     IconData(widget.expense["category"]["icon"] ,
                  fontFamily: "MaterialIcons",),
                   color: Colors.white,
                 ),
                 ),
                 SizedBox(width : 30,),
                 Text(widget.expense["category"]["name"] , style: TextStyle(fontSize: 30 ,color: Colors.white),)
               ],

             ),
           ),

          SizedBox(height: 30,),

          buildRow( "Type", "Expense"),
          buildRow("Amount", widget.expense["amount"].toString()),
          buildRow("Date",  widget.expense["date"]),
          buildRow("Note", widget.expense["description"]),

           Spacer(),

          Divider(height: 1, color: Colors.grey.shade700,),

          Container(
            height: 70 ,

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: (){
                  return openAmountSheet();
                  }, child: Text("Edit" , style: TextStyle( fontSize: 20),) ,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(170,45 ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      ),
                      backgroundColor: Colors.yellow ,
                    ),  ),

                  ElevatedButton(onPressed: (){
                   UiHelper.CustomAlertBox(context, "Confirm Delete?" , onPressed: () async{
                     await deleteExpense();

                   } );
                  }, child: Text("Delete" ,  style: TextStyle( fontSize: 20)) ,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(170,45 ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      ),
                      backgroundColor: Colors.yellow ,

                    ),  ),
                ],
              ),
            ),
          )


        ],
      ),


    );
  }

  Widget buildRow(dynamic title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 30),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            value?.toString() ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  void openAmountSheet(){

    final pageContext = context;

    showModalBottomSheet(context: (context) , isScrollControlled: true , builder: (context){
      Future.delayed(Duration(microseconds: 100), () {
        editFocus.requestFocus();
      });

      return Padding(
        padding: EdgeInsets.only( left: 16, right: 16, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom +20),
        child: SizedBox(
          height: 130,
          child: Column(
            children: [
              UiHelper.CustomTextField(controller: editController, hintText: "Enter Amount",
                  focusNode: editFocus,
                  keyboardType: TextInputType.numberWithOptions(),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (value){
                    if (editController.text.isEmpty) {
                      editFocus.requestFocus();
                    } else {
                      descriptionFocus.requestFocus();
                    }
                  }

              ),
              SizedBox(height: 0),
              UiHelper.CustomTextField( controller: descriptionController, hintText: "Enter Description",
                focusNode: descriptionFocus,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) async {
                   await updateExpense();

                  Navigator.pop(context);
                  Navigator.pop(pageContext, true );
                },
              ),
            ],
          ),
        ),
      );

    });
  }

  Future<int?> updateExpense() async {

    final response = await http.put(
      Uri.parse("http://10.0.2.2:8080/expense"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "id": widget.expense["id"],
        "amount": double.parse(editController.text),
        "description": descriptionController.text,
      }),
    );

    if (response.statusCode == 200) {
      print("Expense Updated");
      return widget.expense["id"];
    } else {
      print("Failed");
      print(response.body);
      return null;
    }
  }
  Future<void> deleteExpense() async {
    final response = await http.delete(
      Uri.parse(
        "http://10.0.2.2:8080/expense/${widget.expense["id"]}",
      ),
    );

    if (response.statusCode == 200) {
      print("Expense Deleted");

      Navigator.pop(context, true);
    } else {
      print("Delete Failed");
      print(response.body);
    }
  }

}
