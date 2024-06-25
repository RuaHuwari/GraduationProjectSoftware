import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/CentersInfo.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';

class Mental extends StatefulWidget {
  Mental({required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  State<Mental> createState() => _MentalState();
}

class _MentalState extends State<Mental> {
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
        _getTranslatedText('Mental Health and Emotional Well-being', 'الصحة النفسية والرفاهية العاطفية'),
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
                          'What should we do if we know someone with Mental Health or emotional issues?',
                          'ماذا يجب أن نفعل إذا عرفنا شخصًا يعاني من مشاكل الصحة النفسية أو العاطفية؟',
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
                        child: Image.asset('assets/mentalhealth.png', height: 200),
                      ),
                    ),
                    // Paragraphs of Information
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getTranslatedText('Mental Health and Emotional Well-being', 'الصحة النفسية والرفاهية العاطفية'),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            _getTranslatedText(
                              "Mental health conditions, such as depression, anxiety disorders, bipolar disorder, and schizophrenia, as well as emotional challenges, are prevalent and can significantly impact an individual's well-being and quality of life. It's crucial to recognize the importance of mental health and provide access to comprehensive support and treatment services. With early intervention, therapy, medication management, and community support, individuals experiencing mental health challenges can achieve recovery, resilience, and overall well-being.",
                              "تعتبر حالات الصحة النفسية، مثل الاكتئاب، واضطرابات القلق، واضطراب ثنائي القطب، والفصام، وكذلك التحديات العاطفية، شائعة ويمكن أن تؤثر بشكل كبير على رفاهية الفرد وجودة حياته. من الضروري الاعتراف بأهمية الصحة النفسية وتوفير الوصول إلى الدعم والخدمات العلاجية الشاملة. من خلال التدخل المبكر، والعلاج، وإدارة الأدوية، والدعم المجتمعي، يمكن للأفراد الذين يعانون من تحديات الصحة النفسية تحقيق التعافي والمرونة والرفاهية الشاملة.",
                            ),
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 16.0, fontFamily: 'SansSerif'),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            _getTranslatedText('General advice:', 'نصائح عامة:'),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            _getTranslatedText(
                              "-Promote mental health awareness and reduce stigma through education and advocacy efforts.\n"
                                  '-Provide access to counseling, therapy, and psychiatric services for assessment and treatment.\n'
                                  '-Foster supportive communities and peer support networks for individuals experiencing mental health challenges.\n'
                                  '-Encourage self-care practices, stress management techniques, and healthy coping strategies to promote emotional well-being.\n',
                              "-تعزيز الوعي بالصحة النفسية وتقليل الوصمة من خلال الجهود التعليمية والدعوة.\n"
                                  '-توفير الوصول إلى خدمات الاستشارة والعلاج النفسي والخدمات النفسية لتقييم العلاج.\n'
                                  '-تعزيز المجتمعات الداعمة وشبكات الدعم بين الأقران للأفراد الذين يواجهون تحديات الصحة النفسية.\n'
                                  '-تشجيع ممارسات العناية الذاتية وتقنيات إدارة التوتر واستراتيجيات التأقلم الصحية لتعزيز الرفاهية العاطفية.\n',
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
                                      id: '6', isEnglish: isEnglish,
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
