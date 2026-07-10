import 'package:flutter/material.dart';
import 'package:expensemanager/6mainpage.dart';


class ADD extends StatefulWidget {
  const ADD({super.key});

  @override
  State<ADD> createState() => _ADDState();
}

class _ADDState extends State<ADD> {

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


         ))
       ],
      ),



    );
  }
}
