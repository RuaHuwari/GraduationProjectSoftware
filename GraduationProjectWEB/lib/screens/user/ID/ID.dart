import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:graduationprojectweb/widgets/BuildButton.dart';

class ID extends StatefulWidget {
  ID({required this.userId, required this.firstname, required this.lastname, required this.isEnglish});

  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  _IDState createState() => _IDState();
}

class _IDState extends State<ID> {
  bool isEnglish = true;

  @override
  void initState() {
    super.initState();
    isEnglish = widget.isEnglish;
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
        isEnglish ? 'IDs' : 'الهويات',
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
                            Image.asset('assets/ID.jpg',height: 400,),
                            SizedBox(height: 30),
                            Text(
                              isEnglish
                                  ? 'To apply for a new ID, report a lost ID, or renew your ID, please select the appropriate option and provide the required information and documents.'
                                  : 'لتقديم طلب للحصول على هوية جديدة، الإبلاغ عن هوية مفقودة، أو تجديد هويتك، يرجى اختيار الخيار المناسب وتقديم المعلومات والمستندات المطلوبة.',
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
                        buildButton.buildbutton(
                          context,
                          'newID',
                          isEnglish ? 'Get New ID' : 'الحصول على هوية جديدة',
                          'assets/document.png',
                          widget.userId,
                          widget.firstname,
                          widget.lastname,
                          isEnglish,
                        ),
                        SizedBox(height: 20),
                        buildButton.buildbutton(
                          context,
                          'lostID',
                          isEnglish ? 'Lost ID' : 'بدل فاقد',
                          'assets/data-loss.png',
                          widget.userId,
                          widget.firstname,
                          widget.lastname,
                          isEnglish,
                        ),
                        SizedBox(height: 20),
                        buildButton.buildbutton(
                          context,
                          'renewID',
                          isEnglish ? 'Renew ID' : 'تجديد هوية',
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
