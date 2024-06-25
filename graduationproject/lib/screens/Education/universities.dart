import 'package:flutter/material.dart';
import 'package:graduationproject/Constans/API.dart';
import 'package:graduationproject/Constans/colors.dart';
import 'package:graduationproject/widgets/bottomnavigation.dart';
import 'package:graduationproject/screens/Education/UniversityData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Education.dart';

class University {
  final String name;
  final String governate;
  final List<Map<String, dynamic>> majors;

  University({
    required this.name,
    required this.governate,
    required this.majors,
  });
}

class Universities extends StatefulWidget {
  Universities({required this.userId, required this.firstname, required this.lastname});

  final String userId;
  final String firstname;
  final String lastname;

  @override
  State<Universities> createState() => _UniversitiesState();
}

class _UniversitiesState extends State<Universities> {
  List<University> universities = [];
  String? selectedOption;
  double? selectedGPA;
  String? selectedSchoolType;
  String? selectedGovernate;
  String? selectedMajor;

  Future<void> fetchUniversityData() async {
    final response = await http.get(
        Uri.parse('http://$IP/palease_api/universities.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        universities = data.map((universityData) {
          return University(
            name: universityData['name'],
            governate: universityData['governate'],
            majors: List<Map<String, dynamic>>.from(universityData['majors']),
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to load university data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUniversityData();
  }

  List<String> getUniqueMajors() {
    Set<String> majorsSet = Set();
    universities.forEach((university) {
      university.majors.forEach((major) {
        majorsSet.add(major['name']);
      });
    });
    return majorsSet.toList();
  }

  List<University> getFilteredUniversities() {
    var filteredList = universities;

    if (selectedOption == "GPA") {
      if (selectedGPA != null && selectedSchoolType != null) {
        filteredList = filteredList.where((uni) {
          return uni.majors.any((major) {
            var gpaRequirement = double.tryParse(major['gpa_requirement'].toString());
            return gpaRequirement != null &&
                gpaRequirement <= selectedGPA! &&
                major['high_school_type'] == selectedSchoolType;
          });
        }).toList();
      }
    }else if (selectedOption == "Governate") {
      if (selectedGovernate != null) {
        filteredList = filteredList.where((uni) => uni.governate == selectedGovernate).toList();
      }
    }
    else if (selectedOption == "Major") {
      filteredList = filteredList.where((uni) {
        return uni.majors.any((major) => major['name'] == selectedMajor);
      }).toList();
    }


    return filteredList;
  }
  List<dynamic> getFilteredMajors() {
    List<dynamic> filteredMajors = [];

    if (selectedOption == "GPA" && selectedGPA != null && selectedSchoolType != null) {
      universities.forEach((uni) {
        uni.majors.forEach((major) {
          var gpaRequirement = double.tryParse(major['gpa_requirement'].toString());
          if (gpaRequirement != null &&
              gpaRequirement <= selectedGPA! &&
              major['high_school_type'] == selectedSchoolType) {
            filteredMajors.add({
              'university': uni.name,
              'major': major['name'],
              'gpa_requirement': major['gpa_requirement'],
            });
          }
        });
      });
    }

    return filteredMajors;
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
        title: Text('Universities', style: TextStyle(
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
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
             color: Colors.white
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
            child: Container(
              decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:10.0,right:10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedOption,
                      items: ["GPA", "Governate", "Major"].map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                          selectedGPA = null;
                          selectedSchoolType = null;
                          selectedGovernate = null;
                          selectedMajor = null;
                        });
                      },
                      hint: Text("Select Filter Option"),
                    ),
                    if (selectedOption == "GPA")
                      Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(labelText: "Enter GPA"),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                selectedGPA = double.tryParse(value);
                              });
                            },
                          ),
                          DropdownButtonFormField<String>(
                            value: selectedSchoolType,
                            items: ["scientific", "literary","Commercial"].map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedSchoolType = value;
                              });
                            },
                            hint: Text("Select School Type"),
                          ),
                        ],
                      ),
                    if (selectedOption == "Governate")
                      DropdownButtonFormField<String>(
                        value: selectedGovernate,
                        items: ["Nablus", "Ramallah", "Tulkarm"].map((governate) {
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
                    if (selectedOption == "Major")
                      DropdownButtonFormField<String>(
                        value: selectedMajor,
                        items: getUniqueMajors().map((major) {
                          return DropdownMenuItem<String>(
                            value: major,
                            child: Text(major),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMajor = value;
                          });
                        },
                        hint: Text("Select Major"),
                      ),
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.only(top: 0, left: 50, right: 50),
                       itemCount: selectedOption == "GPA" ? getFilteredMajors().length : getFilteredUniversities().length,
                       itemBuilder: (context, index) {
                         if (selectedOption == "GPA") {
                           var major = getFilteredMajors()[index];
                           return Card(
                             child: ListTile(
                               onTap: (){
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(builder: (context) =>
                                       UniversitiesData(userId: widget.userId,firstname: widget.firstname,lastname: widget.lastname, name: major['university'],),
                                 )
                                 );
                               },
                               title: Text(major['major'],style: TextStyle(color: primary),),
                               subtitle: Text(
                                   "University: ${major['university']}, GPA Required: ${major['gpa_requirement']}",),
                             ),
                           );
                         } else {
                           var university = getFilteredUniversities()[index];
                           if (selectedOption == "Governate") {
                             return Card(
                               child: ListTile(
                                 onTap: (){
                                   Navigator.push(
                                       context,
                                       MaterialPageRoute(builder: (context) =>
                                           UniversitiesData(userId: widget.userId,firstname: widget.firstname,lastname: widget.lastname, name: university.name,),
                                       )
                                   );
                                 },
                                 title: Text(university.name),
                                 subtitle: Text(
                                     "Governate: ${university.governate}"),
                               ),
                             );
                           } else if (selectedOption == "Major") {
                             var major = university.majors.firstWhere((
                                 major) => major['name'] == selectedMajor);
                             return Card(
                               child: ListTile(
                                 onTap: (){
                                   Navigator.push(
                                       context,
                                       MaterialPageRoute(builder: (context) =>
                                           UniversitiesData(userId: widget.userId,firstname: widget.firstname,lastname: widget.lastname, name: university.name,),
                                       )
                                   );
                                 },
                                 title: Text(university.name),
                                 subtitle: Text(
                                     "Major: ${major['name']}, GPA Required: ${major['gpa_requirement']}"),
                               ),
                             );
                           }
                           return SizedBox();
                         }

                       }
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
          navigator.buildNavigator(context,widget.userId,widget.firstname,widget.lastname),
        ],
      ),
    );
  }
}
