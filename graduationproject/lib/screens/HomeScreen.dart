import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graduationproject/screens/profile/profile.dart';
import 'package:graduationproject/widgets/buildbutton.dart';
import 'package:graduationproject/widgets/List.dart';
class homescreen extends StatefulWidget {
  homescreen({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Hi'+ widget.firstname +'!', style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent, // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [
            //     Color.fromRGBO(255, 155, 210, 1),
            //     Color.fromRGBO(100, 19, 189, 1),], // Define your gradient colors
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            color:Colors.purple
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_3_rounded,color: Colors.white,size: 35,),
            onPressed: () {

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.userId, firstname:widget.firstname, lastname: widget.lastname,)));
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              //  color: Color.fromRGBO(100, 19, 189, 1),
              // gradient: LinearGradient(
              //   colors: [
              //     Color.fromRGBO(255, 155, 210, 1),
              //
              //     Color.fromRGBO(100, 19, 189, 1),
              //   ],
              // ),
              color:Colors.purple
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:40.0),

            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 0),
              padding: const EdgeInsets.only(right: 5,left:8),
              height: 300,
              child: ListView(
                // This next line does the trick.
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  List.buildList(context,  "Welcome to PalEase, where convenience meets accessibility in the realm of public services.Step into a world where essential tasks are streamlined, and your needs are prioritized. Whether it's enrolling in schools, managing official documents, or exploring educational avenues.", 'assets/welcomeicon.png'),
                  List.buildList(context, "Welcome to PalEase, your gateway to educational excellence. Explore schools, universities, and course materials effortlessly. Empower your academic journey with ease.", 'assets/book.png'),
                  List.buildList(context, "With PalEase, You can now easily access, organize, and share your essential documents from anywhere. With our user-friendly interface, managing IDs, certificates, and permits is effortless. Experience document management in the palm of your hand.", 'assets/passport.png'),
                  List.buildList(context, "Effortlessly keep track of your applied applications with our intuitive interface. Welcome to PalEase, where monitoring your application statuses and managing your submissions is a breeze. From job applications to permit requests, stay organized and informed every step of the way.", 'assets/application.png'),
                  //List.buildList(context, text, img),

                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:320.0,left: 20,right: 20,bottom: 50),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildButton.buildbutton(context, 'services', 'Services', 'assets/migration.png',widget.userId,widget.firstname,widget.lastname),
                  buildButton.buildbutton(context,'applications', 'Applications','assets/application.png',widget.userId,widget.firstname,widget.lastname),
                  buildButton.buildbutton(context, 'inbox','Inbox','assets/inbox.png',widget.userId,widget.firstname,widget.lastname),
                  buildButton.buildbutton(context, 'Notification','Notifications','assets/notification.png',widget.userId,widget.firstname,widget.lastname),


                ],
              ),



            ),
          ),

        ],
      ),
    );
  }
}