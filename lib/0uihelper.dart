import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class UiHelper {

  static CustomTextField (  TextEditingController controller , String text , IconData iconData , bool toHide ){

    return Padding(padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
     child: TextField(
       controller: controller,
       obscureText: toHide,

       decoration: InputDecoration(
         hintText: text , suffixIcon: Icon (iconData) , border: OutlineInputBorder(borderRadius:  BorderRadius.circular(25) ) ),
     ),
    );
  }

  static CustomButton( VoidCallback voidCallBack, String text, ) {
    return ElevatedButton( onPressed: voidCallBack,
      style: ElevatedButton.styleFrom( backgroundColor: Colors.blue,  foregroundColor: Colors.white, fixedSize: const Size(200, 50), ),
      child: Text(text),
    );
  }

  static CustomAlertBox ( BuildContext context  , String text) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(title: Text(text),
        actions: [ TextButton(onPressed: () {
          Navigator.pop(context);
        },
            child: Text("OK"))
        ],
      );
    });
  }

 static Future<String?> chooseCurrency ( BuildContext context , String selectedCurrency ) async {
    String tempCurrency = selectedCurrency;
    return await showDialog(context: context, builder: (context) {
      return StatefulBuilder(builder:  (context , internalBuilder ){
        return AlertDialog(

          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text("Cancel")),
            TextButton(onPressed: (){
              Navigator.pop(context , tempCurrency);
            }, child: const Text("OK")),
          ],

          title: const Text("Choose your currency"),
          content: SizedBox(
            height: 300, width: double.maxFinite,

            child: ListView(
              children: [

                RadioGroup(
                groupValue: tempCurrency,
                    onChanged: (String? value) {
                  internalBuilder((){
                    tempCurrency = value!;
                  });

                },
                    child: Column(
                  children: const[
                    RadioListTile(value: "INR" , title: Text("INR - Indian Rupee"),),
                    RadioListTile(value: "USD" , title: Text("USD - US Dollar"),),
                    RadioListTile(value: "EUR" , title: Text("EUR - Euro"),),
                  ],
                )


                )

              ],
            ),
          ),
        );
      });

    });


 }

 static Widget TransactionTile ( IconData iconData , Color iconColor , String title , String amount  ){

    return ListTile(

      leading: CircleAvatar(
          child: Icon(iconData , color: Colors.white,),
            backgroundColor: iconColor
      ),

      title: Text(title),

      trailing: Text(amount , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),),

    );


 }




}


















