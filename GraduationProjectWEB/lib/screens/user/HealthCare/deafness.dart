import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/profile/profile.dart';
import 'package:graduationprojectweb/screens/user/Application/Application.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/CentersInfo.dart';
import 'package:graduationprojectweb/screens/user/HomeScreen.dart';
import 'package:graduationprojectweb/screens/user/Search.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';

class Deafness extends StatefulWidget {
  Deafness({required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  State<Deafness> createState() => _DeafnessState();
}

class _DeafnessState extends State<Deafness> {
  bool isEnglish = true;

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  String _getTranslatedText(String englishText, String arabicText) {
    return isEnglish ? englishText : arabicText;
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEnglish=widget.isEnglish;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(
        context,
        _getTranslatedText('Deafness', 'الصمم'),
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
              color: Colors.purple,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 50, right: 50),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _getTranslatedText(
                          'What should we do if we know someone with hearing disconvenious?',
                          'ماذا يجب أن نفعل إذا عرفنا شخصًا يعاني من ضعف السمع؟',
                        ),
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                    ),
                    // Image
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'assets/deafness.jpg',
                          height: 200,
                        ),
                      ),
                    ),
                    // Paragraphs of Information
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getTranslatedText('Deafness:', 'الصمم:'),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            _getTranslatedText(
                              "Deafness or hearing loss can present communication barriers, but with the right support and accommodations, individuals who are deaf or hard of hearing can thrive. Communication is key, and various methods, including sign language, lip-reading, and assistive devices, can facilitate interaction and understanding. Emphasizing inclusivity and providing access to resources and services tailored to the needs of the deaf community can promote equality and participation.",
                              "يمكن أن يشكل الصمم أو فقدان السمع حواجز في التواصل، ولكن مع الدعم والتسهيلات المناسبة، يمكن للأفراد الذين يعانون من الصمم أو ضعف السمع أن يزدهروا. التواصل هو المفتاح، ويمكن أن تسهل الطرق المختلفة، بما في ذلك لغة الإشارة، وقراءة الشفاه، والأجهزة المساعدة، التفاعل والفهم. إن التأكيد على الشمولية وتوفير الوصول إلى الموارد والخدمات المصممة لتلبية احتياجات مجتمع الصم يمكن أن يعزز المساواة والمشاركة.",
                            ),
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 16.0, fontFamily: 'SansSerif'),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            _getTranslatedText('General advice:', 'النصائح العامة:'),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            _getTranslatedText(
                              '-Offer sign language interpretation services and provide communication access in various settings.\n'
                                  '-Implement visual alerts and technologies like captioning and assistive listening devices.\n'
                                  '-Foster communication strategies that accommodate diverse needs and preferences.\n'
                                  '-Promote deaf culture and awareness to reduce stigma and promote inclusion.\n',
                              '-تقديم خدمات الترجمة بلغة الإشارة وتوفير الوصول إلى التواصل في مختلف البيئات.\n'
                                  '-تنفيذ التنبيهات البصرية والتقنيات مثل الترجمة النصية وأجهزة الاستماع المساعدة.\n'
                                  '-تعزيز استراتيجيات التواصل التي تلبي الاحتياجات والتفضيلات المتنوعة.\n'
                                  '-تعزيز ثقافة الصم والوعي لتقليل الوصمة وتعزيز الشمولية.\n',
                            ),
                            style: TextStyle(fontSize: 16.0, fontFamily: 'SansSerif'),
                          ),
                          SizedBox(height: 16.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CentersInfoPage(
                                      userId: widget.userId,
                                      firstname: widget.firstname,
                                      lastname: widget.lastname,
                                      id: '2', isEnglish: isEnglish,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _getTranslatedText('Browse Centers', 'تصفح المراكز'),
                                    style: TextStyle(color: Color.fromRGBO(76, 72, 157, 1)),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.chevron_right, color: Secondary),
                                ],
                              ),
                            ),
                          ),
                        ],
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
