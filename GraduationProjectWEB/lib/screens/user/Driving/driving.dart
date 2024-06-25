import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:graduationprojectweb/widgets/BuildButton.dart';
import 'package:file_picker/file_picker.dart';

class driving extends StatefulWidget {
  driving({
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
  _drivingState createState() => _drivingState();
}

class _drivingState extends State<driving> {
  bool isEnglish = true;

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  @override
  void initState() {
    super.initState();
    isEnglish = widget.isEnglish;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(
        context,
        isEnglish ? 'Driving' : 'رخصة القيادة',
        widget.userId,
        widget.firstname,
        widget.lastname,
        isEnglish,
        _toggleLanguage,
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, left: 30, right: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.all(16.0),
                      borderOnForeground: true,
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/DrivingLicense.jpg', height: 400),
                            SizedBox(height: 30),
                            Text(
                              isEnglish
                                  ? 'To apply for a new driving license, renew your driving license, please select the appropriate option and provide the required information and documents.'
                                  : 'لتقديم طلب للحصول على رخصة قيادة جديدة، تجديد رخصة القيادة الخاصة بك، يرجى اختيار الخيار المناسب وتقديم المعلومات والمستندات المطلوبة.',
                              style: TextStyle(fontSize: 25, color: Colors.purple),
                              textAlign: isEnglish ? TextAlign.justify : TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40.0, left: 22),
                            child: Text(
                              isEnglish ? 'What would you like to do?' : 'ماذا ترغب أن تفعل؟',
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        buildButton.buildbutton(
                          context,
                          'newlicense',
                          isEnglish ? 'Get New Driving License' : 'اصدار رخصة قيادة لأول مرة',
                          'assets/driving-license.png',
                          widget.userId,
                          widget.firstname,
                          widget.lastname,
                          isEnglish,
                        ),
                        SizedBox(height: 20),
                        buildButton.buildbutton(
                          context,
                          'renewlicense',
                          isEnglish ? 'Renew Your Driving License' : 'تجديد رخصة قيادة',
                          'assets/renewal.png',
                          widget.userId,
                          widget.firstname,
                          widget.lastname,
                          isEnglish,
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
    );
  }
}
