import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Constans/API.dart';
import 'package:graduationproject/Constans/colors.dart';
import 'package:graduationproject/screens/Education/Education.dart';
import 'package:graduationproject/screens/profile/profile.dart';
import 'package:graduationproject/widgets/bottomnavigation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class School {
  final String schoolname;
  final String about;
  final String governate;
  final String phonenumber;
  final String type;

  School({
    required this.schoolname,
    required this.about,
    required this.governate,
    required this.phonenumber,
    required this.type,
  });
}

class Schools extends StatefulWidget {
  Schools({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  State<Schools> createState() => _SchoolsState();
}

class _SchoolsState extends State<Schools> {
  late List<School> schools;
  String? selectedOption;
  String? selectedGovernate;
  String? selectedType;

  Future<void> fetchSchoolData() async {
    final response = await http.get(
        Uri.parse('http://$IP/palease_api/schools.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        schools = data.map((schoolData) {
          return School(
            schoolname: schoolData['schoolname'],
            about: schoolData['about'],
            governate: schoolData['governate'],
            phonenumber: schoolData['phonenumber'],
            type: schoolData['type'],
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to load school data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSchoolData();
  }

  List<String> getUniqueGovernates() {
    Set<String> governatesSet = Set();
    schools.forEach((school) {
      governatesSet.add(school.governate);
    });
    return governatesSet.toList();
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
                Education(userId: widget.userId,
                    firstname: widget.firstname,
                    lastname: widget.lastname)));
          },
        ),
        title: Text('Schools', style: TextStyle(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedOption,
              items: ["Governate", "Type"].map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                  selectedGovernate = null;
                  selectedType = null;
                });
              },
              hint: Text("Select Filter Option"),
            ),
          ),
          if (selectedOption == "Governate")
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: selectedGovernate,
                items: getUniqueGovernates().map((governate) {
                  return DropdownMenuItem<String>(
                    value: governate,
                    child: Text(governate),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGovernate = value;
                  });
                },
                hint: Text("Select Governate"),
              ),
            ),
          if (selectedOption == "Type")
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: selectedType,
                items: ['Elementary', 'Secondary'].map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
                hint: Text("Select School Type"),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: schools.length,
              itemBuilder: (context, index) {
                if ((selectedOption == "Governate" &&
                    schools[index].governate == selectedGovernate) ||
                    (selectedOption == "Type" &&
                        schools[index].type == selectedType)) {
                  return Card(
                    child: ListTile(
                      title: Center(child: Text(schools[index].schoolname, style: TextStyle(color:Colors.deepPurple, fontFamily: 'NotoSerif',fontSize: 30,fontWeight: FontWeight.bold),)),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.location_on_outlined, color: Color.fromRGBO(216, 31, 250, 1),),
                              Text(schools[index].governate, style: TextStyle(color: Colors.black, fontSize: 15,fontFamily: 'SansSerif'),),
                            ],
                          ),

                          Column(
                            children: [
                              Icon(Icons.phone, color: Color.fromRGBO(216, 31, 250, 1,)),
                              Text(schools[index].phonenumber, style: TextStyle(color: Colors.black, fontSize: 15,fontFamily: 'SansSerif'),),
                            ],
                          ),
                          Column(
                              children: [
                               Image(image: AssetImage('assets/campus.png'), height: 30,),
                                Text(schools[index].type, style: TextStyle(color: Colors.black, fontSize: 15,fontFamily: 'SansSerif'),),
                              ]
                          ),
                        ]
                      ),
                          Text(schools[index].about, style: TextStyle(color: Colors.black, fontSize: 15,fontFamily: 'SansSerif'),),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
          navigator.buildNavigator(context,widget.userId,widget.firstname,widget.lastname),
        ],
      ),
    );
  }
}