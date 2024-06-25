import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/CentersInfo.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart'; // Alias to avoid conflicts with AppBar class

class Blindness extends StatefulWidget {
  Blindness({
    required this.userId,
    required this.firstname,
    required this.lastname, required this.isEnglish,

  });
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  State<Blindness> createState() => _BlindnessState();
}

class _BlindnessState extends State<Blindness> {
  bool isEnglish = true;

  // Method to toggle language
  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  // Method to get translated text based on language
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
        _getTranslatedText('Blindness', 'العمى'),
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
            padding: const EdgeInsets.only(top: 30.0, right: 50, left: 50),
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
                          'What should we do if we know someone with sight disconvenious?',
                          'ماذا يجب أن نفعل إذا عرفنا شخصًا يعاني من إعاقة بصرية؟',
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
                          'assets/blindness.jpg',
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
                            _getTranslatedText('Blindness:', 'العمى:'),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            _getTranslatedText(
                                "Living with blindness or low vision presents unique challenges, but it's essential to recognize that individuals with visual impairments lead fulfilling and independent lives. While navigating the world without sight may require adaptations and support, it's important to foster an environment of accessibility and inclusion. Access to education, assistive technology, orientation and mobility training, and support networks can empower individuals who are blind or have low vision to achieve their goals and participate fully in society.",
                                "العيش مع العمى أو الرؤية المنخفضة يشكل تحديات فريدة، لكن من الضروري الاعتراف بأن الأفراد الذين يعانون من إعاقات بصرية يعيشون حياة مليئة ومستقلة. بينما قد تتطلب التنقل في العالم بدون رؤية تكيفات ودعمًا، من المهم تعزيز بيئة الإمكانية والاندماج. يمكن للوصول إلى التعليم والتكنولوجيا المساعدة والتدريب على التوجيه والتنقل وشبكات الدعم أن تمكّن الأفراد الذين يعانون من العمى أو الرؤية المنخفضة من تحقيق أهدافهم والمشاركة بشكل كامل في المجتمع."
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
                              '-Ensure environments are accessible with features such as tactile paving, braille signage, and audible signals.\n'
                                  '-Offer training in assistive technology and orientation and mobility skills to enhance independence.\n'
                                  '-Encourage the use of alternative formats for information, such as braille or audio recordings.\n'
                                  '-Foster a culture of inclusion by promoting awareness and understanding of blindness and visual impairments.\n',
                              '-تأكد من أن البيئات متاحة بميزات مثل ترصيف لمس الأرضية وعلامات برايل وإشارات سمعية.\n'
                                  '-قدم تدريبًا في التكنولوجيا المساعدة ومهارات التوجيه والتنقل لتعزيز الاستقلالية.\n'
                                  '-شجع على استخدام صيغ بديلة للمعلومات، مثل البرايل أو التسجيلات الصوتية.\n'
                                  '-تعزيز ثقافة الاندماج من خلال تعزيز الوعي والفهم حول العمى والإعاقات البصرية',
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
                                      id: '1', isEnglish: isEnglish,
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
