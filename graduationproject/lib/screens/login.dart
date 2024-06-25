import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Constans/API.dart';
import 'package:graduationproject/screens/signup.dart';
import 'package:graduationproject/screens/HomeScreen.dart';
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
  Future <void> savetoken(String id, String token)async {
    try {
      String uri = "http://$IP/palease_api/savetoken.php";
      var response = await http.post(
        Uri.parse(uri),
        body: {
          "userid": id,
          "token": token,
        },
      );
      if (response.statusCode == 200) {
        // Parse the response JSON
        var responseData = jsonDecode(response.body);

        // Check the value of the "success" field in the response
        if (responseData["success"]) {
          print('token saved');
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
  Future<void> _signIn(String id, String password) async {
    try {
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

        // Check the value of the "success" field in the response
        if (responseData["success"]) {
          // User authentication successful
          String id=responseData['user_id'];
          String firstname=responseData['firstname'];
          String lastname=responseData['lastname'];
          FirebaseMessaging.instance.getToken().then((token) {
            print("Device Token: $token");
            savetoken(id, token!);
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => homescreen(userId:id,firstname:firstname,lastname:lastname)),
          );
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
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              // gradient: LinearGradient(
              //   colors: [
              //     Color.fromRGBO(255, 155, 210, 1),
              //     Color.fromRGBO(100, 19, 189, 1),
              //   ],
              // ),
              color:Colors.purple
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Hello\nSign in!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: ListView(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Colors.white,
                  ),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _idController,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(
                              Icons.badge,
                              color: Colors.grey,
                            ),
                            labelText: 'ID',
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(100, 19, 189, 1),
                            ),
                          ),
                        ),

                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible; // Toggle the state
                                });
                              },
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(100, 19, 189, 1),
                            ),
                          ),
                          obscureText: !_isPasswordVisible, // Toggle obscuring based on state
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              // Forgot Password action
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color.fromRGBO(100, 19, 189, 1),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 70),
    Container(
    height: 55,
    width: 300,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    gradient: const LinearGradient(
    colors: [
    Color.fromRGBO(255, 155, 210,1),
    Color.fromRGBO(100, 19, 189,1),
    ]
    ),
    ),
    child: GestureDetector(
    onTap: (){
      _signIn(_idController.text, _passwordController.text);
    },
    child: const Center(child: Text('SIGN IN',style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.white
    ),),),
    ),
    ),
                        const SizedBox(height: 150),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const RegScreen()),
                                  );
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Color.fromRGBO(100, 19, 189, 1),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _connection.close();
    super.dispose();
  }
}