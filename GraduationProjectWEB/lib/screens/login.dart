import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/admin/dashboardscreen.dart';
import 'package:graduationprojectweb/screens/signup.dart';
import 'package:graduationprojectweb/screens/user/HomeScreen.dart';
import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;
class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late MySqlConnection _connection;
  @override
  void initState() {
    super.initState();
  }
  Future<void> _signIn(String id, String password) async {
    try {
      print(id);
      print(password);
      String uri = "http://$IP/palease_api/login.php";
      var response = await http.post(
        Uri.parse(uri),
        body: {
          "id": id,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        // Parse the response JSON
        var responseData = jsonDecode(response.body);
        if (responseData["success"]) {

          bool isAdmin = responseData["is_admin"];
          String id=responseData['user_id'];
          String firstname=responseData['firstname'];
          String lastname=responseData['lastname'];
          if (isAdmin) {
            // User is an admin, navigate to admin dashboard screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen( userId:id , firstname: firstname, lastname: lastname,)),
            );
          } else {
            // User is not an admin, navigate to home screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => homescreen(userId:id,firstname:firstname,lastname:lastname, isEnglish: true,)),
            );
          }
        } else {
          // User authentication failed
          print("Sign-in failed: ${responseData["error"]}");
        }
      } else {
        // Handle HTTP error
        print("HTTP error: ${response.statusCode}");
      }
    } catch (e) {
      print('Failed to sign in: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Secondary.withOpacity(0.3), primary.withOpacity(0.3)],
          ),
        ),
        child: Center(
          child: Container(
            width: 700,
            height: 600,
            decoration: BoxDecoration(
              color: Colors.purple,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  blurRadius: 24,
                ),
              ],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16),bottomLeft: Radius.circular(16)),
                    ),
                    width: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:80,bottom: 50),
                          child: Image(image: AssetImage("assets/LogoP.png"),height: 100,),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 50, // Adjust the height according to your design
                                child: TextField(
                                  controller: _idController,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.person, color: Colors.purple),
                                    hintText: 'ID',
                                    hintStyle: TextStyle(color: Colors.purple),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(209, 209, 212, 1)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(106, 103, 158, 1)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.lock, color: Colors.purple),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(color: Colors.purple),
                                  border: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(209, 209, 212, 1))),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(106, 103, 158, 1))),
                                ),
                              ),
                              SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: () {
                                  _signIn(_idController.text, _passwordController.text);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:Colors.purple,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Log In Now',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.chevron_right, color: Colors.white),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 50,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Welcome to Palease!",style: TextStyle(color: Colors.white, fontSize: 30),),
                    SizedBox(height:40),
                    Text("don't have an account?",style: TextStyle(color: Colors.white, fontSize: 20),),
                    SizedBox(height:20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sign UP Now',
                            style: TextStyle(color: Color.fromRGBO(76, 72, 157, 1)),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.chevron_right, color: Color.fromRGBO(120, 117, 181, 1)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
