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

}


















