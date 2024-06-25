import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/user/Driving/licenseform.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';

class Newlicense extends StatefulWidget {
  Newlicense({ required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;
  @override
  _newlicensePageState createState() => _newlicensePageState();
}

class _newlicensePageState extends State<Newlicense> {
  int _selectedOption = 0;

  void _handleRadioValueChanged(int value) {
    setState(() {
      _selectedOption = value;
    });
  }

  void _navigateToForm(BuildContext context) {
    switch (_selectedOption) {
      case 0:
      // Navigate to Form A
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Tractor(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname, isEnglish: isEnglish,)),
        );
        break;
      case 1:
      // Navigate to Form B
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PrivateCar(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname,isEnglish:isEnglish)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>CommercialC1(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname, isEnglish: isEnglish,)),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>CommercialC(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname, isEnglish: isEnglish,)),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>trailer(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname, isEnglish: isEnglish,)),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Taxi(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname, isEnglish: isEnglish,)),
        );
        break;
      case 6:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Bus(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname, isEnglish: isEnglish,)),
        );
        break;
      case 7:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Firetruck(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname, isEnglish: isEnglish,)),
        );
        break;
      case 8:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>motorbikeA1(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname, isEnglish: isEnglish,)),
        );
        break;
      case 9:
        Navigator.push(context, MaterialPageRoute(builder: (context)=>motorbikeA(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname, isEnglish: isEnglish,)),
        );
        break;
    // Add more cases for additional options
    }
  }
  bool isEnglish = true;

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
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
      appBar: buildabbbar.buildAbbbar(context,  'Get New License', widget.userId, widget.firstname, widget.lastname,isEnglish,_toggleLanguage),

      body: Stack(
        children:[
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: const BoxDecoration(
              color: Colors.purple
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0,left:50,right:50),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
            child: Padding(
              padding: const EdgeInsets.only(left:30.0,top:10),
              child: Column(
                children: <Widget>[
                  Text(isEnglish?'Choose the license degree you want:':'إختر درجة الرخصة التي ترغب بالجصول عليها',style: TextStyle(
                    color: primary,
                    fontFamily: 'SansSerif',
                    fontSize: 25,

                    fontWeight: FontWeight.bold,
                  ),),
                  ListTile(
                    title: Text(isEnglish?'01 truck license':'رخصة تركتور'),
                    leading: Radio(
                      value: 0,
                      groupValue: _selectedOption,
                      onChanged: (value){
                        _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(isEnglish?'B private car':'مركبة خاصة'),
                    leading: Radio(
                      value: 1,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(isEnglish?'C1 Commercial driving license till 15 Tons':'رخصة قيادة تجارية حتى 15 طن'),
                    leading: Radio(
                      value: 2,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(isEnglish?'C Van driving license (Above 15 Tons)':'رخصة قيادة شاحنة اكثر من 15 طن'),

                    leading: Radio(
                      value: 3,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(isEnglish?'E trailer license':'رخصة قيادة مقطورة'),
                    leading: Radio(
                      value: 4,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(isEnglish?'D1 Taxi driving license':'رخصة قيادة سيارة اجرة'),
                    leading: Radio(
                      value: 5,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(isEnglish?'D Bus driving license':'رخصة قياد باص'),
                    leading: Radio(
                      value: 6,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(isEnglish?'Fire Truck driving license':'رخصة قيادة شاحنة اطفاء'),
                    leading: Radio(
                      value: 7,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(isEnglish?'A1 Motor Bike Driving license till 500cm3':'رخصة قيادة دراجة حتى 500سم3'),
                    leading: Radio(
                      value: 8,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(isEnglish?'A Motor Bike Driving licnese above 500cm3':'رخصة قيادة دراجة اكثر من 500سم3'),
                    leading: Radio(
                      value: 9,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  // Add more ListTiles for additional options
                  Center(
                    child:  ElevatedButton(
                      onPressed: () {
                        _navigateToForm(context);
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
                            isEnglish?'apply for license':'التديم على الرخصة',
                            style: TextStyle(color: primary,fontSize: 30),
                          ),
                          SizedBox(width: 15),
                          Icon(Icons.chevron_right, color: Secondary,size: 40,),
                        ],
                      ),
                    ),)
                ],
              ),
            ),
                    ),
          ),
        ]
      ),
    );
  }
}

// Define FormA widget
class Tractor extends StatefulWidget {
  Tractor({required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;
  @override
  State<Tractor> createState() => _TractorState();
}

class _TractorState extends State<Tractor> {
  bool isEnglish = true;

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
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
        appBar: buildabbbar.buildAbbbar(context,  isEnglish?'Tractor License / Grade (01) Tractor Driving License:':'اصدار رخصة قيادة تركتور' , widget.userId, widget.firstname, widget.lastname,isEnglish,_toggleLanguage),

      body: Stack(
        children: [
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: const BoxDecoration(
             color: Colors.purple
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0,left:50,right:50),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Padding(
                padding: const EdgeInsets.only(top:8.0,left:30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isEnglish?'1- The age should not be less than 16 years.':'أولا:العمر يجب ألا يقل عن 16 عامًا.',style: TextStyle(fontSize: 25),),
                    Text(isEnglish?'2- Fill out the application form.':'ثانيا: قم بتعبئة نموذج التقديم',style: TextStyle(fontSize: 25),),
                    Text(isEnglish?'3- Undergo a medical examination.':'ثالثا: اخضع للفحص الطبي',style:TextStyle(fontSize: 25)),
                    Text(isEnglish?'4- Completion of a course from a tractor school accredited by the Ministry of Transportation.':'رابعا: قم بانهاء تدريب من مدرسة مختصة برخص سواقة التركتورات',style: TextStyle(fontSize: 25),),
                    Text(isEnglish?'5- Undergo a practical driving test.':'خامسا: اخضع للفحص العملي للقيادة',style:TextStyle(fontSize: 25)),
                    Text(isEnglish?'6- Payment of the required fees.':'سادسا: سيكون عليك دفع رسوم الرخصة',style:TextStyle(fontSize: 25)),

                    Center(
                      child:  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context as BuildContext,
                          MaterialPageRoute(builder: (context)=>licenseform(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname,i:1, isEnglish: isEnglish,)),
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
                            isEnglish?'Get Started':'ابدا التقديم',
                            style: TextStyle(color: primary,fontSize: 30),
                          ),
                          SizedBox(width: 15),
                          Icon(Icons.chevron_right, color: Secondary,size: 40,),
                        ],
                      ),
                    ),)
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
// Define FormB widget
class PrivateCar extends StatefulWidget {
  PrivateCar({required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;
  @override
  State<PrivateCar> createState() => _PrivateCarState();
}

class _PrivateCarState extends State<PrivateCar> {
  bool isEnglish = true;

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEnglish = widget.isEnglish;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(
          context,
          isEnglish ? 'Private Driving License / Grade (02) Private:' : 'إصدار رخصة قيادة سيارة خاصة',
          widget.userId,
          widget.firstname,
          widget.lastname,
          isEnglish,
          _toggleLanguage
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.purple),
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
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEnglish
                          ? '1- The age should not be less than 17 years for learning, and undergo tests and reserve the license until reaching 17.5 years after approval by the department director according to the system.'
                          : 'أولا: العمر يجب ألا يقل عن 17 عامًا للتعلم، واجتياز الاختبارات وحجز الرخصة حتى بلوغ 17.5 عامًا بعد الموافقة من مدير القسم وفقًا للنظام.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish ? '2- Fill out the application form.' : 'ثانيا: قم بتعبئة نموذج التقديم.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish ? '3- Undergo a medical examination.' : 'ثالثا: اخضع للفحص الطبي.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish ? '4- Attend the traffic signs exam.' : 'رابعا: احضر امتحان إشارات المرور.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish ? '5- Attend the practical driving exam.' : 'خامسا: احضر امتحان القيادة العملي.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish ? '6- Payment of the required fees.' : 'سادسا: سدد الرسوم المطلوبة.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => licenseform(
                                userId: widget.userId,
                                firstname: widget.firstname,
                                lastname: widget.lastname,
                                i: 2, isEnglish: isEnglish,
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
                              isEnglish ? 'Get Started' : 'ابدأ التقديم',
                              style: TextStyle(color: primary, fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary, size: 40),
                          ],
                        ),
                      ),
                    )
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

// Define FormB widget
class CommercialC1 extends StatefulWidget {
  CommercialC1({required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;
  @override
  State<CommercialC1> createState() => _CommercialC1State();
}

class _CommercialC1State extends State<CommercialC1> {
  bool isEnglish = true;

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
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
          isEnglish ? 'Commercial Driving License / Grade (03) Commercial up to 15 tons:' : 'إصدار رخصة قيادة تجارية / الدرجة (03) تجارية حتى 15 طن:',
          widget.userId,
          widget.firstname,
          widget.lastname,
          isEnglish,
          _toggleLanguage
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.purple),
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
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEnglish
                          ? "1- The applicant's age should not be less than (18) years."
                          : 'أولا: يجب ألا يقل عمر المتقدم عن 18 عامًا.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '2- Medical examination from the medical institution to prevent road accidents for the required grade.'
                          : 'ثانيا: إجراء الفحص الطبي من المؤسسة الطبية لمنع حوادث الطرق للدرجة المطلوبة.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '3- Fill out the traffic signs form.'
                          : 'ثالثا: قم بتعبئة نموذج إشارات المرور.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '4- Attend the traffic signs exam.'
                          : 'رابعا: حضور امتحان إشارات المرور.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '5- Attend the practical driving test.'
                          : 'خامسا: حضور اختبار القيادة العملي.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '6- Payment of the required fees.'
                          : 'سادسا: دفع الرسوم المطلوبة.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => licenseform(
                                userId: widget.userId,
                                firstname: widget.firstname,
                                lastname: widget.lastname,
                                i: 3, isEnglish: isEnglish,
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
                              isEnglish ? 'Get Started' : 'ابدأ التقديم',
                              style: TextStyle(color: primary, fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary, size: 40),
                          ],
                        ),
                      ),
                    )
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

// Define FormB widget
class CommercialC extends StatefulWidget {
  CommercialC({required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;
  @override
  State<CommercialC> createState() => _CommercialCState();
}

class _CommercialCState extends State<CommercialC> {
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
          isEnglish
              ? 'Heavy Vehicle Driving License (Grade 13) - Cargo over 15 tons / Heavy Vehicle Ownership License:'
              : 'رخصة قيادة مركبة ثقيلة (الدرجة 13) - الشحن لأكثر من 15 طن / رخصة ملكية مركبة ثقيلة:',
          widget.userId,
          widget.firstname,
          widget.lastname,
          isEnglish,
          _toggleLanguage
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.purple),
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
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEnglish
                          ? '1- The applicant age should not be less than 19 years.'
                          : 'أولا: يجب ألا يقل عمر المتقدم عن 19 عامًا.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '2- One year experience on a cargo license up to 15 tons (03).'
                          : 'ثانيا: خبرة سنة واحدة على رخصة شحن تصل إلى 15 طن (03).',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '3- Certificate of heavy cargo course from an accredited institute licensed by the Ministry of Transportation.'
                          : 'ثالثا: شهادة دورة الشحن الثقيل من معهد معتمد مرخص من قبل وزارة النقل.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '4- Medical examination from the medical institution to prevent road accidents for the required grade.'
                          : 'رابعا: الفحص الطبي من المؤسسة الطبية لمنع حوادث الطرق للدرجة المطلوبة.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '5- Theoretical signals exam.'
                          : 'خامسا: امتحان الإشارات النظري.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '6- Attend the practical driving test.'
                          : 'سادسا: حضور اختبار القيادة العملي.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '7- Payment of the required fees.'
                          : 'سابعا: دفع الرسوم المطلوبة.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => licenseform(
                                userId: widget.userId,
                                firstname: widget.firstname,
                                lastname: widget.lastname,
                                i: 4, isEnglish: isEnglish,
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
                              isEnglish ? 'Get Started' : 'ابدأ التقديم',
                              style: TextStyle(color: primary, fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary, size: 40),
                          ],
                        ),
                      ),
                    )
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

// Define FormB widget
class trailer extends StatefulWidget {
  trailer({ required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;
  @override
  State<trailer> createState() => _trailerState();
}

class _trailerState extends State<trailer> {
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
          isEnglish
              ? 'Tractor and Trailer Driving License (Grade 4) / Trailer License:'
              : 'رخصة قيادة جرار ومقطورة (الدرجة 4) / رخصة المقطورة:',
          widget.userId,
          widget.firstname,
          widget.lastname,
          isEnglish,
          _toggleLanguage
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.purple),
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
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEnglish
                          ? '1- The applicant age should not be less than 20 years.'
                          : 'أولا: يجب ألا يقل عمر المتقدم عن 20 عامًا.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '2- One year experience on a heavy cargo license 13 when submitting the application.'
                          : 'ثانيا: خبرة سنة واحدة على رخصة شحن ثقيل 13 عند تقديم الطلب.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '3- Certificate of heavy cargo course from an institute licensed by the Ministry of Transportation.'
                          : 'ثالثا: شهادة دورة الشحن الثقيل من معهد مرخص من وزارة النقل.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '4- Medical examination from the medical institution to prevent road accidents for the required grade.'
                          : 'رابعا: الفحص الطبي من المؤسسة الطبية لمنع حوادث الطرق للدرجة المطلوبة.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '5- School certificate up to fifth grade according to the executive regulations.'
                          : 'خامسا: شهادة مدرسية حتى الصف الخامس حسب اللوائح التنفيذية.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '6- Attend the practical driving test.'
                          : 'سادسا: حضور اختبار القيادة العملي.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '7- Payment of the required fees.'
                          : 'سابعا: دفع الرسوم المطلوبة.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => licenseform(
                                userId: widget.userId,
                                firstname: widget.firstname,
                                lastname: widget.lastname,
                                i: 5, isEnglish: isEnglish,
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
                              isEnglish ? 'Get Started' : 'ابدأ التقديم',
                              style: TextStyle(color: primary, fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary, size: 40),
                          ],
                        ),
                      ),
                    )
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

// Define FormB widget
class Taxi extends StatefulWidget {
  Taxi({ required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;
  @override
  State<Taxi> createState() => _TaxiState();
}

class _TaxiState extends State<Taxi> {
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
          isEnglish
              ? 'Public License / Grade (5) Public Taxi Driving License:'
              : 'رخصة عامة / الدرجة (5) رخصة قيادة سيارة أجرة عامة:',
          widget.userId,
          widget.firstname,
          widget.lastname,
          isEnglish,
          _toggleLanguage
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.purple),
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
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEnglish
                          ? '1- The applicant age should not be less than 21 years.'
                          : '1- يجب ألا يقل عمر المتقدم عن 21 عامًا.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '2- Two years of experience on grade 02, 03 private or commercial license.'
                          : '2- خبرة سنتين في الدرجة 02، 03 رخصة خاصة أو تجارية.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '3- Certificate of public taxi course from an accredited institute licensed by the Ministry of Transportation.'
                          : '3- شهادة دورة التاكسي العام من معهد معتمد مرخص من وزارة النقل.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '4- Medical examination from the medical institution to prevent road accidents for the required grade.'
                          : '4- الفحص الطبي من المؤسسة الطبية لمنع حوادث الطرق للدرجة المطلوبة.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '5- School certificate up to the second preparatory grade certified as successful according to the executive regulations.'
                          : '5- شهادة مدرسية حتى الصف الثاني الإعدادي معتمدة كناجحة وفقاً للوائح التنفيذية.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '6- Good conduct certificate from the Ministry of Interior.'
                          : '6- شهادة حسن سير وسلوك من وزارة الداخلية.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '7- Theoretical examination.'
                          : '7- الامتحان النظري.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '8- Attend the practical driving test.'
                          : '8- حضور اختبار القيادة العملي.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '9- Payment of the required fees.'
                          : '9- دفع الرسوم المطلوبة.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => licenseform(
                                userId: widget.userId,
                                firstname: widget.firstname,
                                lastname: widget.lastname,
                                i: 6, isEnglish: isEnglish,
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
                              isEnglish ? 'Get Started' : 'ابدأ التقديم',
                              style: TextStyle(color: primary, fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary, size: 40),
                          ],
                        ),
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

// Define FormB widget
class Bus extends StatefulWidget {
  Bus({ required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;
  @override
  State<Bus> createState() => _BusState();
}

class _BusState extends State<Bus> {
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
          isEnglish
              ? 'Public Bus License / Grade (6) Public Bus:'
              : 'رخصة حافلة عامة / الدرجة (6) الحافلة العامة:',
          widget.userId,
          widget.firstname,
          widget.lastname,
          isEnglish,
          _toggleLanguage
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.purple),
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
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEnglish
                          ? '1- The applicant age should not be less than 21 years.'
                          : '1- يجب ألا يقل عمر المتقدم عن 21 عامًا.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '2- Two years of experience on grade (03) commercial license.'
                          : '2- سنتان من الخبرة على رخصة تجارية من الدرجة (03).',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '3- Certificate of public bus course from an accredited institute licensed by the Ministry of Transportation.'
                          : '3- شهادة دورة الحافلة العامة من معهد معتمد مرخص من وزارة النقل.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '4- Medical examination from the medical institution to prevent road accidents for the required grade.'
                          : '4- الفحص الطبي من المؤسسة الطبية لمنع حوادث الطرق للدرجة المطلوبة.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '5- School certificate up to the second preparatory grade certified as successful according to the executive regulations.'
                          : '5- شهادة مدرسية حتى الصف الثاني الإعدادي معتمدة كناجحة وفقاً للوائح التنفيذية.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '6- Good conduct certificate from the Ministry of Interior.'
                          : '6- شهادة حسن سير وسلوك من وزارة الداخلية.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '7- Theoretical examination.'
                          : '7- الامتحان النظري.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '8- Attend the practical driving test.'
                          : '8- حضور اختبار القيادة العملي.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '9- Payment of the required fees.'
                          : '9- دفع الرسوم المطلوبة.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => licenseform(
                                userId: widget.userId,
                                firstname: widget.firstname,
                                lastname: widget.lastname,
                                i: 7, isEnglish: isEnglish,
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
                              isEnglish ? 'Get Started' : 'ابدأ التقديم',
                              style: TextStyle(color: primary, fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary, size: 40),
                          ],
                        ),
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

// Define FormB widget
class Firetruck extends StatefulWidget {
  Firetruck({ required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;
  @override
  State<Firetruck> createState() => _FiretruckState();
}

class _FiretruckState extends State<Firetruck> {
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
          isEnglish
              ? 'Fire Vehicle Driving License / Grade (03) license and above for two years or more:'
              : 'رخصة قيادة مركبة الإطفاء / رخصة من الدرجة (03) وما فوق لمدة سنتين أو أكثر:',
          widget.userId,
          widget.firstname,
          widget.lastname,
          isEnglish,
          _toggleLanguage
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.purple),
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
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEnglish
                          ? '1- Civil Defense course certificate from the Civil Defense according to the ministry agreement.'
                          : '1- شهادة دورة الدفاع المدني من الدفاع المدني وفقاً لاتفاقية الوزارة.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '2- Medical examination from the medical institution to prevent road accidents for the required grade.'
                          : '2- الفحص الطبي من المؤسسة الطبية لمنع حوادث الطرق للدرجة المطلوبة.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '3- At least 10 years of education.'
                          : '3- على الأقل 10 سنوات من التعليم.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '4- Good conduct certificate from the Ministry of Interior.'
                          : '4- شهادة حسن سير وسلوك من وزارة الداخلية.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '5- Theoretical and practical exams from the Civil Defense.'
                          : '5- الامتحانات النظرية والعملية من الدفاع المدني.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '6- Certificate approval from the licensing authority.'
                          : '6- موافقة الشهادة من سلطة الترخيص.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => licenseform(
                                userId: widget.userId,
                                firstname: widget.firstname,
                                lastname: widget.lastname,
                                i: 8, isEnglish: isEnglish,
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
                              isEnglish ? 'Get Started' : 'ابدأ التقديم',
                              style: TextStyle(color: primary, fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary, size: 40),
                          ],
                        ),
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

// Define FormB widget
class motorbikeA1 extends StatefulWidget {
  motorbikeA1({ required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;
  @override
  State<motorbikeA1> createState() => _motorbikeA1State();
}

class _motorbikeA1State extends State<motorbikeA1> {
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
          isEnglish
              ? 'Motorcycle Driving License (B) up to 500 cc:'
              : 'رخصة قيادة دراجة نارية (ب) حتى 500 سم مكعب:',
          widget.userId,
          widget.firstname,
          widget.lastname,
          isEnglish,
          _toggleLanguage
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.purple),
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
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEnglish
                          ? '1- The applicant age should not be less than 17 years.'
                          : '1- يجب ألا يقل عمر المتقدم عن 17 عامًا.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? "2- Guardian's approval."
                          : "2- موافقة الوصي.",
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '3- Vision test from the medical institution for the required grade.'
                          : '3- اختبار الرؤية من المؤسسة الطبية للدرجة المطلوبة.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '4- Pass the theoretical exam, and if holding a grade 2 license or above, exempt from the theoretical exam.'
                          : '4- اجتياز الامتحان النظري، وإذا كان حاملًا لرخصة من الدرجة الثانية أو أعلى، يُعفى من الامتحان النظري.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish
                          ? '5- Pass the practical driving test.'
                          : '5- اجتياز اختبار القيادة العملي.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => licenseform(
                                userId: widget.userId,
                                firstname: widget.firstname,
                                lastname: widget.lastname,
                                i: 9, isEnglish: isEnglish,
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
                              isEnglish ? 'Get Started' : 'ابدأ التقديم',
                              style: TextStyle(color: primary, fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary, size: 40),
                          ],
                        ),
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

class motorbikeA extends StatefulWidget {
  motorbikeA({ required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;
  @override
  State<motorbikeA> createState() => _motorbikeAState();
}

class _motorbikeAState extends State<motorbikeA> {
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
          isEnglish ? 'Motorcycle Driving License (C) over 500 cc:' : 'رخصة قيادة دراجة نارية (ج) لأكثر من 500 سم مكعب:',
          widget.userId,
          widget.firstname,
          widget.lastname,
          isEnglish,
          _toggleLanguage
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.purple
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
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEnglish ? '1- The applicant age should not be less than 21 years.' : '1- يجب ألا يقل عمر المتقدم عن 21 عامًا.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish ? '2- One year experience on a (B) license.' : '2- سنة واحدة من الخبرة على رخصة (ب).',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish ? '3- Vision test from the medical institution for the required grade.' : '3- اختبار الرؤية من المؤسسة الطبية للدرجة المطلوبة.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish ? '4- Pass the theoretical exam, and if holding a grade 2 license or above, exempt from the theoretical exam.' : '4- اجتياز الامتحان النظري، وإذا كان حاملًا لرخصة من الدرجة الثانية أو أعلى، يُعفى من الامتحان النظري.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish ? '5- Pass the practical driving test.' : '5- اجتياز اختبار القيادة العملي.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish ? '6- Good conduct certificate from the Ministry of Interior.' : '6- شهادة حسن السيرة والسلوك من وزارة الداخلية.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish ? '7- Theoretical examination.' : '7- الامتحان النظري.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish ? '8- Attend the practical driving test.' : '8- حضور اختبار القيادة العملي.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      isEnglish ? '9- Payment of the required fees.' : '9- دفع الرسوم المطلوبة.',
                      style: TextStyle(fontSize: 25),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => licenseform(
                                userId: widget.userId,
                                firstname: widget.firstname,
                                lastname: widget.lastname,
                                i: 10, isEnglish: isEnglish,
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
                              isEnglish ? 'Get Started' : 'ابدأ التقديم',
                              style: TextStyle(color: primary, fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary, size: 40),
                          ],
                        ),
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


