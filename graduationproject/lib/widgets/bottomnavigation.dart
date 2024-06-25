import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/screens/Applications/Applications.dart';
import 'package:graduationproject/screens/HomeScreen.dart';
import 'package:graduationproject/screens/Search.dart';
import 'package:graduationproject/screens/chat/chatting.dart';


import '../screens/profile/profile.dart';


class navigator {
  static Positioned buildNavigator(BuildContext context, String userId, String firstname, String lastname) {
    return  Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Color.fromRGBO(100, 19, 189, 0.4),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen(userId: userId,firstname: firstname,lastname: lastname,)),
                );
              },
              icon: Column(
                children: [
                  Icon(Icons.move_to_inbox_rounded,
                    color: Colors.white,),
                  Text('Inbox', style:  TextStyle(
                      color: Colors.white
                  ),)
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen(userId: userId,firstname: firstname,lastname: lastname,)),
                );
              },
              icon: Column(
                children: [
                  Icon(Icons.search,
                    color: Colors.white,
                  ),
                  Text('Search', style:  TextStyle(
                      color: Colors.white
                  ),)
                ],
              ),

            ),

            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  homescreen(userId: userId,firstname: firstname,lastname: lastname,)),
                );
              },
              icon: Column(
                children: [
                  Icon(Icons.home,
                    color: Colors.white,),
                  Text('Home', style:  TextStyle(
                      color: Colors.white
                  ),)
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  applications(userId: userId,firstname: firstname,lastname: lastname,)),
                );
              },
              icon: Column(
                children: [
                  Icon(Icons.sticky_note_2_outlined,
                    color: Colors.white,),
                  Text('Applications', style:  TextStyle(
                      color: Colors.white
                  ),)
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ProfilePage(userId: userId,firstname: firstname,lastname: lastname,)),
                );
              },
              icon: Column(
                children: [
                  Icon(Icons.account_circle,
                    color: Colors.white,),
                  Text('Profile', style:  TextStyle(
                      color: Colors.white
                  ),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
