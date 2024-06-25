import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/infocard.dart';


// our data
const url = "meshivanshsingh.me";
const email = "me.shivansh007@gmail.com";
const phone = "90441539202"; // not real number :)
const location = "Lucknow, India";

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('My Account', style: TextStyle(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSerif'
          ),),
          backgroundColor: Colors.transparent, // Make the app bar transparent
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 155, 210, 1),
                  Color.fromRGBO(100, 19, 189, 1),], // Define your gradient colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit,color: Colors.white,size: 35,),
              onPressed: () {
                // Add your notification button onPressed logic here
                // For example, navigate to a notifications page
                //   Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
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
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 155, 210, 1),
                    Color.fromRGBO(100, 19, 189, 1),
                  ],
                ),
              ),

            ),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: ListView(
                children:[
                  Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 70,
                     // backgroundImage: AssetImage('assets/avatar.jpg'),
                    ),
                    Text(
                      "User Name",
                      style: TextStyle(
                        fontSize: 40.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Pacifico",
                      ),
                    ),
                    Text(
                      "User Role",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white38,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: "SansSerif"),
                    ),
                    SizedBox(
                      height: 20,
                      width: 200,
                      child: Divider(
                        color: Colors.white,
                      ),
                    ),

                    // we will be creating a new widget name info carrd
                    InfoCard(text: phone, icon: Icons.phone, onPressed: () async {}),
                    InfoCard(text: url, icon: Icons.web, onPressed: () async {}),
                    InfoCard(
                        text: location,
                        icon: Icons.location_city,
                        onPressed: () async {}),
                    InfoCard(text: email, icon: Icons.email, onPressed: () async {}),
                    InfoCard(text: '2001/11/11', icon: Icons.date_range_outlined, onPressed: () async {}),
                  ],
                ),
    ],
              ),
            ),
          ],
        ));
  }
}