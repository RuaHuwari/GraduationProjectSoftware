import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/profile/profile.dart';
import 'package:graduationprojectweb/screens/user/Application/Application.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/CentersInfo.dart';
import 'package:graduationprojectweb/screens/user/HomeScreen.dart';
import 'package:graduationprojectweb/screens/user/Search.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';

class Chronic extends StatefulWidget {
  Chronic({required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  State<Chronic> createState() => _ChronicState();
}

class _ChronicState extends State<Chronic> {
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
        _getTranslatedText('Chronic Illness', 'الأمراض المزمنة'),
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
                          'What should we do if we know someone with Chronic Illness?',
                          'ماذا يجب أن نفعل إذا عرفنا شخصًا يعاني من مرض مزمن؟',
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
                          'assets/ChronicIllnessandPhysicalHealth.jpg',
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
                            _getTranslatedText(
                              'Chronic Illness and Physical Health Needs:',
                              'الأمراض المزمنة واحتياجات الصحة البدنية:',
                            ),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            _getTranslatedText(
                              "Chronic illnesses, such as diabetes, epilepsy, asthma, and other physical health conditions, require ongoing management and support to maintain health and well-being. Individuals with chronic illnesses may face various challenges, including medication management, symptom control, and lifestyle adjustments. Providing access to medical care, treatment, education, and support services can help individuals with chronic illnesses effectively manage their condition and improve their quality of life.",
                              "تتطلب الأمراض المزمنة، مثل السكري والصرع والربو وغيرها من الحالات الصحية البدنية، إدارة مستمرة ودعمًا للحفاظ على الصحة والرفاهية. قد يواجه الأفراد المصابون بأمراض مزمنة تحديات مختلفة، بما في ذلك إدارة الأدوية والسيطرة على الأعراض وتعديلات نمط الحياة. يمكن أن يساعد توفير الوصول إلى الرعاية الطبية والعلاج والتعليم وخدمات الدعم الأفراد المصابين بأمراض مزمنة على إدارة حالتهم بشكل فعال وتحسين نوعية حياتهم.",
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
                              "-Offer comprehensive medical care and treatment services tailored to each individual's specific health needs.\n"
                                  '-Provide education and resources to promote disease management, medication adherence, and lifestyle modifications.\n'
                                  '-Foster peer support networks and community resources for individuals with chronic illnesses to share experiences and receive emotional support.\n'
                                  '-Advocate for policies and practices that promote accessibility, affordability, and quality of care for individuals with chronic illnesses.\n',
                              "-قدم رعاية طبية شاملة وخدمات علاجية مصممة لتلبية الاحتياجات الصحية المحددة لكل فرد.\n"
                                  '-قدم التعليم والموارد لتعزيز إدارة الأمراض والالتزام بالأدوية وتعديلات نمط الحياة.\n'
                                  '-تعزيز شبكات دعم الأقران والموارد المجتمعية للأفراد المصابين بأمراض مزمنة لمشاركة التجارب والحصول على الدعم العاطفي.\n'
                                  '-الدعوة إلى السياسات والممارسات التي تعزز الوصول إلى الرعاية والجودة والقدرة على تحمل التكاليف للأفراد المصابين بأمراض مزمنة.\n',
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
                                      id: '8', isEnglish: isEnglish,
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
