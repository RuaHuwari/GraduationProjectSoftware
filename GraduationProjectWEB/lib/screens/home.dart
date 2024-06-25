import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/login.dart';
import 'package:graduationprojectweb/screens/signup.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:graduationprojectweb/widgets/footer.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  //setting the expansion function for the navigation rail
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Image(
                image: AssetImage('assets/Logo.png'),
                height: 100,
                width: 100,
              ),
              SizedBox(width: 10), // Add some spacing between logo and buttons
              Expanded(child: Container()), // This will push buttons to the right corner
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const loginScreen()),
                    );
                  },
                  child: Text(
                    'Sign In',
                    style: (TextStyle(color: Colors.deepPurple)),
                  ),
                ),
              ),
              SizedBox(width: 10), // Add some spacing between buttons
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegScreen()),
                    );
                  },
                  child: Text('Sign Up'),
                ),
              ),
              SizedBox(width: 10), // Add some spacing between buttons
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListView(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 50,),
                          Center(
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  colors: [Secondary, primary],
                                  tileMode: TileMode.decal,
                                ).createShader(bounds);
                              },
                              child: Text(
                                'Welcome to PalEase!',
                                style: TextStyle(
                                  fontSize: 70,
                                  fontFamily: 'Pacifico',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Text('', style: TextStyle(fontSize: 50)),
                          Center(
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  colors: [primary, Secondary],
                                  tileMode: TileMode.repeated,
                                ).createShader(bounds);
                              },
                              child: Center(
                                child: Text(
                                  'Get all your documents done from you home! \n Get Started now',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontFamily: 'NotoSerif',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const loginScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Get Started',
                                  style: TextStyle(color: primary, fontSize: 30),
                                ),
                                SizedBox(width: 15),
                                Icon(
                                  Icons.chevron_right,
                                  color: Secondary,
                                  size: 40,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 250),
                  Footer(child: FooterPage(isEnglish: true))
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
