import 'package:flutter/material.dart';


import 'package:graduationproject/screens/login.dart';
import 'package:graduationproject/screens/signup.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            // gradient: LinearGradient(
            //     colors: [
            //       Color.fromRGBO(255, 155, 210, 1),
            //
            //       Color.fromRGBO(100, 19, 189, 1),
            //
            //       //Colors.purpleAccent,
            //     ]
            // )
          color: Colors.white
        ),
        child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 200.0),
                child: Image(image: AssetImage('assets/Logo.png'),
                height: 250.0,
              //  color: Colors.white,
                  ),

              ),
              const SizedBox(
                height: 100,
              ),

              const SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const loginScreen()));
                },
                child: Container(
                  height: 53,
                  width: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color:   Color.fromRGBO(100, 19, 189,1),),
                  ),
                  child: const Center(child: Text('SIGN IN',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple
                  ),),),
                ),
              ),
              const SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const RegScreen()));
                },
                child: Container(
                  height: 53,
                  width: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // Same border radius as the button
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(255, 155, 210,1),
                        Color.fromRGBO(100, 19, 189,1),
                      ],
                    ),
                  ),
                  child: const Center(child: Text('SIGN UP',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),),
                ),
              ),
              const Spacer(),

            ]
        ),
      ),

    );
  }
}
