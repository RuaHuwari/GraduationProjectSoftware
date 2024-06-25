import 'package:flutter/material.dart';
import 'package:graduationproject/screens/paying/applepay.dart';
import 'package:graduationproject/screens/paying/paypal.dart';
import 'package:graduationproject/screens/paying/visa.dart';
import 'package:graduationproject/widgets/bottomnavigation.dart';
import 'package:graduationproject/widgets/BuildButton.dart';
class pay extends StatelessWidget {
  pay({ required this.userId, required this.firstname, required this.lastname, required this.price, required this.applicationID});
  final String applicationID;
  final int price;
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
    Padding(
    padding: EdgeInsets.only(top:20,right:5),
    child:ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  Paypal(price:price.toString(), applicationID: applicationID, firstname: firstname, userId: userId, lastname: lastname,)),
      );

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
    image: AssetImage('assets/paypal.png'),
    height: 40,
    ),
    Text(
      "Pay with PayPal",
    style: TextStyle(
    color: Color.fromRGBO(100, 19, 189, 1),
    fontSize: 15,
    ),
    ),
    ],
    ),
    ),
    ),
                        Padding(
                          padding: EdgeInsets.only(top:20,right:5),
                          child:ElevatedButton(
                            onPressed: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  GooglePayScreen()),
                              );
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
                                  image: AssetImage('assets/apple-pay.png'),
                                  height: 40,
                                ),
                                Text(
                                  "Pay with Apple Pay",
                                  style: TextStyle(
                                    color: Color.fromRGBO(100, 19, 189, 1),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:20,right:5),
                          child:ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  visa(price:price, applicationID: applicationID, userId: userId,firstname:firstname,lastname:lastname)),
                              );

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
                                  image: AssetImage('assets/card.png'),
                                  height: 40,
                                ),
                                Text(
                                  "Pay with Credit Card",
                                  style: TextStyle(
                                    color: Color.fromRGBO(100, 19, 189, 1),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
