import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/CentersInfo.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';

class Physical extends StatefulWidget {
  Physical({required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  State<Physical> createState() => _PhysicalState();
}

class _PhysicalState extends State<Physical> {
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
        _getTranslatedText('Physical Disability', 'الإعاقة الجسدية'),
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
                          'What should we do if we know someone with Physical Disability?',
                          'ماذا يجب أن نفعل إذا عرفنا شخصًا يعاني من إعاقة جسدية؟',
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
                        child: Image.asset('assets/physicaldisability.jpg', height: 200),
                      ),
                    ),
                    // Paragraphs of Information
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getTranslatedText('Physical Disability:', 'الإعاقة الجسدية:'),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            _getTranslatedText(
                              " Physical disabilities encompass a wide range of conditions that affect mobility, dexterity, and physical functioning. While individuals with physical disabilities may face obstacles in navigating their environment, they possess unique strengths and abilities. Access to adaptive equipment, assistive technology, physical therapy, and accessible environments can empower individuals with physical disabilities to live independently and participate actively in their communities.",
                              "تشمل الإعاقات الجسدية مجموعة واسعة من الحالات التي تؤثر على الحركة والبراعة والأداء البدني. في حين قد يواجه الأفراد ذوو الإعاقات الجسدية عقبات في التنقل في بيئتهم، فإن لديهم نقاط قوة وقدرات فريدة. يمكن أن يتيح الوصول إلى المعدات التكيفية والتكنولوجيا المساعدة والعلاج الطبيعي والبيئات التي يمكن الوصول إليها للأفراد ذوي الإعاقات الجسدية العيش بشكل مستقل والمشاركة بنشاط في مجتمعاتهم.",
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
                              '-Ensure buildings and public spaces are wheelchair accessible with ramps, elevators, and wide doorways\n'
                                  '-Provide adaptive equipment and assistive devices to support daily activities and mobility.\n'
                                  '-Offer physical therapy and rehabilitation services to optimize function and mobility.\n'
                                  '-Promote universal design principles to create environments that are accessible to all.\n',
                              '-تأكد من أن المباني والمساحات العامة يمكن الوصول إليها بواسطة الكراسي المتحركة مع المنحدرات والمصاعد والأبواب الواسعة.\n'
                                  '-توفير المعدات التكيفية والأجهزة المساعدة لدعم الأنشطة اليومية والتنقل.\n'
                                  '-تقديم خدمات العلاج الطبيعي وإعادة التأهيل لتحسين الوظيفة والتنقل.\n'
                                  '-تعزيز مبادئ التصميم العالمي لخلق بيئات يمكن الوصول إليها للجميع.\n',
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
                                      id: '3', isEnglish: isEnglish,
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
