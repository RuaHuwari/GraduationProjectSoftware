import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/screens/user/Orphanages/orphanages.dart';
import 'package:graduationprojectweb/screens/user/chat/chatting.dart';
import 'package:graduationprojectweb/screens/user/Application/Application.dart';
import 'package:graduationprojectweb/screens/user/Application/ShowApplications.dart';
import 'package:graduationprojectweb/screens/user/Driving/driving.dart';
import 'package:graduationprojectweb/screens/user/Driving/newlicense.dart';
import 'package:graduationprojectweb/screens/user/Education/schools.dart';
import 'package:graduationprojectweb/screens/user/Education/universities.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/HealthCare.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/blindness.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/chronic.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/deafness.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/development.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/intellictual.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/learning.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/mental.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/physical.dart';
import 'package:graduationprojectweb/screens/user/ID/LostID.dart';
import 'package:graduationprojectweb/screens/user/ID/NewID.dart';
import 'package:graduationprojectweb/screens/user/ID/renewID.dart';
import 'package:graduationprojectweb/screens/user/ID/ID.dart';
import 'package:graduationprojectweb/screens/user/Passport/LostPassport.dart';
import 'package:graduationprojectweb/screens/user/Passport/NewPassport.dart';
import 'package:graduationprojectweb/screens/user/Passport/RenewPassport.dart';
import 'package:graduationprojectweb/screens/user/Passport/passport.dart';
import 'package:graduationprojectweb/screens/user/Services.dart';

import '../screens/user/Education/Education.dart';

class buildButton  {
  static Padding buildbutton(BuildContext context,String str, String text, String img, String userId, String firstname, String lastname,bool isEnglish) {
    return  Padding(
      padding: EdgeInsets.only(top:20,right:5),
      child:ElevatedButton(
        onPressed: () {
          switch (str){
            case 'newlicense':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Newlicense(userId: userId,firstname: firstname,lastname: lastname, isEnglish: isEnglish,)),
              );
              break;

            case 'school':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Schools(userId: userId,firstname: firstname,lastname: lastname,isEnglish:isEnglish)),
              );
              break;
            case 'university':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Universities(userId: userId,firstname: firstname,lastname: lastname, isEnglish: isEnglish,)),
              );
              break;
            case 'id':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ID(userId: userId,firstname: firstname,lastname: lastname,isEnglish:isEnglish)),
              );
              break;
            case 'applications':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => applications(userId: userId,firstname: firstname,lastname: lastname, isEnglish: isEnglish,)),
              );
              break;
            case 'education':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Education(userId: userId,firstname: firstname,lastname: lastname, isEnglish: isEnglish,)),
              );
              break;
            case 'services':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  services(userId: userId,firstname: firstname,lastname: lastname,isEnglish:isEnglish)),
              );
              break;
            case 'passport':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Passport(userId: userId,firstname: firstname,lastname: lastname,isEnglish: isEnglish,)),
              );
              break;
            case 'newID':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  NewID(userId: userId,firstname: firstname,lastname: lastname,isEnglish:isEnglish)),
              );
              break;
            case 'lostID':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  LostID(userId: userId,firstname: firstname,lastname: lastname,isEnglish:isEnglish)),
              );
              break;
            case 'renewID':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  renewId(userId: userId,firstname: firstname,lastname: lastname,isEnglish:isEnglish)),
              );
              break;
            case 'newPassport':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  NewPassport(userId: userId,firstname: firstname,lastname: lastname,isEnglish:isEnglish)),
              );
              break;
            case 'renewPassport':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ReNewPassport(userId: userId,firstname: firstname,lastname: lastname,isEnglish:isEnglish)),
              );
              break;
            case 'lostPassport':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  LostPassport(userId: userId,firstname: firstname,lastname: lastname,isEnglish: isEnglish,)),
              );
              break;
            case 'all':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  showapplications(userId: userId,firstname: firstname,lastname: lastname, status: 'all', isEnglish: isEnglish,)),
              );
              break;
            case 'rejected':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  showapplications(userId: userId,firstname: firstname,lastname: lastname, status: 'rejected', isEnglish: isEnglish,)),
              );
              break;
            case 'notdone':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  showapplications(userId: userId,firstname: firstname,lastname: lastname, status: 'Not Done', isEnglish: isEnglish,)),
              );
              break;
            case 'finished':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  showapplications(userId: userId,firstname: firstname,lastname: lastname, status: 'accepted', isEnglish: isEnglish,)),
              );
              break;
            case 'driving':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  driving(userId: userId,firstname: firstname,lastname: lastname, isEnglish: isEnglish,)),
              );
              break;
            case 'specialneeds':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  HealthCare(userId: userId,firstname: firstname,lastname: lastname, isEnglish: isEnglish,)),
              );
              break;
            case 'blindness':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Blindness(userId: userId,firstname: firstname,lastname: lastname, isEnglish: isEnglish,)),
              );
              break;
            case 'deafness':
              Navigator.push(
                context,
                MaterialPageRoute(builder:(context)=>Deafness(userId: userId, firstname: firstname, lastname: lastname, isEnglish: isEnglish,)),
              );
              break;
            case 'physical':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>Physical(userId: userId, firstname: firstname, lastname: lastname, isEnglish: isEnglish,)),
              );
              break;
            case 'development':
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Development(userId: userId, firstname: firstname, lastname: lastname, isEnglish: isEnglish,)),
          );
          break;
            case 'learning':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>Learning(userId: userId, firstname: firstname, lastname: lastname, isEnglish: isEnglish,)),
              );
              break;
            case 'intellectual':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>Intellectual(userId: userId, firstname: firstname, lastname: lastname, isEnglish: isEnglish,)),
              );
              break;
            case 'mental':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>Mental(userId: userId, firstname: firstname, lastname: lastname, isEnglish: isEnglish,)),
              );
              break;
            case'chronic':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>Chronic(userId: userId, firstname: firstname, lastname: lastname, isEnglish: isEnglish,)),
              );
              break;
            case 'inbox':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>ChatScreen(userId: userId, firstname: firstname, lastname: lastname, isEnglish:isEnglish )),
              );
              break;
              case 'orphan':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>OrphanagesScreen(userId: userId, firstname: firstname, lastname: lastname, isEnglish: isEnglish,)),
              );
              break;
          }

        },
        style: ElevatedButton.styleFrom(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          minimumSize: Size(450, 120), // Set minimum button size
          maximumSize: Size(450,120),
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
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
