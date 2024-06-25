import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:graduationprojectweb/widgets/BuildButton.dart';

class Passport extends StatefulWidget {
  Passport({
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
  _PassportState createState() => _PassportState();
}

class _PassportState extends State<Passport> {
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
        isEnglish ? 'Passport' : 'جواز السفر',
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
                            Image.asset('assets/Passport.jpg', height: 400),
                            SizedBox(height: 30),
                            Text(
                              isEnglish
                                  ? 'To apply for a new passport, report a lost passport, or renew your passport, please select the appropriate option and provide the required information and documents.'
                                  : 'لتقديم طلب للحصول على جواز سفر جديد، الإبلاغ عن جواز سفر مفقود، أو تجديد جواز سفرك، يرجى اختيار الخيار المناسب وتقديم المعلومات والمستندات المطلوبة.',
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
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        buildButton.buildbutton(
                          context,
                          'newPassport',
                          isEnglish ? 'Get New Passport' : 'اصدار جواز سفر جديد',
                          'assets/document.png',
                          widget.userId,
                          widget.firstname,
                          widget.lastname,
                          isEnglish,
                        ),
                        SizedBox(height: 20),
                        buildButton.buildbutton(
                          context,
                          'renewPassport',
                          isEnglish ? 'Renew Passport' : 'تجديد جواز سفر',
                          'assets/renewal.png',
                          widget.userId,
                          widget.firstname,
                          widget.lastname,
                          isEnglish,
                        ),
                        SizedBox(height: 20),
                        buildButton.buildbutton(
                          context,
                          'lostPassport',
                          isEnglish ? 'Lost Passport' : 'اصدار بدل فاقد',
                          'assets/data-loss.png',
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
