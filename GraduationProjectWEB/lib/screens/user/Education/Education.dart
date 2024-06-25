import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:graduationprojectweb/widgets/BuildButton.dart';

class Education extends StatefulWidget {
  Education({
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
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
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
        isEnglish ? 'Education' : 'التعليم',
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
                            Image.asset('assets/Education.png', height: 400),
                            SizedBox(height: 30),
                            Text(
                              isEnglish
                                  ? 'Explore educational institutions, including schools and universities. Select the appropriate option to get more information and resources.'
                                  : 'استكشف المؤسسات التعليمية، بما في ذلك المدارس والجامعات. اختر الخيار المناسب للحصول على مزيد من المعلومات والموارد.',
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
                              isEnglish ? 'What would you like to explore?' : 'ماذا ترغب في استكشافه؟',
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
                          'school',
                          isEnglish ? 'Schools' : 'المدارس',
                          'assets/campus.png',
                          widget.userId,
                          widget.firstname,
                          widget.lastname,
                          isEnglish,
                        ),
                        SizedBox(height: 20),
                        buildButton.buildbutton(
                          context,
                          'university',
                          isEnglish ? 'Universities' : 'الجامعات',
                          'assets/university.png',
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
