import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/screens/Applications/Applications.dart';
import 'package:graduationproject/screens/ID_Field/LostID.dart';
import 'package:graduationproject/screens/ID_Field/NewID.dart';
import 'package:graduationproject/screens/ID_Field/renewID.dart';
import 'package:graduationproject/screens/ID_Field/IDs.dart';
import 'package:graduationproject/screens/Services.dart';
import 'package:graduationproject/screens/chat/chatting.dart';

import '../screens/Applications/ShowApplications.dart';
import '../screens/Driving/driving.dart';
import '../screens/Driving/newlicense.dart';
import '../screens/Education/Education.dart';
import '../screens/Education/schools.dart';
import '../screens/Education/universities.dart';
import '../screens/HealthCare/HealthCare.dart';
import '../screens/HealthCare/blindness.dart';
import '../screens/HealthCare/chronic.dart';
import '../screens/HealthCare/deafness.dart';
import '../screens/HealthCare/development.dart';
import '../screens/HealthCare/intellictual.dart';
import '../screens/HealthCare/learning.dart';
import '../screens/HealthCare/mental.dart';
import '../screens/HealthCare/physical.dart';
import '../screens/Passport/LostPassport.dart';
import '../screens/Passport/NewPassport.dart';
import '../screens/Passport/RenewPassport.dart';
import '../screens/Passport/passport.dart';

class buildButton  {
  static Padding buildbutton(BuildContext context,String str, String text, String img, String userId, String firstname, String lastname) {
    return  Padding(
      padding: EdgeInsets.only(top:20,right:5),
      child:ElevatedButton(
        onPressed: () {
          switch (str){
            case 'newlicense':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Newlicense(userId: userId,firstname: firstname,lastname: lastname,)),
              );
              break;
            case 'school':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Schools(userId: userId,firstname: firstname,lastname: lastname,)),
              );
              break;
            case 'university':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Universities(userId: userId,firstname: firstname,lastname: lastname,)),
              );
              break;
            case 'id':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ID(userId: userId,firstname: firstname,lastname: lastname,)),
              );
              break;
            case 'applications':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => applications(userId: userId,firstname: firstname,lastname: lastname,)),
              );
              break;
            case 'education':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Education(userId: userId,firstname: firstname,lastname: lastname,)),
              );
              break;
            case 'services':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  services(userId: userId,firstname: firstname,lastname: lastname,)),
              );
              break;
            case 'passport':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Passport(userId: userId,firstname: firstname,lastname: lastname,)),
              );
              break;
            case 'newID':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  NewID(userId: userId,firstname: firstname,lastname: lastname,)),
              );
              break;
            case 'lostID':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  LostID(userId: userId,firstname: firstname,lastname: lastname,)),
              );
              break;
            case 'renewID':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  renewId(userId: userId,firstname: firstname,lastname: lastname,)),
              );
              break;
            case 'newPassport':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  NewPassport(userId: userId,firstname: firstname,lastname: lastname,)),
              );
              break;
            case 'renewPassport':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ReNewPassport(userId: userId,firstname: firstname,lastname: lastname,)),
              );
              break;
            case 'lostPassport':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  LostPassport(userId: userId,firstname: firstname,lastname: lastname,)),
              );
              break;
            case 'all':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  showapplications(userId: userId,firstname: firstname,lastname: lastname, status: 'all',)),
              );
              break;
            case 'rejected':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  showapplications(userId: userId,firstname: firstname,lastname: lastname, status: 'rejected',)),
              );
              break;
            case 'notdone':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  showapplications(userId: userId,firstname: firstname,lastname: lastname, status: 'Not Done',)),
              );
              break;
            case 'finished':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  showapplications(userId: userId,firstname: firstname,lastname: lastname, status: 'accepted',)),
              );
              break;
            case 'driving':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  driving(userId: userId,firstname: firstname,lastname: lastname)),
              );
              break;
            case 'specialneeds':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  HealthCare(userId: userId,firstname: firstname,lastname: lastname)),
              );
              break;
            case 'blindness':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Blindness(userId: userId,firstname: firstname,lastname: lastname)),
              );
              break;
            case 'deafness':
              Navigator.push(
                context,
                MaterialPageRoute(builder:(context)=>Deafness(userId: userId, firstname: firstname, lastname: lastname)),
              );
              break;
            case 'physical':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>Physical(userId: userId, firstname: firstname, lastname: lastname)),
              );
              break;
            case 'development':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>Development(userId: userId, firstname: firstname, lastname: lastname)),
              );
              break;
            case 'learning':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>Learning(userId: userId, firstname: firstname, lastname: lastname)),
              );
              break;
            case 'intellectual':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>Intellectual(userId: userId, firstname: firstname, lastname: lastname)),
              );
              break;
            case 'mental':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>Mental(userId: userId, firstname: firstname, lastname: lastname)),
              );
              break;
            case'chronic':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>Chronic(userId: userId, firstname: firstname, lastname: lastname)),
              );
              break;
            case 'inbox':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>ChatScreen(userId: userId, firstname: firstname, lastname: lastname)),
              );
              break;


          }

        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          minimumSize: Size(150, 55), // Set minimum button size
          padding: const EdgeInsets.only(bottom: 0),
        ),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Image(
              image: AssetImage(img),
              height: 40,
            ),
            Text(
              text,
              style: TextStyle(
                color: Color.fromRGBO(100, 19, 189, 1),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
