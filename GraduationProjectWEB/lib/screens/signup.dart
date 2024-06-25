import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/login.dart';
import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  late MySqlConnection _connection;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  Future<void> _signup(
      String firstName,
      String lastName,
      String phone,
      String id,
      String password,
      String confirmPassword,
      ) async {
    // Perform validation
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    if (firstName == "" || lastName == "" || id == "" || phone == "" || password == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      String uri = "http://$IP/palease_api/insert_record.php";
      var res = await http.post(Uri.parse(uri), body: {
        "id": id,
        "firstname": firstName,
        "lastname": lastName,
        "phone": phone,
        "password": password,
      });

      // Handle server response
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

          // Handle successful signup
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signup successful')),
          );

      } else {
        // Handle HTTP errors
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to connect to the server')),
        );
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again later.')),
      );
      print(e);
    }
  }
  bool _isPasswordVisible = false;
  bool _isPasswordVisible2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Secondary.withOpacity(0.2) ,
      body: Padding(
        padding: EdgeInsets.only(top: 60.0, bottom: 60.0, left: 120.0, right: 120.0),
        child: Card(
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(40.0)),
          elevation: 5.0,
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width /3.3,
                  height: MediaQuery.of(context).size.height,

                  decoration:BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [primary,Secondary],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 85.0, right: 50.0, left: 50.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: <Widget>[

                          SizedBox(height: 60.0,),

                          Container(
                            padding: EdgeInsets.only(
                                top: 5.0,
                                bottom: 5.0
                            ),
                            child: Text(
                              "Let's get you set up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),

                          SizedBox(height: 5.0,),

                          Container(
                            padding: EdgeInsets.only(
                                top: 5.0,
                                bottom: 5.0
                            ),
                            child: Text(
                              "It should only take a couple of minutes to create your account",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(height: 50.0,),


                          ElevatedButton(
                            onPressed: ()
                            {
                              Navigator.push
                                (
                                  context,
                                  MaterialPageRoute(builder: (context)
                                  {
                                    return new loginScreen();
                                  })
                              );
                            },
                            child: Text(
                              "Login",
                              style:TextStyle(
                                  color: Color.fromRGBO(100, 19, 189, 1)
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),




                Container(
                  padding: EdgeInsets.only(top: 15.0, right: 70.0, left: 70.0, bottom: 10.0),
                  child: Column(
                    children: <Widget>[

                      Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Color.fromRGBO(100, 19, 189, 1), fontWeight: FontWeight.w600, fontSize: 35.0, fontFamily: 'Merriweather'),
                      ),
                      const SizedBox(height: 21.0),

                      //InputField Widget from the widgets folder
                    Row(
                      children: <Widget>[
                        Container(
                          width: 80.0,
                          child: Text(
                            "First name",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(100, 19, 189, 1)
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3.7,
                          color: Color.fromRGBO(255, 155, 210, 0.2),
                          child: TextField(
                            controller: _firstNameController,
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(100, 19, 189, 1),
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(100, 19, 189, 1),
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: "enter your first name",
                              fillColor: Color.fromRGBO(255, 155, 210, 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),

                      SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 80.0,
                          child: Text(
                            "Last Name",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(100, 19, 189, 1)
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3.7,
                          color: Color.fromRGBO(255, 155, 210, 0.2),
                          child: TextField(
                            controller: _lastNameController,
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(100, 19, 189, 1),
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(100, 19, 189, 1),
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: "enter you last name",
                              fillColor: Color.fromRGBO(255, 155, 210, 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),

                      SizedBox(height: 20.0),

                    Row(
                      children: <Widget>[
                        Container(
                          width: 80.0,
                          child: Text(
                            "ID",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(100, 19, 189, 1)
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3.7,
                          color: Color.fromRGBO(255, 155, 210, 0.2),
                          child: TextField(
                            controller: _idController,
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(100, 19, 189, 1),
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(100, 19, 189, 1),
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: "ID",
                              fillColor: Color.fromRGBO(255, 155, 210, 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),

                      SizedBox(height: 20.0),
                      //InputField Widget from the widgets folder




                    Row(
                      children: <Widget>[
                        Container(
                          width: 80.0,
                          child: Text(
                            "Password",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(100, 19, 189, 1)
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3.7,
                          color: Color.fromRGBO(255, 155, 210, 0.2),
                          child: TextField(
                            controller: _passwordController,
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(100, 19, 189, 1),
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(100, 19, 189, 1),
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: "Password",
                              fillColor: Color.fromRGBO(255, 155, 210, 0.5),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: _isPasswordVisible
                                      ? Colors.white
                                      : Color.fromRGBO(100, 19, 189, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),


                      SizedBox(height: 20.0),

          Row(
            children: <Widget>[
              Container(
                width: 80.0,
                child: Text(
                  "Confirm Password",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(100, 19, 189, 1)
                  ),
                ),
              ),
              SizedBox(
                width: 40.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3.7,
                color: Color.fromRGBO(255, 155, 210, 0.2),
                child: TextField(
                  controller: _confirmPasswordController,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                  obscureText: !_isPasswordVisible2,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(100, 19, 189, 1),
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(100, 19, 189, 1),
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Confirm Password",
                    fillColor: Color.fromRGBO(255, 155, 210, 0.5),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible2 = !_isPasswordVisible2;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible2 ? Icons.visibility : Icons.visibility_off,
                        color: _isPasswordVisible2
                            ? Colors.white
                            : Color.fromRGBO(100, 19, 189, 1),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
                  SizedBox(height:20),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 80.0,
                        child: Text(
                          "Phone Number",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(100, 19, 189, 1)
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3.7,
                        color: Color.fromRGBO(255, 155, 210, 0.2),
                        child: TextField(
                          controller:_phoneController,
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(100, 19, 189, 1),
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(100, 19, 189, 1),
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: "Phone #",
                            fillColor: Color.fromRGBO(255, 155, 210, 0.5),
                          ),
                        ),
                      ),
                    ],
                  ),


                      SizedBox(height: 40.0,),

                      Row(
                        children: <Widget>[
                          SizedBox(width: 140.0,),

                          ElevatedButton(
                            onPressed: (){
                              _signup(_firstNameController.text, _lastNameController.text, _phoneController.text, _idController.text,_passwordController.text,_confirmPasswordController.text);
                            },
                            child: Text(
                              "Create Account",
                              style: TextStyle(
                                  color: Colors.purple
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),

                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}

class InputField extends StatelessWidget {
  final String label;
  final String content;

  InputField({required this.label, required this.content});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          children: <Widget>[
            Container(
              width: 80.0,
              child: Text(
                "$label",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(100, 19, 189, 1)
                ),
              ),
            ),
            SizedBox(
              width: 40.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3.7,
              color: Color.fromRGBO(255, 155, 210, 0.2),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(100, 19, 189, 1),
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(100, 19, 189, 1),
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "$content",
                  fillColor: Color.fromRGBO(255, 155, 210, 0.5),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
