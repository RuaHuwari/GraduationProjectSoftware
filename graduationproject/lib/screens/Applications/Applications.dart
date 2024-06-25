import 'package:flutter/material.dart';
import 'package:graduationproject/widgets/bottomnavigation.dart';
import 'package:graduationproject/widgets/buildbutton.dart';
class applications extends StatelessWidget {
  applications({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Applications', style: TextStyle(
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
      body: Stack(

        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
             color: Colors.purple
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 150, 25, 50),
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
                        buildButton.buildbutton(context, 'all', "All Applications", 'assets/application.png',userId,firstname,lastname),
                        buildButton.buildbutton(context, 'rejected', "Rejected Applications", 'assets/rejected.png',userId,firstname,lastname),
                        buildButton.buildbutton(context, 'finished', "Finished Applications", 'assets/list.png',userId,firstname,lastname),
                        buildButton.buildbutton(context, 'notdone', "In-progress Applications", 'assets/progress.png',userId,firstname,lastname),

                      ],
                    )
                ),
              ],
            ),
          ),
          navigator.buildNavigator(context,userId,firstname,lastname)
        ],
      ),
    );
  }
}
