import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/profile/profile.dart';
import 'package:graduationprojectweb/screens/user/Application/Application.dart';
import 'package:graduationprojectweb/screens/user/Education/UniversityData.dart';
import 'package:graduationprojectweb/screens/user/HomeScreen.dart';
import 'package:graduationprojectweb/screens/user/Search.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  Universities({required this.userId, required this.firstname, required this.lastname, required this.isEnglish});

  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

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
    isEnglish = widget.isEnglish;
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

    if (selectedOption == "GPA" || selectedOption == 'معدل الثانوية') {
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
    } else if (selectedOption == "Governate" || selectedOption == 'المحافظة') {
      if (selectedGovernate != null) {
        filteredList = filteredList.where((uni) => uni.governate == selectedGovernate).toList();
      }
    } else if (selectedOption == "Major" || selectedOption == 'التخصص') {
      if (selectedMajor != null) {
        filteredList = filteredList.where((uni) {
          return uni.majors.any((major) => major['name'] == selectedMajor);
        }).toList();
      }
    }

    return filteredList;
  }

  List<dynamic> getFilteredMajors() {
    List<dynamic> filteredMajors = [];
    if (isEnglish == false) {
      if (selectedSchoolType == 'علمي') selectedSchoolType = 'scientific';
      if (selectedSchoolType == 'أدبي') selectedSchoolType = 'literature';
      if (selectedSchoolType == 'تجاري') selectedSchoolType = 'Commercial';
    }
    if ((selectedOption == "GPA" || selectedOption == 'معدل الثانوية') && selectedGPA != null && selectedSchoolType != null) {
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

  bool isEnglish = true;

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(context, isEnglish ? 'Universities' : 'الجامعات', widget.userId, widget.firstname, widget.lastname, isEnglish, _toggleLanguage),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedOption,
                      items: [
                        isEnglish ? "GPA" : 'معدل الثانوية',
                        isEnglish ? "Governate" : 'المحافظة',
                        isEnglish ? "Major" : 'التخصص',
                      ].map((option) {
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
                      hint: Text(isEnglish ? "Select Filter Option" : 'اظهر النتائج حسب'),
                    ),
                    if (selectedOption == "GPA" || selectedOption == 'معدل الثانوية')
                      Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(labelText: isEnglish ? "Enter GPA" : 'ادخل معدل الثانوية'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                selectedGPA = double.tryParse(value);
                              });
                            },
                          ),
                          DropdownButtonFormField<String>(
                            value: selectedSchoolType,
                            items: [
                              isEnglish ? "scientific" : 'علمي',
                              isEnglish ? "literature" : 'أدبي',
                              isEnglish ? "Commercial" : 'تجاري',
                            ].map((type) {
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
                            hint: Text(isEnglish ? "Select High School Type" : 'اختر فرع الثانوية العامة'),
                          ),
                        ],
                      ),
                    if (selectedOption == "Governate" || selectedOption == 'المحافظة')
                      DropdownButtonFormField<String>(
                        value: selectedGovernate,
                        items: ["Nablus/نابلس", "Ramallah/رام الله", "Tulkarm/طولكرم"].map((governate) {
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
                        hint: Text(isEnglish ? "Select Governate" : 'اختر المحافظة'),
                      ),
                    if (selectedOption == "Major" || selectedOption == 'التخصص')
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
                        hint: Text(isEnglish ? "Select Major" : 'اختر التخصص'),
                      ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 0, left: 50, right: 50),
                        itemCount: selectedOption == (isEnglish ? "GPA" : 'معدل الثانوية') ? getFilteredMajors().length : getFilteredUniversities().length,
                        itemBuilder: (context, index) {
                          if (selectedOption == "GPA" || selectedOption == 'معدل الثانوية') {
                            var major = getFilteredMajors()[index];
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UniversitiesData(
                                        userId: widget.userId,
                                        firstname: widget.firstname,
                                        lastname: widget.lastname,
                                        name: major['university'],
                                        isEnglish: isEnglish,
                                      ),
                                    ),
                                  );
                                },
                                title: Text(
                                  major['major'],
                                  style: TextStyle(color: primary),
                                ),
                                subtitle: Text(
                                  isEnglish
                                      ? "University: ${major['university']}, GPA Required: ${major['gpa_requirement']}"
                                      : "الجامعة: \n ${major['university']},\n معدل الثانوية المطلوب:\n ${major['gpa_requirement']}",
                                ),
                              ),
                            );
                          } else {
                            var university = getFilteredUniversities()[index];
                            if (selectedOption == "Governate" || selectedOption == 'المحافظة') {
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UniversitiesData(
                                          userId: widget.userId,
                                          firstname: widget.firstname,
                                          lastname: widget.lastname,
                                          name: university.name,
                                          isEnglish: isEnglish,
                                        ),
                                      ),
                                    );
                                  },
                                  title: Text(university.name),
                                  subtitle: Text(isEnglish ? "Governate: ${university.governate}" : 'المحافظة:${university.governate} '),
                                ),
                              );
                            } else if (selectedOption == "Major" || selectedOption == 'التخصص') {
                              var major = university.majors.firstWhere((major) => major['name'] == selectedMajor);
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UniversitiesData(
                                          userId: widget.userId,
                                          firstname: widget.firstname,
                                          lastname: widget.lastname,
                                          name: university.name,
                                          isEnglish: isEnglish,
                                        ),
                                      ),
                                    );
                                  },
                                  title: Text(university.name),
                                  subtitle: Text(isEnglish ? "Major: ${major['name']}, GPA Required: ${major['gpa_requirement']}" : 'التخصص: \n${major['name']}, \nمعدل الثانوية المطلوب: \n${major['gpa_requirement']}'),
                                ),
                              );
                            }
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
