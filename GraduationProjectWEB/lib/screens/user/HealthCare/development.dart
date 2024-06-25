import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/profile/profile.dart';
import 'package:graduationprojectweb/screens/user/Application/Application.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/CentersInfo.dart';
import 'package:graduationprojectweb/screens/user/HomeScreen.dart';
import 'package:graduationprojectweb/screens/user/Search.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';

class Development extends StatefulWidget {
  Development({required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  State<Development> createState() => _DevelopmentState();
}

class _DevelopmentState extends State<Development> {
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
        _getTranslatedText('Development and Behavioral Disorder', 'اضطرابات النمو والسلوك'),
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
                          'What should we do if we know someone with Development and Behavioral Disorder?',
                          'ماذا يجب أن نفعل إذا عرفنا شخصًا يعاني من اضطرابات النمو والسلوك؟',
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
                          'assets/Emotional-and-Behavioral-Disorder-in-Children.jpg',
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
                            _getTranslatedText('Development and Behavioral Disorder:', 'اضطرابات النمو والسلوك:'),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            _getTranslatedText(
                              "Developmental and behavioral disorders, such as autism spectrum disorder (ASD), ADHD, and conduct disorder, can present unique challenges in social interaction, communication, and behavior regulation. However, individuals with these disorders also possess distinct strengths and talents. With early intervention, specialized therapies, and supportive environments, individuals with developmental and behavioral disorders can learn to manage their symptoms and thrive. Embracing neurodiversity and providing inclusive support systems are essential for promoting acceptance and understanding.",
                              "تقدم اضطرابات النمو والسلوك، مثل اضطراب طيف التوحد (ASD)، واضطراب نقص الانتباه وفرط النشاط (ADHD)، واضطراب السلوك، تحديات فريدة في التفاعل الاجتماعي، والتواصل، وتنظيم السلوك. ومع ذلك، يتمتع الأفراد الذين يعانون من هذه الاضطرابات بقوى ومواهب مميزة. من خلال التدخل المبكر، والعلاجات المتخصصة، والبيئات الداعمة، يمكن للأفراد الذين يعانون من اضطرابات النمو والسلوك تعلم إدارة أعراضهم والازدهار. إن احتضان التنوع العصبي وتوفير أنظمة دعم شاملة أمران أساسيان لتعزيز القبول والفهم.",
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
                              "-Offer early intervention programs and specialized therapies tailored to each individual's needs.\n"
                                  '-Provide behavior management strategies and social skills training to promote positive interactions.\n'
                                  '-Create sensory-friendly environments that accommodate sensory sensitivities and reduce sensory overload.\n'
                                  '-Foster a culture of acceptance and inclusion to celebrate the strengths and talents of individuals with developmental and behavioral disorders.\n',
                              "-تقديم برامج التدخل المبكر والعلاجات المتخصصة المصممة لتلبية احتياجات كل فرد.\n"
                                  '-توفير استراتيجيات إدارة السلوك وتدريب المهارات الاجتماعية لتعزيز التفاعلات الإيجابية.\n'
                                  '-خلق بيئات ملائمة للحواس تستوعب الحساسيات الحسية وتقلل من التحميل الحسي.\n'
                                  '-تعزيز ثقافة القبول والشمولية للاحتفال بقوى ومواهب الأفراد الذين يعانون من اضطرابات النمو والسلوك.\n',
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
                                      id: '5', isEnglish: isEnglish,
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
