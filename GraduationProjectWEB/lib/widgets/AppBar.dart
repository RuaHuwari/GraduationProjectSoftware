import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/screens/home.dart';
import 'package:graduationprojectweb/screens/profile/profile.dart';
import 'package:graduationprojectweb/screens/user/Application/Application.dart';
import 'package:graduationprojectweb/screens/user/Driving/driving.dart';
import 'package:graduationprojectweb/screens/user/Education/Education.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/HealthCare.dart';
import 'package:graduationprojectweb/screens/user/HomeScreen.dart';
import 'package:graduationprojectweb/screens/user/ID/ID.dart';
import 'package:graduationprojectweb/screens/user/Orphanages/orphanages.dart';
import 'package:graduationprojectweb/screens/user/Passport/passport.dart';
import 'package:graduationprojectweb/screens/user/Search.dart';
import 'package:graduationprojectweb/screens/user/chat/chatting.dart';


class buildabbbar {
  static AppBar buildAbbbar(
      BuildContext context,
      String title,
      String userId,
      String firstname,
      String lastname,
      bool isEnglish,
      VoidCallback toggleLanguage) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 35,
          fontWeight: FontWeight.bold,
          fontFamily: 'NotoSerif',
        ),
      ),
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.purple,
        ),
      ),
      actions: [
        Row(
          children: [
            _buildTextButton(
            context,
            isEnglish ? 'Home' : 'الرئيسية',
            homescreen(
              userId: userId,
              firstname: firstname,
              lastname: lastname,
              isEnglish: isEnglish,
            ),
          ),
            _buildDropdownButton(
              context,
              isEnglish ? 'Services' : 'الخدمات',
              userId,
              firstname,
              lastname,
              isEnglish,
            ),
            _buildTextButton(
              context,
              isEnglish ? 'Inbox' : 'صندوق الوارد',
              ChatScreen(
                userId: userId,
                firstname: firstname,
                lastname: lastname,
                isEnglish: isEnglish,
              ),
            ),
            _buildTextButton(
              context,
              isEnglish ? 'Search' : 'بحث',
              SearchPage(
                userId: userId,
                firstname: firstname,
                lastname: lastname,
                isEnglish: isEnglish,
              ),
            ),

            _buildTextButton(
              context,
              isEnglish ? 'Applications' : 'طلبات',
              applications(
                userId: userId,
                firstname: firstname,
                lastname: lastname,
                isEnglish: isEnglish,
              ),
            ),
            // _buildTextButton(
            //   context,
            //   isEnglish ? 'Profile' : 'الملف الشخصي',
            //   UserProfile(
            //     userId: userId,
            //     firstname: firstname,
            //     lastname: lastname,
            //     isEnglish:isEnglish
            //   ),
            // ),
            IconButton(
              icon: Icon(Icons.person_rounded, color: Colors.white),
              onPressed: (){ Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile(
                    userId: userId,
                    firstname: firstname,
                    lastname: lastname,
                    isEnglish:isEnglish
                ),),
              );}
              ,
            ),
            IconButton(
              icon: Icon(Icons.language, color: Colors.white),
              onPressed: toggleLanguage,
            ),
            IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: (){ Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => home()),
              );}
              ,
            ),
          ],
        ),
      ],
    );
  }

  static TextButton _buildTextButton(
      BuildContext context, String label, Widget screen) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  static Widget _buildDropdownButton(
      BuildContext context,
      String label,
      String userId,
      String firstname,
      String lastname,
      bool isEnglish) {
    return DropdownButton<String>(
      underline: SizedBox(), // Remove underline
     icon: Icon(Icons.arrow_drop_down, color: Colors.white),
      dropdownColor: Colors.white,

      items: <DropdownMenuItem<String>>[
        DropdownMenuItem(
          value: 'ID',
          child: Text(
            isEnglish ? 'ID' : 'الهوية',
            style: TextStyle(color: Colors.purple),
          ),
        ),
        DropdownMenuItem(
          value: 'Passport',
          child: Text(
            isEnglish ? 'Passport' : 'جواز السفر',
            style: TextStyle(color: Colors.purple),
          ),
        ),
        DropdownMenuItem(
          value: 'Driving',
          child: Text(
            isEnglish ? 'Driving License' : 'رخصة القيادة',
            style: TextStyle(color: Colors.purple),
          ),
        ),
        DropdownMenuItem(
          value: 'Education',
          child: Text(
            isEnglish ? 'Education' : 'التعليم',
            style: TextStyle(color: Colors.purple),
          ),
        ),
        DropdownMenuItem(
          value: 'Orphanages',
          child: Text(
            isEnglish ? 'Orphanages' : 'دور الأيتام',
            style: TextStyle(color: Colors.purple),
          ),
        ),
        DropdownMenuItem(
          value: 'SpecialNeeds',
          child: Text(
            isEnglish ? 'Special Needs' : 'احتياجات خاصة',
            style: TextStyle(color: Colors.purple),
          ),
        ),
      ],
      onChanged: (String? newValue) {
        if (newValue != null) {
          Widget screen;
          switch (newValue) {
            case 'ID':
              screen = ID(
                userId: userId,
                firstname: firstname,
                lastname: lastname,
                isEnglish: isEnglish,
              );
              break;
            case 'Passport':
              screen = Passport(
                userId: userId,
                firstname: firstname,
                lastname: lastname,
                isEnglish: isEnglish,
              );
              break;
            case 'Driving':
              screen = driving(
                userId: userId,
                firstname: firstname,
                lastname: lastname,
                isEnglish: isEnglish,
              );
              break;
            case 'Education':
              screen = Education(
                userId: userId,
                firstname: firstname,
                lastname: lastname,
                isEnglish: isEnglish,
              );
              break;
            case 'Orphanages':
              screen = OrphanagesScreen(
                userId: userId,
                firstname: firstname,
                lastname: lastname,
                isEnglish: isEnglish,
              );
              break;
            case 'SpecialNeeds':
              screen = HealthCare(
                userId: userId,
                firstname: firstname,
                lastname: lastname,
                isEnglish: isEnglish,
              );
              break;
            default:
              return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        }
      },
      hint: Padding(
        padding: const EdgeInsets.only(right: 0.0), // Adjust this value as needed
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

}

