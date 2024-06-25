import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/CentersInfo.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';

class Intellectual extends StatefulWidget {
  Intellectual({required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  State<Intellectual> createState() => _IntellectualState();
}

class _IntellectualState extends State<Intellectual> {
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
        _getTranslatedText('Intellectual Disability', 'الإعاقة الذهنية'),
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
                          'What should we do if we know someone with Intellectual Disability?',
                          'ماذا يجب أن نفعل إذا عرفنا شخصًا يعاني من إعاقة ذهنية؟',
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
                          'assets/Intellectualdisability.jpg',
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
                            _getTranslatedText('Intellectual Disability:', 'الإعاقة الذهنية:'),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            _getTranslatedText(
                              "Intellectual disability refers to limitations in intellectual functioning and adaptive behavior, which may impact learning, communication, and daily living skills. However, it's important to recognize the diverse strengths and abilities of individuals with intellectual disabilities and provide the necessary support and accommodations to help them succeed. Access to education, vocational training, social support, and community services can empower individuals with intellectual disabilities to lead fulfilling lives and contribute to society.",
                              "تشير الإعاقة الذهنية إلى قيود في الأداء الفكري والسلوك التكيفي، مما قد يؤثر على التعلم، والتواصل، ومهارات الحياة اليومية. ومع ذلك، من المهم التعرف على القدرات والقوى المتنوعة للأفراد ذوي الإعاقة الذهنية وتوفير الدعم والتسهيلات اللازمة لمساعدتهم على النجاح. يمكن أن يساهم الوصول إلى التعليم، والتدريب المهني، والدعم الاجتماعي، والخدمات المجتمعية في تمكين الأفراد ذوي الإعاقة الذهنية من العيش حياة ممتلئة والمساهمة في المجتمع.",
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
                              "-Provide individualized support and accommodations based on each person's strengths and needs.\n"
                                  '-Offer inclusive educational programs and vocational training opportunities.\n'
                                  '-Foster social inclusion and peer support networks to promote friendship and belonging.\n'
                                  '-Advocate for policies and practices that promote the rights and inclusion of individuals with intellectual disabilities.\n',
                              "-تقديم الدعم والتسهيلات الفردية بناءً على نقاط القوة والاحتياجات لكل شخص.\n"
                                  '-تقديم برامج تعليمية شاملة وفرص تدريب مهني.\n'
                                  '-تعزيز الشمول الاجتماعي وشبكات دعم الأقران لتعزيز الصداقة والانتماء.\n'
                                  '-الدعوة إلى السياسات والممارسات التي تعزز حقوق ودمج الأفراد ذوي الإعاقة الذهنية.\n',
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
                                      id: '4', isEnglish: isEnglish,
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
