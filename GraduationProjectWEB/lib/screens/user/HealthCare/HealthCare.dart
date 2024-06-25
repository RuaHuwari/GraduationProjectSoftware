import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:graduationprojectweb/widgets/BuildButton.dart';

class HealthCare extends StatefulWidget {
  HealthCare({ required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;
  @override
  _HealthCareState createState() => _HealthCareState();
}

class _HealthCareState extends State<HealthCare> {
  bool isEnglish = true;

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEnglish=widget.isEnglish;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(context, isEnglish?'Special Needs':'ذوي الاحتياجات الخاصة', widget.userId, widget.firstname, widget.lastname,isEnglish,_toggleLanguage),
      body:Stack(

        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
             color: Colors.white
            ),

            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 22),
              child:Text(isEnglish?'Find help for yourself and your loved ones:':'أحصل على المساعدة من أجل ومن أجل أحبائك',style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),),
            ),
          ),
          Padding(padding: const EdgeInsets.only(top:60,left:30,right: 30,bottom:50),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton.buildbutton(context, 'blindness', isEnglish?'Blindness':'فقدان البصر', 'assets/eyes.png',widget.userId,widget.firstname,widget.lastname,isEnglish),
                    buildButton.buildbutton(context, 'physical', isEnglish?'Physical Disability':'اعاقة جسدية', 'assets/wheelchair.png',widget.userId,widget.firstname,widget.lastname,isEnglish),
                    buildButton.buildbutton(context, 'development', isEnglish?'Development&Behavioral Disability':'اعاقة بالتطور والتصرف', 'assets/personal-growth.png',widget.userId,widget.firstname,widget.lastname,isEnglish),
                    buildButton.buildbutton(context, 'learning', isEnglish?'Learning&Communication Support':'دعم للتعليم والتواصل', 'assets/communication.png',widget.userId,widget.firstname,widget.lastname,isEnglish)

                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton.buildbutton(context, 'deafness', isEnglish?'Deafness':'فقدان السمع', 'assets/deafness.png',widget.userId,widget.firstname,widget.lastname,isEnglish),
                    buildButton.buildbutton(context, 'intellectual', isEnglish?'Intellectual Disability ':'الإعاقة الفكرية', 'assets/copyright.png',widget.userId,widget.firstname,widget.lastname,isEnglish),
                    buildButton.buildbutton(context, 'mental', isEnglish?'Mental Health&Emotional health':'الصحة النفسية والصحة العاطفية', 'assets/mentalhealt.png',widget.userId,widget.firstname,widget.lastname,isEnglish),
                    buildButton.buildbutton(context, 'chronic', isEnglish?'Chronic Illness&Physical Health':'الأمراض المزمنة والصحة الجسدية', 'assets/chronic.png',widget.userId,widget.firstname,widget.lastname,isEnglish)

                  ],
                )
              ],
            ),
          ),
        ],

      ),
    );
  }
}