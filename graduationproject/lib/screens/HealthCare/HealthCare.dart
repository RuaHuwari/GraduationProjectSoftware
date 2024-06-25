import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/widgets/bottomnavigation.dart';
import 'package:graduationproject/widgets/BuildButton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class HealthCare extends StatefulWidget {
  HealthCare({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  _HealthCareState createState() => _HealthCareState();
}

class _HealthCareState extends State<HealthCare> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HealthCare Services For People With Special Needs', style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent, // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
           color: Colors.purple
          ),
        ),
      ),
      body:Stack(

        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
             color: Colors.purple
            ),

            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 22),
              child:Text('Find help for yourself and your loved ones:',style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),),
            ),
          ),
          Padding(padding: const EdgeInsets.only(top:100,left:30,right: 30,bottom:50),

            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Colors.transparent,
                  ),
                  child: Column(
                    children: [
                                 buildButton.buildbutton(context, 'blindness', 'Blindness', 'assets/eyes.png',widget.userId,widget.firstname,widget.lastname),
                    buildButton.buildbutton(context, 'physical', 'Physical Disability', 'assets/wheelchair.png',widget.userId,widget.firstname,widget.lastname),
                    buildButton.buildbutton(context, 'development', 'Development&Behavioral Disability', 'assets/personal-growth.png',widget.userId,widget.firstname,widget.lastname),
                    buildButton.buildbutton(context, 'learning', 'Learning&Communication Support', 'assets/communication.png',widget.userId,widget.firstname,widget.lastname),
                                buildButton.buildbutton(context, 'deafness', 'Deafness', 'assets/deafness.png',widget.userId,widget.firstname,widget.lastname),
                                buildButton.buildbutton(context, 'intellectual', 'Intellectual Disability ', 'assets/copyright.png',widget.userId,widget.firstname,widget.lastname),
                                buildButton.buildbutton(context, 'mental', 'Mental Health&Emotional health', 'assets/mentalhealt.png',widget.userId,widget.firstname,widget.lastname),
                                buildButton.buildbutton(context, 'chronic', 'Chronic Illness&Physical Health', 'assets/chronic.png',widget.userId,widget.firstname,widget.lastname)





                    ],
                  ),
                ),
              ],
            ),
          ),
          navigator.buildNavigator(context,widget.userId,widget.firstname,widget.lastname)
        ],

      ),
    );
  }
}