import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:expensemanager/0uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expensemanager/6mainpage.dart';



class ADD extends StatefulWidget {
  const ADD({super.key});


  @override
  State<ADD> createState() => _ADDState();
}

class _ADDState extends State<ADD> {


  @override
  void dispose() {
    amountController.dispose();  // This controller is no longer needed. Free its resources
    descriptionController.dispose();
    amountFocus.dispose();
    descriptionFocus.dispose();
    super.dispose();
    //dispose() is called automatically when your widget is removed from memory.
  }

  final List<IconData> icons = [
    Icons.shopping_basket,
    Icons.restaurant,
    Icons.directions_car,
    Icons.home,
    Icons.flight,
    Icons.school,
    Icons.local_hospital,
    Icons.movie,
    Icons.pets,
    Icons.phone_android,
    Icons.sports_soccer,
    Icons.card_giftcard,
  ];
  final List<String> names = [
    "Shopping",
    "Food",
    "Car",
    "Home",
    "Travel",
    "Education",
    "Health",
    "Movies",
    "Pets",
    "Phone",
    "Sports",
    "Gifts",
  ];

  TextEditingController amountController = TextEditingController();
  FocusNode amountFocus = FocusNode();

  TextEditingController descriptionController = TextEditingController();
  FocusNode descriptionFocus = FocusNode();

  int selected = -1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        backgroundColor: Colors.grey.shade700,

        leading: TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Icon(Icons.arrow_back , color: Colors.white,)),

        title: Text("Add" , style: TextStyle(color: Colors.white),), centerTitle: true,

        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.playlist_add_check , color: Colors.white,))
        ],

      ),

      body: Column(
        mainAxisSize: MainAxisSize.min,
       children: [
         Container(
           color: Colors.grey.shade700, height: 50, width: double.maxFinite,
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 25 , vertical: 9),
             child: Container(
               decoration: BoxDecoration(
               color: Colors.white,
               borderRadius : BorderRadius.all(Radius.circular(8)),
             ),


             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [

                 InkWell(
                   onTap: (){},
                   child: Container(
                     child: Padding(
                       padding: const EdgeInsets.only(left: 20 ),
                       child: Text("Expense" , style: TextStyle(fontSize: 17),),
                     ),
                   ),
                 ),
                 InkWell(
                   onTap: (){},
                   child: Container(

                     child: Padding(
                       padding: const EdgeInsets.only(left: 20 ),
                       child: Text("Income"  , style: TextStyle(fontSize: 17)),
                     ),
                   ),
                 ),

                 InkWell(
                   onTap: (){},
                   child: Container(

                     child: Padding(
                       padding: const EdgeInsets.only(left: 20 , right: 20),
                       child: Text("Transfer"  , style: TextStyle(fontSize: 17)),
                     ),
                   ),
                 ),

               ]



             ),


             ),
           ),
         ),

         Expanded(
             child: Container(
           color: Colors.grey.shade800,

           child: Padding(
             padding: const EdgeInsets.only(top: 10),
             child: GridView.builder(
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 4 , crossAxisSpacing: 20 , mainAxisSpacing: 20,
                   mainAxisExtent: 120,
                   ),
                 itemCount: icons.length ,
                 itemBuilder: (context ,index) {

                   return GestureDetector(
                     onTap: (){
                       setState(() {
                         if (selected == index) {
                           selected = -1;
                         } else {
                           selected = index;
                         }

                        openAmountSheet();

                       });


                     },
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         CircleAvatar(
                           backgroundColor: selected == index? Colors.yellow : Colors.grey.shade700,
                           radius: 25,

                           child: Icon( icons[index] ,
                               color: selected == index? Colors.black : Colors.grey.shade300),
                         ),
                         const SizedBox(height: 5),
                         Text(names[index] , style: TextStyle(color: Colors.white),) ,
                       ],
                     ),

                   );
                 }),

           ),

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
       amountFocus.requestFocus();
     });

     return Padding(
       padding: EdgeInsets.only( left: 16, right: 16, top: 20,
       bottom: MediaQuery.of(context).viewInsets.bottom +20),
       child: SizedBox(
         height: 130,
         child: Column(
           children: [
             UiHelper.CustomTextField(controller: amountController, hintText: "Enter Amount" ,
             focusNode: amountFocus,
               keyboardType: TextInputType.numberWithOptions(),
               textInputAction: TextInputAction.next,
               onSubmitted: (value){
                 if (amountController.text.isEmpty) {
                   amountFocus.requestFocus();
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
                 int? id = await saveExpense(value);

                 Navigator.pop(context);
                 Navigator.pop(pageContext, id);
               },
             ),
           ],
         ),
       ),
     );

   });
  }


  Future<int?> saveExpense(String amount) async{

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user is logged in");
      return null;
    }
    String uid = user.uid;

    final response = await http.post(

        Uri.parse("http://10.0.2.2:8080/expense"),

       headers: {"Content-Type" : "application/json", },

       body: jsonEncode(

          {
            "user": {
              "firebaseUid": uid
            },

            "category": {
              "name": names[selected],
              "icon": icons[selected].codePoint
            },
         "description" : descriptionController.text,
         "amount" : double.parse(amountController.text),

         "date": DateTime.now().toIso8601String().split("T")[0],


    }
    )

    );

    if (response.statusCode == 200 || response.statusCode == 201) {
    final data = jsonDecode(response.body);
    return data["id"];
    }
    print(response.body);
    return null;
  }




}
