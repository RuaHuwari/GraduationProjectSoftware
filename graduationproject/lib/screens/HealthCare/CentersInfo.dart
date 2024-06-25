import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduationproject/Constans/API.dart';
import 'package:graduationproject/Constans/colors.dart';
import 'package:graduationproject/screens/HealthCare/HealthCare.dart';
import 'package:graduationproject/screens/HealthCare/form.dart';
import 'package:http/http.dart' as http;
class CentersInfoPage extends StatefulWidget {
  CentersInfoPage({ required this.userId, required this.firstname, required this.lastname, required this.id});
  final String userId;
  final String firstname;
  final String lastname;
  final int id;
  @override
  _CentersInfoPageState createState() => _CentersInfoPageState();
}

class _CentersInfoPageState extends State<CentersInfoPage> {
  List<dynamic> centersData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Replace 'your_server_url' with the URL where your PHP file is hosted
      String uri="http://$IP/palease_api/centersinfo.php";
      var response=await http.post(Uri.parse(uri),body: {
        'requested_id': widget.id.toString()
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 35,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                HealthCare(userId: widget.userId,
                    firstname: widget.firstname,
                    lastname: widget.lastname)));
          },
        ),
        title: Text('Special Needs Centers', style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent,
        // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
           color: Colors.purple
          ),
        ),

      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: const BoxDecoration(
            color: Colors.purple
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(left:10.0,right:10),
            child: ListView.builder(
              itemCount: centersData.length,
              itemBuilder: (context, index) {
                var center = centersData[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  color: Colors.white.withOpacity(1),
                  child: ListTile(
                    title: Text(center['centername'],textAlign: TextAlign.center,style:TextStyle(color: primary,fontFamily: 'NotoSerif', fontSize: 30,fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.phone, color: Colors.purple,),
                                Text(center['phonenumber'].toString(), style: TextStyle(fontSize: 20,fontFamily: 'SansSerif'),),
                              ],
                            ),  Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on_outlined, color: Colors.deepPurpleAccent,),
                                Text(center['Address'],style: TextStyle(fontSize: 20,fontFamily: 'SansSerif'),),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.mail_outline, color: Colors.deepPurple,),
                            Text(center['email'],style: TextStyle(fontSize: 20,fontFamily: 'SansSerif'),),

                          ],
                        ),
                        SizedBox(height:15),
                        Text(center['about'],textAlign: TextAlign.justify,style: TextStyle(fontSize: 20,fontFamily: 'SansSerif'),),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>SpecialNeedsForm(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname,id:center['RoleID']))
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
