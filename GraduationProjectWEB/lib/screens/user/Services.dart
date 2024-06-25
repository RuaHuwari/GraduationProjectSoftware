import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/screens/profile/profile.dart';
import 'package:graduationprojectweb/screens/user/Application/Application.dart';
import 'package:graduationprojectweb/screens/user/HomeScreen.dart';
import 'package:graduationprojectweb/screens/user/Search.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:graduationprojectweb/widgets/BuildButton.dart';

class services extends StatefulWidget {
  services({required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  State<services> createState() => _servicesState();
}

class _servicesState extends State<services> {
  bool isEnglish = true;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEnglish=widget.isEnglish;
  }
  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Search Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Profile Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(
        context,
        isEnglish ? 'Services' : 'الخدمات',
        widget.userId,
        widget.firstname,
        widget.lastname,
        isEnglish,
        _toggleLanguage,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 22),
              child: Text(
                isEnglish ? 'How can we help you?' : 'كيف يمكننا مساعدتك؟',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 130, 0, 0),
            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                buildButton.buildbutton(
                                  context,
                                  'id',
                                  isEnglish ? 'IDs' : 'بطاقات الهوية',
                                  'assets/id-card.png',
                                  widget.userId,
                                  widget.firstname,
                                  widget.lastname,
                                  isEnglish
                                ),
                                buildButton.buildbutton(
                                  context,
                                  'specialneeds',
                                  isEnglish ? 'Special Needs' : 'احتياجات خاصة',
                                  'assets/wheelchair.png',
                                  widget.userId,
                                  widget.firstname,
                                  widget.lastname,
                                  isEnglish
                                ),
                                buildButton.buildbutton(
                                  context,
                                  'driving',
                                  isEnglish ? 'Driving License' : 'رخصة قيادة',
                                  'assets/driving-license.png',
                                  widget.userId,
                                  widget.firstname,
                                  widget.lastname,
                                  isEnglish
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                buildButton.buildbutton(
                                  context,
                                  'passport',
                                  isEnglish ? 'Passports' : 'جوازات السفر',
                                  'assets/passport.png',
                                  widget.userId,
                                  widget.firstname,
                                  widget.lastname,
                                  isEnglish
                                ),

                                buildButton.buildbutton(
                                  context,
                                  'education',
                                  isEnglish ? 'Education' : 'تعليم',
                                  'assets/diploma.png',
                                  widget.userId,
                                  widget.firstname,
                                  widget.lastname,
                                  isEnglish
                                ),
                                buildButton.buildbutton(
                                  context,
                                  'orphan',
                                  isEnglish ? 'Orphanages' : 'دور الأيتام',
                                  'assets/orphans.png',
                                  widget.userId,
                                  widget.firstname,
                                  widget.lastname,
                                  isEnglish
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 160)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
