import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/profile/profile.dart';
import 'package:graduationprojectweb/screens/user/Application/Application.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/HealthCare.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/form.dart';
import 'package:graduationprojectweb/screens/user/HomeScreen.dart';
import 'package:graduationprojectweb/screens/user/Search.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:http/http.dart' as http;

class CentersInfoPage extends StatefulWidget {
  CentersInfoPage({required this.userId, required this.firstname, required this.lastname, required this.id, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final String id;
  final bool isEnglish;

  @override
  _CentersInfoPageState createState() => _CentersInfoPageState();
}

class _CentersInfoPageState extends State<CentersInfoPage> {
  bool isEnglish = true;

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  List<dynamic> centersData = [];

  @override
  void initState() {
    super.initState();
    isEnglish=widget.isEnglish;
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      String uri = "http://$IP/palease_api/centersinfo.php";
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'requested_id': widget.id
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          centersData = data['centers'];
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(
        context,
        isEnglish ? 'Centers' : 'المراكز',
        widget.userId,
        widget.firstname,
        widget.lastname,
        isEnglish,
        _toggleLanguage, // Pass the toggle method to the app bar
         // Pass the language state to the app bar
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.purple,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 80.0, right: 80),
            child: ListView.builder(
              itemCount: centersData.length,
              itemBuilder: (context, index) {
                var center = centersData[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  color: Colors.white.withOpacity(1),
                  child: ListTile(
                    title: Text(
                      center['centername'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primary,
                        fontFamily: 'NotoSerif',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.phone, color: Colors.purple),
                                Text(
                                  center['phonenumber'].toString(),
                                  style: TextStyle(fontSize: 20, fontFamily: 'SansSerif'),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.mail_outline, color: Colors.deepPurple),
                                Text(
                                  center['email'],
                                  style: TextStyle(fontSize: 20, fontFamily: 'SansSerif'),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on_outlined, color: Colors.deepPurpleAccent),
                                Text(
                                  center['Address'],
                                  style: TextStyle(fontSize: 20, fontFamily: 'SansSerif'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(
                          center['about'],
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 20, fontFamily: 'SansSerif'),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpecialNeedsForm(
                            userId: widget.userId,
                            firstname: widget.firstname,
                            lastname: widget.lastname,
                            id: center['RoleID'].toString(), isEnglish: isEnglish,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
