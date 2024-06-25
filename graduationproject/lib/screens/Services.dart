import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/widgets/bottomnavigation.dart';
import 'package:graduationproject/widgets/buildbutton.dart';
class services extends StatefulWidget{
  services({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  State<services> createState() => _servicesState();
}

class _servicesState extends State<services> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Search Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Profile Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Services', style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent, // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
           color:Colors.purple
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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
            color:Colors.purple
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 22),
              child: Text(
                'How can we help you?',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 130, 25, 50),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                                buildButton.buildbutton(context,'id', 'IDs','assets/id-card.png',widget.userId,widget.firstname,widget.lastname),
                                buildButton.buildbutton(context,'specialneeds', 'Special Needs','assets/wheelchair.png',widget.userId,widget.firstname,widget.lastname),
                                buildButton.buildbutton(context,'driving', 'Driving License','assets/driving-license.png',widget.userId,widget.firstname,widget.lastname),
                                buildButton.buildbutton(context,'passport', 'Passports','assets/passport.png',widget.userId,widget.firstname,widget.lastname),
                                buildButton.buildbutton(context,'education', 'Education','assets/diploma.png',widget.userId,widget.firstname,widget.lastname),




                    ],
                  ),
                ),
              ],
            ),
          ),
          navigator.buildNavigator(context,widget.userId,widget.firstname,widget.lastname),
        ],
      ),

    );
  }
}