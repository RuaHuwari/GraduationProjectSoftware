import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/screens/Services.dart';
import 'package:graduationproject/screens/profile/profile.dart';
import 'package:graduationproject/widgets/bottomnavigation.dart';
import 'package:graduationproject/widgets/BuildButton.dart';
class Education extends StatefulWidget{
  Education ({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  @override
  Widget build (BuildContext context){
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading:
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 35,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  services(userId: widget.userId,
                      firstname: widget.firstname,
                      lastname: widget.lastname)));
            },
          ),
          title: Text('Education', style: TextStyle(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSerif'
          ),),
          backgroundColor: Colors.transparent,
          // Make the app bar transparent
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.purple
            ),
          ),

        ),
        body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                 color: Colors.purple
                ),
              ),
              Center(
                child: Padding(padding: const EdgeInsets.only(top:0,left:30,right: 30),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildButton.buildbutton(context, 'school', 'Schools', 'assets/campus.png',widget.userId,widget.firstname,widget.lastname),
                      buildButton.buildbutton(context, 'university', 'Universities', 'assets/university.png',widget.userId,widget.firstname,widget.lastname),

                    ],
                  ),
                ),
              ),
              navigator.buildNavigator(context,widget.userId,widget.firstname,widget.lastname),
            ]

        )
    );
  }
}