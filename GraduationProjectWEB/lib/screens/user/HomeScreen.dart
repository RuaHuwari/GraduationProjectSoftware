import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/home.dart';
import 'package:graduationprojectweb/screens/profile/profile.dart';
import 'package:graduationprojectweb/widgets/List.dart';
import 'package:graduationprojectweb/widgets/BuildButton.dart';
import 'package:graduationprojectweb/widgets/NavBar.dart';
import 'package:graduationprojectweb/widgets/footer.dart';

class homescreen extends StatefulWidget {
  homescreen({required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  bool isEnglish = true;
  int _currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.8);

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

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _moveToNextPage() {
    if (_currentPage < 3) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else if (_currentPage == 3) {
      _pageController.animateToPage(
        _currentPage = 0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _moveToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else if (_currentPage == 0) {
      _pageController.animateToPage(
        _currentPage = 3,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          isEnglish ? 'Hi ' + widget.firstname + '!' : 'مرحبا ' + widget.firstname + '!',
          style: TextStyle(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSerif'),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.purple,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_rounded, color: Colors.white),
            onPressed: (){ Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfile(
                  userId: widget.userId,
                  firstname: widget.firstname,
                  lastname: widget.lastname,
                  isEnglish:isEnglish
              ),),
            );}
            ,
          ),
          IconButton(
            icon: Icon(Icons.language, color: Colors.white),
            onPressed: _toggleLanguage,
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: (){ Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => home()),
            );}
            ,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 20, bottom: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.deepPurple, size: 40,),
                  onPressed: _moveToPreviousPage,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: _onPageChanged,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            double scale = index == _currentPage ? 1.0 : 0;
                            return Transform.scale(
                              scale: scale,
                              child: List.buildList(
                                context,
                                _getCardText(index),
                                _getCardImage(index),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.deepPurple, size: 40,),
                  onPressed: _moveToNextPage,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildButton.buildbutton(context, 'services', isEnglish ? 'Services' : 'خدمات', 'assets/migration.png', widget.userId, widget.firstname, widget.lastname, isEnglish),
                      buildButton.buildbutton(context, 'applications', isEnglish ? 'Applications' : 'طلبات', 'assets/application.png', widget.userId, widget.firstname, widget.lastname, isEnglish),
                      buildButton.buildbutton(context, 'inbox', isEnglish ? 'Inbox' : 'صندوق الوارد', 'assets/inbox.png', widget.userId, widget.firstname, widget.lastname, isEnglish),
                    ],
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  String _getCardText(int index) {
    switch (index) {
      case 0:
        return isEnglish
            ? "Welcome to PalEase, where convenience meets accessibility in the realm of public services. Step into a world where essential tasks are streamlined, and your needs are prioritized. Whether it's enrolling in schools, managing official documents, or exploring educational avenues."
            : "مرحبًا بك في بال إيز، حيث تلتقي الراحة مع إمكانية الوصول في مجال الخدمات العامة. ادخل إلى عالم حيث يتم تبسيط المهام الأساسية ويتم إعطاء الأولوية لاحتياجاتك. سواء كان ذلك في التسجيل في المدارس أو إدارة الوثائق الرسمية أو استكشاف السبل التعليمية.";
      case 1:
        return isEnglish
            ? "Welcome to PalEase, your gateway to educational excellence. Explore schools, universities, and course materials effortlessly. Empower your academic journey with ease."
            : "مرحبًا بك في بال إيز، بوابتك نحو التميز التعليمي. استكشف المدارس والجامعات ومواد الدورة بسهولة. قم بتمكين رحلتك الأكاديمية بسهولة.";
      case 2:
        return isEnglish
            ? "With PalEase, you can now easily access, organize, and share your essential documents from anywhere. With our user-friendly interface, managing IDs, certificates, and permits is effortless. Experience document management in the palm of your hand."
            : "مع بال إيز، يمكنك الآن الوصول بسهولة إلى مستنداتك الأساسية وتنظيمها ومشاركتها من أي مكان. بفضل واجهتنا سهلة الاستخدام، تصبح إدارة الهوية والشهادات والتصاريح أمرًا سهلاً. تجربة إدارة المستندات في متناول يدك.";
      case 3:
        return isEnglish
            ? "Effortlessly keep track of your applied applications with our intuitive interface. Welcome to PalEase, where monitoring your application statuses and managing your submissions is a breeze. From job applications to permit requests, stay organized and informed every step of the way."
            : "تتبع بسهولة الطلبات المقدمة الخاصة بك باستخدام واجهتنا البديهية. مرحبًا بك في بال إيز، حيث يصبح تتبع حالة طلباتك وإدارة تقديماتك أمرًا سهلاً. من طلبات الوظائف إلى طلبات التصاريح، ابق منظمًا ومطلعًا في كل خطوة.";
      default:
        return "";
    }
  }

  String _getCardImage(int index) {
    switch (index) {
      case 0:
        return 'assets/welcomeicon.png';
      case 1:
        return 'assets/book.png';
      case 2:
        return 'assets/passport.png';
      case 3:
        return 'assets/application.png';
      default:
        return "";
    }
  }
}
