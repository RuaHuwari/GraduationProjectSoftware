import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class OrphanagesScreen extends StatefulWidget {
  final String firstname;
  final String lastname;
  final String userId;
  final bool isEnglish;

  OrphanagesScreen({
    required this.firstname,
    required this.lastname,
    required this.userId,
    required this.isEnglish,
  });

  @override
  _OrphanagesScreenState createState() => _OrphanagesScreenState();
}

class _OrphanagesScreenState extends State<OrphanagesScreen> {
  List orphanages = [];
  List filteredOrphanages = [];
  String selectedGovernate = 'All';
  Set<String> governates = {'All'};
  bool isEnglish = true;

  @override
  void initState() {
    super.initState();
    fetchOrphanages();
    isEnglish = widget.isEnglish;
  }

  Future<void> fetchOrphanages() async {
    final response = await http.get(Uri.parse('http://$IP/palease_api/orphanages.php'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      setState(() {
        orphanages = data;
        filteredOrphanages = data;
        governates.addAll(data.map<String>((o) => o['Governate']).toSet());
      });
    } else {
      throw Exception('Failed to load orphanages');
    }
  }

  void filterOrphanages() {
    setState(() {
      if (selectedGovernate == 'All') {
        filteredOrphanages = orphanages;
      }else if(selectedGovernate == 'الكل'){
        filteredOrphanages = orphanages;
      } else{
        filteredOrphanages = orphanages.where((o) => o['Governate'] == selectedGovernate).toList();
      }
    });
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
        isEnglish ? 'Orphanages' : 'دور الأيتام',
        widget.userId,
        widget.firstname,
        widget.lastname,
        isEnglish,
        _toggleLanguage,
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedGovernate,
            onChanged: (String? newValue) {
              setState(() {
                selectedGovernate = newValue!;
                filterOrphanages();
              });
            },
            items: governates.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrphanages.length,
              itemBuilder: (context, index) {
                var orphanage = filteredOrphanages[index];
                return Card(
                  margin: EdgeInsets.only(top:20, left:50,right:50),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orphanage['name'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple
                          ),
                        ),
                        SizedBox(height: 10),
                        isEnglish
                            ? Text('About: ${orphanage['about-eng']}',textAlign: TextAlign.left,)
                            : Text('عن الجمعية: ${orphanage['about-arabic']}',textAlign: TextAlign.right,),
                        SizedBox(height: 5),
                        Text('Phone: ${orphanage['Phone'].toString()}'),
                        Text('Email: ${orphanage['email']}'),
                        SizedBox(height: 10),
                        if (orphanage['Donation'] != null)
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                _launchURL(orphanage['Donation']);
                              },
                              child: Text(isEnglish
                                  ? 'Navigate to Donation Page'
                                  : 'الانتفال الى صفحة التبرعات '),
                            ),
                          ),
                        SizedBox(height: 10,),
                        if (orphanage['sponser_an_orphan'] != null &&
                            orphanage['sponser_an_orphan'].isNotEmpty)
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                _launchURL(orphanage['sponser_an_orphan']);
                              },
                              child: Text(isEnglish
                                  ? 'Sponsor an Orphan'
                                  : 'كفالة يتيم'),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
