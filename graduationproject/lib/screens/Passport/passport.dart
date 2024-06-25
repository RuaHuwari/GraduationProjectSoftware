import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/widgets/bottomnavigation.dart';
import 'package:graduationproject/widgets/BuildButton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class Passport extends StatefulWidget {
  Passport({ required this.userId, required this.firstname, required this.lastname});
final String userId;
final String firstname;
final String lastname;
  @override
  _PassportState createState() => _PassportState();
}

class _PassportState extends State<Passport> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Passport Services', style: TextStyle(
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
        actions: [
          IconButton(
            icon: Icon(Icons.notification_add,color: Colors.white,size: 35,),
            onPressed: () {
              // Add your notification button onPressed logic here
              // For example, navigate to a notifications page
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
            },
          ),
        ],
      ),
      body:Stack(

        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 155, 210, 1),
                  Color.fromRGBO(100, 19, 189, 1),
                ],
              ),
            ),

            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 22),
              child:Text('What would you like to do?',style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),),
            ),
          ),
          Padding(padding: const EdgeInsets.only(top:0,left:30,right: 30,bottom: 100),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButton.buildbutton(context, 'newPassport', 'Get New Passport', 'assets/document.png',widget.userId,widget.firstname,widget.lastname),
                buildButton.buildbutton(context, 'renewPassport', 'Renew Passport', 'assets/renewal.png',widget.userId,widget.firstname,widget.lastname),
                buildButton.buildbutton(context, 'lostPassport', 'Lost Passport', 'assets/data-loss.png',widget.userId,widget.firstname,widget.lastname)

              ],
            ),
          ),
          navigator.buildNavigator(context,widget.userId,widget.firstname,widget.lastname)
        ],

      ),
    );
  }
}