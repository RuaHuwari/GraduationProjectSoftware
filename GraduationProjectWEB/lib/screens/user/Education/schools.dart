import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class School {
  final String schoolname;
  final String schoolname_arabic;
  final String about;
  final String about_arabic;
  final String governate;
  final String phonenumber;
  final bool Elementary, Secondary, HighSchool, Scientific, Literature, Commercial;
  final String type;

  School({
    required this.schoolname,
    required this.about,
    required this.governate,
    required this.phonenumber,
    required this.type,
    required this.Secondary,
    required this.about_arabic,
    required this.Commercial,
    required this.Elementary,
    required this.HighSchool,
    required this.Literature,
    required this.schoolname_arabic,
    required this.Scientific,
  });
}

class Schools extends StatefulWidget {
  Schools({
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.isEnglish,
  });

  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  State<Schools> createState() => _SchoolsState();
}

class _SchoolsState extends State<Schools> {
  List<School> schools = [];
  String? selectedGovernate;
  String? selectedType;
  String? selectedLevel;
  String? selectedHighSchoolType;
  bool isLoading = true;

  Future<void> fetchSchoolData() async {
    try {
      final response = await http.get(Uri.parse('http://$IP/palease_api/schools.php'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        if (data is List) {
          List<School> loadedSchools = data.map((schoolData) {
            return School(
              schoolname: schoolData['schoolname'],
              about: schoolData['about'],
              governate: schoolData['governate'],
              phonenumber: schoolData['phonenumber'],
              type: schoolData['type'],
              Secondary: schoolData['Secondary'] == '1',
              about_arabic: schoolData['about_arabic'],
              Commercial: schoolData['Commercial'] == '1',
              Elementary: schoolData['Elementary'] == '1',
              HighSchool: schoolData['HighSchool'] == '1',
              Literature: schoolData['Literature'] == '1',
              schoolname_arabic: schoolData['schoolname_arabic'],
              Scientific: schoolData['Scientific'] == '1',
            );
          }).toList();
          setState(() {
            schools = loadedSchools;
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load school data');
      }
    } catch (error) {
      print('Error fetching school data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isEnglish = true;

  @override
  void initState() {
    super.initState();
    fetchSchoolData();
    isEnglish = widget.isEnglish;
  }

  List<String> getUniqueGovernates() {
    Set<String> governatesSet = Set();
    for (var school in schools) {
      governatesSet.add(school.governate);
    }
    return governatesSet.toList();
  }

  List<School> getFilteredSchools() {
    return schools.where((school) {
      bool matchesGovernate = selectedGovernate == null || school.governate == selectedGovernate;
      bool matchesType = selectedType == null || school.type == selectedType || selectedType == 'Both';
      bool matchesLevel = selectedLevel == null ||
          (selectedLevel == 'Elementary' && school.Elementary) ||
          (selectedLevel == 'Secondary' && school.Secondary) ||
          (selectedLevel == 'HighSchool' && school.HighSchool);
      bool matchesHighSchoolType = selectedLevel != 'HighSchool' ||
          (selectedHighSchoolType == null) ||
          (selectedHighSchoolType == 'Scientific' && school.Scientific) ||
          (selectedHighSchoolType == 'Literature' && school.Literature) ||
          (selectedHighSchoolType == 'Commercial' && school.Commercial);
      return matchesGovernate && matchesType && matchesLevel && matchesHighSchoolType;
    }).toList();
  }

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(
          context,
          isEnglish ? 'Schools' : 'المدارس',
          widget.userId,
          widget.firstname,
          widget.lastname,
          isEnglish,
          _toggleLanguage),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            hint: Text(isEnglish ? 'Select Governate' : 'اختر المحافظة'),
            value: selectedGovernate,
            items: getUniqueGovernates().map((governate) {
              return DropdownMenuItem<String>(
                value: governate,
                child: Text(governate),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedGovernate = newValue;
              });
            },
          ),
          DropdownButton<String>(
            hint: Text(isEnglish ? 'Select Type' : 'اختر النوع'),
            value: selectedType,
            items: ['Private', 'Governmental', 'Both'].map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedType = newValue;
              });
            },
          ),
          DropdownButton<String>(
            hint: Text(isEnglish ? 'Select Level' : 'اختر المرحلة'),
            value: selectedLevel,
            items: ['Elementary', 'Secondary', 'HighSchool'].map((level) {
              return DropdownMenuItem<String>(
                value: level,
                child: Text(level),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedLevel = newValue;
                selectedHighSchoolType = null;
              });
            },
          ),
          if (selectedLevel == 'HighSchool')
            DropdownButton<String>(
              hint: Text(isEnglish ? 'Select High School Type' : 'اختر نوع المدرسة الثانوية'),
              value: selectedHighSchoolType,
              items: ['Scientific', 'Literature', 'Commercial'].map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedHighSchoolType = newValue;
                });
              },
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.0, // Adjusted childAspectRatio to reduce the height
                  mainAxisSpacing: 60,
                  crossAxisSpacing: 60,
                ),
                itemCount: getFilteredSchools().length,
                itemBuilder: (context, index) {
                  School school = getFilteredSchools()[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        isEnglish ? school.schoolname : school.schoolname_arabic,
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        isEnglish ? school.about : school.about_arabic,
                        textAlign: isEnglish ? TextAlign.justify : TextAlign.right,
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone),
                          Text(school.phonenumber),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
