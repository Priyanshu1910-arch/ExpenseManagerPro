import 'package:expensemanager/3checkuser.dart';
import 'package:flutter/material.dart';
import 'package:expensemanager/1main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  double textSize = 20;

  @override
  void initState() {
    super.initState();

    // Text animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        textSize = 300;
      });
    });

    // Move to next screen
    Future.delayed(const Duration(seconds: 2), () {

      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Checkuser(),
       // builder: (context) => const MyHomePage(title: "Home"),
        ),
      );

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Colors.blue,

        child: Center(
          child: OverflowBox(
            maxWidth: double.infinity,
            maxHeight: double.infinity,

            child: AnimatedDefaultTextStyle(
              duration: const Duration(seconds: 2),

              style: TextStyle(
                fontSize: textSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),

              child: const Text('Expense Manager App'),
            ),
          ),
        ),
      ),
    );
  }


}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //  // title: const Text("Home"),
      // ),

      body:  Container(
        color: Colors.black,
        child:

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[

              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(height: 110, width: 110,
                  child: const Center(
                    child: FaIcon( FontAwesomeIcons.mapLocationDot,
                      color: Colors.white,
                      size: 45,
                    ),
                  ),


                  decoration: const BoxDecoration( color: Colors.blueGrey, shape: BoxShape.circle, ),

                ),
              ),
              
              Padding(
                padding: const EdgeInsets.only(),
                child: Text("Set a location to see your" , style: TextStyle(color: Colors.blueGrey.shade500 , fontSize: 25 , fontWeight: FontWeight.w600),),
              ),
              Padding(
                padding: const EdgeInsets.only(  ),
                child: Text("weather" , style: TextStyle(color: Colors.blueGrey.shade500 , fontSize: 25 , fontWeight: FontWeight.w600 ),),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text("Search for a city or use your current location" , style: TextStyle(color: Colors.white , fontSize: 18),),
              ),

              Column(
                children: [

                  InkWell(
                    onTap: () {
                      print("Pressed");
                    },
                    child: Container( height: 50, width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Icon(Icons.search , size: 30, ),
                          ),
                          Center(
                            child: Text( "Search for a city",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade300,
                        borderRadius: const BorderRadius.all(Radius.circular(25),
                        ),
                      ),

                    ),
                  ),

                  SizedBox(height: 20,),

                  InkWell(
                    onTap: () {
                      print("Pressed");
                    },
                    child: Container( height: 50, width: 250,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: FaIcon(
                              FontAwesomeIcons.locationDot,
                              color: Colors.white,
                              size: 22,
                            ),

                          ),
                          Center(
                            child: Text( "Use current location",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                        ],
                      ),

                      decoration: BoxDecoration(
                        color: Colors.black,

                        border: Border.all(
                          color: Colors.white,
                          width: 1.25,
                        ),

                        borderRadius: const BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),

                    ),
                  ),




                ],
              )


            ],
          ),
        ),
      )


    );
  }
}