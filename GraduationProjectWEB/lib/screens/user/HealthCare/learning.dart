import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/CentersInfo.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';

class Learning extends StatefulWidget {
  Learning({required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  State<Learning> createState() => _LearningState();
}

class _LearningState extends State<Learning> {
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
        _getTranslatedText('Learning And Communication Support', 'دعم التعلم والتواصل'),
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
                          'What should we do if we know someone with Communication Problems?',
                          'ماذا يجب أن نفعل إذا عرفنا شخصًا يعاني من مشاكل في التواصل؟',
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
                          'assets/LearningandCommunicationSupportjpg.jpg',
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
                            _getTranslatedText('Learning and Communication Support:', 'دعم التعلم والتواصل:'),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            _getTranslatedText(
                              "Learning disabilities, communication disorders, and speech and language difficulties can pose significant challenges in academic achievement, social interaction, and daily communication. However, with the right support and accommodations, individuals with these needs can succeed academically and thrive in their personal and professional lives. Providing specialized educational programs, speech therapy, assistive technology, and inclusive learning environments can empower individuals with learning and communication needs to reach their full potential and participate fully in society.",
                              "يمكن أن تشكل صعوبات التعلم واضطرابات التواصل وصعوبات النطق واللغة تحديات كبيرة في التحصيل الأكاديمي والتفاعل الاجتماعي والتواصل اليومي. ومع ذلك، مع الدعم والتسهيلات المناسبة، يمكن للأفراد الذين يعانون من هذه الاحتياجات أن ينجحوا أكاديميًا ويزدهروا في حياتهم الشخصية والمهنية. يمكن أن يؤدي توفير البرامج التعليمية المتخصصة، والعلاج النطقي، والتكنولوجيا المساعدة، وبيئات التعلم الشاملة إلى تمكين الأفراد ذوي احتياجات التعلم والتواصل من تحقيق إمكاناتهم الكاملة والمشاركة بشكل كامل في المجتمع.",
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
                              "-Offer individualized education plans (IEPs) and accommodations tailored to each student's learning and communication needs.\n"
                                  '-Provide speech therapy and language intervention services to improve communication skills and overcome challenges.\n'
                                  '-Utilize assistive technology tools and resources to support learning and communication, such as text-to-speech software and augmentative and alternative communication (AAC) devices.\n'
                                  '-Foster inclusive classrooms and environments that celebrate diversity and accommodate different learning styles and communication preferences.\n',
                              "-تقديم خطط التعليم الفردية (IEPs) والتسهيلات التي تناسب احتياجات التعلم والتواصل لكل طالب.\n"
                                  '-توفير خدمات العلاج النطقي والتدخل اللغوي لتحسين مهارات التواصل والتغلب على التحديات.\n'
                                  '-استخدام أدوات وموارد التكنولوجيا المساعدة لدعم التعلم والتواصل، مثل برامج النص إلى كلام وأجهزة التواصل المعزز والبديل (AAC).\n'
                                  '-تعزيز الفصول الدراسية الشاملة والبيئات التي تحتفل بالتنوع وتستوعب أساليب التعلم المختلفة وتفضيلات التواصل.\n',
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
                                      id: '7', isEnglish: isEnglish,
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
