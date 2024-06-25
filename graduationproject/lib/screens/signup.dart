import 'package:flutter/material.dart';
import 'package:graduationproject/screens/login.dart';
import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Constans/API.dart';
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

  Future<void> _signup (
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
    if(firstName == "" || lastName=="" || id=="" || phone =="" || password==""){
    print("please fill in all field");
    }else{
      try{
        String uri="http://$IP/palease_api/insert_record.php";
       var res=await http.post(Uri.parse(uri),body: {
         "id":id,
         "firstname":firstName,
         "lastname": lastName,
         "phone": phone,
         "password":password,

       });
// Handle server response
        if (res.statusCode == 200) {
          var data = jsonDecode(res.body);

          // Handle successful signup
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signup successful')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const loginScreen()),
          );
        } else {
          // Handle HTTP errors
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to connect to the server')),
          );
        }
      }catch(e){
        print(e);
      }
    }
  }
  bool _isPasswordVisible = false;
  bool _isPasswordVisible2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(//thanks for watching
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                color:Colors.purple
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Create Your\nAccount',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 140.0),
              child:ListView(
                children: [
                Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                child:
                Padding(
                  padding: const EdgeInsets.fromLTRB( 18.0,18.0, 18.0,18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       TextField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.check,color: Colors.grey,),
                            label: Text('First Name',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(100, 19, 189,1),
                            ),)
                        ),
                      ),
                       TextField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.check,color: Colors.grey,),
                            label: Text('Last Name',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(100, 19, 189,1),
                            ),)
                        ),
                      ),
                       TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.check,color: Colors.grey,),
                            label: Text('Phone ',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(100, 19, 189,1),
                            ),)
                        ),
                      ),
                       TextField(
                        controller: _idController,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.check,color: Colors.grey,),
                            label: Text('ID ',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(100, 19, 189,1),
                            ),)
                        ),
                      ),
                       TextField(
                       controller:  _passwordController,
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

                            label: Text('Password',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(100, 19, 189,1),
                            ),)
                        ),
                         obscureText: !_isPasswordVisible,
                      ),
                       TextField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible2 ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible2 = !_isPasswordVisible2; // Toggle the state
                                });
                              },
                            ),
                            label: Text('Confirm Password',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(100, 19, 189,1),
                            ),)
                        ),
                         obscureText: !_isPasswordVisible2,
                      ),

                      //const SizedBox(height: 10,),
                      const SizedBox(height: 60,),
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
                            String firstName = _firstNameController.text;
                            String lastName = _lastNameController.text;
                            String phone = _phoneController.text;
                            String id = _idController.text;
                            String password = _passwordController.text;
                            String confirmPassword = _confirmPasswordController.text;

                            // Call sign up function
                            _signup(firstName, lastName, phone, id, password, confirmPassword);
                          },
                          child: const Center(child: Text('SIGN UP',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white
                          ),),),
                        )

                      ),
                      const SizedBox(height: 40,),
                       Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Already have an account?",style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                            ),),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const loginScreen()),
                                );
                              },
                              child:Text('Sign In', style:TextStyle(
                                  color: Color.fromRGBO(100, 19, 189,1),
                                  fontSize: 20
                              )),
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
        ));
  }
}