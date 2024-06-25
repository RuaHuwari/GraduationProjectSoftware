import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/resources/save_data.dart';
import 'package:graduationprojectweb/screens/profile/Components/pickimage.dart';
import 'package:graduationprojectweb/screens/user/Driving/newlicense.dart';
import 'package:graduationprojectweb/screens/user/HomeScreen.dart';
import 'package:graduationprojectweb/screens/user/payement.dart';
import 'package:graduationprojectweb/widgets/bottomnavigation.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
// Define translations
Map<String, Map<String, String>> translations = {
  'en': {
    'new_license_form': 'New License Form',
    'stage1_text1': 'In order to get a New license, you need to have these files ready:',
    'stage1_text2': '1. Personal image, with Blue background.',
    'stage1_text3': '2. Picture of your ID card',
    'stage1_text4': '3. any other needed files will be asked from you in the form depending on the license type you chose, for more info go back to the page with the license type instructions',
    'stage1_text5': '4. download the images using the buttons on this page, fill the pages, you will submit them at the end of the form.',
    'stage1_text6': '5. You will need to pay 120 ILS in order to apply for the form.',
    'stage1_text7': 'After you get everything ready, You can proceed in this page and start filling the requirements.',
    'download_first_page': 'Download first page of the form',
    'download_second_page': 'Download second page of the form',
    'select_city': 'Select City',
    'please_select_city': 'Please select a city',
    'i_have_license_type': 'I Have A license of type:',
    'license_number': 'I have a License with license number:',
    'first_name': 'First Name',
    'father_name': "Father's Name",
    'grandfather_name': "Grandfather's Name",
    'last_name': 'Last Name',
    'id_number': 'ID Number',
    'gender': 'Gender (M/F)',
    'date_of_birth': 'Date of Birth',
    'address': 'Address',
    'phone_number': 'PhoneNumber',
    'submit': 'Submit',
    'sorry': 'Sorry!',
    'ok': 'OK',
  },
  'ar': {
    'new_license_form': 'نموذج الترخيص الجديد',
    'stage1_text1': 'للحصول على ترخيص جديد، يجب أن تكون لديك هذه الملفات جاهزة:',
    'stage1_text2': '1. صورة شخصية بخلفية زرقاء.',
    'stage1_text3': '2. صورة لبطاقة الهوية الخاصة بك',
    'stage1_text4': '3. سيتم طلب أي ملفات أخرى مطلوبة منك في النموذج حسب نوع الترخيص الذي اخترته، لمزيد من المعلومات عد إلى الصفحة التي تحتوي على تعليمات نوع الترخيص',
    'stage1_text5': '4. قم بتنزيل الصور باستخدام الأزرار في هذه الصفحة، املأ الصفحات، ستقوم بتقديمها في نهاية النموذج.',
    'stage1_text6': '5. ستحتاج إلى دفع 120 شيكل لتقديم الطلب.',
    'stage1_text7': 'بعد أن تكون كل شيء جاهز، يمكنك المتابعة في هذه الصفحة وبدء ملء المتطلبات.',
    'download_first_page': 'تحميل الصفحة الأولى من النموذج',
    'download_second_page': 'تحميل الصفحة الثانية من النموذج',
    'select_city': 'اختر مدينة',
    'please_select_city': 'يرجى اختيار مدينة',
    'i_have_license_type': 'لدي رخصة من نوع:',
    'license_number': 'لدي رخصة برقم الرخصة:',
    'first_name': 'الاسم الأول',
    'father_name': 'اسم الأب',
    'grandfather_name': 'اسم الجد',
    'last_name': 'الاسم الأخير',
    'id_number': 'رقم الهوية',
    'gender': 'الجنس (ذكر/أنثى)',
    'date_of_birth': 'تاريخ الميلاد',
    'address': 'العنوان',
    'phone_number': 'رقم الهاتف',
    'submit': 'إرسال',
    'sorry': 'عذراً!',
    'ok': 'حسناً',
  },
};
class licenseform extends StatefulWidget {
   licenseform({required this.userId, required this.firstname, required this.lastname, required this.i, required this.isEnglish});
final String userId;
final String firstname;
final String lastname;
final int i;
final bool isEnglish;

  @override
  State<licenseform> createState() => _formState();
}

class _formState extends State<licenseform> {
  //setting the expansion function for the navigation rail
  bool isExpanded = false;
  int _currentPageIndex = 0;
  bool isEnglish=true;
  // Variable to store the selected city
  String? selectedCity;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _fatherNameController = TextEditingController();
  TextEditingController _grandfatherNameController = TextEditingController();
  TextEditingController _LicenseManagement = TextEditingController();
  String licensetype = '';
  TextEditingController _Oldlicense = TextEditingController();
  TextEditingController _OldlicenseNumber = TextEditingController();
  TextEditingController _IDNumberController = TextEditingController();
  TextEditingController _SexController = TextEditingController();
  TextEditingController _AddressController = TextEditingController();
  TextEditingController _PhoneNumberController = TextEditingController();
  DateTime? _selectedDate;
  Uint8List? _image1;
  Uint8List? _image2;
  Uint8List? _IDCard;
  Uint8List? _personalimage;
  Uint8List? _Certificate;
  Uint8List? _goodConduct;
  Uint8List? _fatheragreement;
  Uint8List? _schoolcertificate;
  StoreData storeData=new StoreData();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final PageController _pageController = PageController();

  int _age=0;
  late int applicationID;
  Future<int> fetchData()  async {
    try {
      String uri = "http://$IP/palease_api/allapplication.php";
      var response = await http.post(
        Uri.parse(uri),
        body: {
        },
      );
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['success']) {
          return applicationID = jsonData['max_id'];
        } else {

          return(jsonData['error']);
        }
      } else {
        return(0);
      }
    } catch (e) {
      return(0);
    }
  }
  void _nextPage() {
    if (_currentPageIndex < 3) { // Change 2 to the total number of stages - 1
      setState(() {
        _currentPageIndex++;
      });
      _pageController.animateToPage(
        _currentPageIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }
  Future<void> _saveData(
      String ID,
      String dob,
      String name,
      String status,
      ) async {
    if (name == "") {
      print("please fill in all field");
    } else {
      try {
        // Format the dob parameter as a string
        String formattedDOB = dob; // Or any other desired format
        String applicationid = "9";
        String departmentid = "3";
        // Send POST request to the server
        String uri="http://$IP/palease_api/insert_application.php";
        var response=await http.post(Uri.parse(uri),body: {
          'id':ID,
          "applicationid": applicationid,
          "departmentid": departmentid,
          "user_id": widget.userId,
          "applicantID":_IDNumberController.text,
          "dob": formattedDOB,
          "name": name,
          "status": "Not Done",
          "created_at": DateTime.now().toString(),
          "updated_at": DateTime.now().toString()
        },
        );

        // Check if the request was successful (status code 200)
        if (response.statusCode == 200) {
          // Extract the response body
          var responseBody = jsonDecode(response.body);

          // Extract the autogenerated ID from the response

          // Show success message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Application submitted successfully!'),
            ),
          );

          // Reset the form or navigate to another screen
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  homescreen(userId: widget.userId,firstname:widget.firstname ,lastname:widget.lastname, isEnglish: isEnglish,)),
            );
          });
        } else {
          // Show error message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit application. Please try again.'),
            ),
          );
        }
      } catch (e) {
        // Handle any exceptions or errors
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error occurred while submitting application.'),
          ),
        );
      }
    }
  }

  Future<String> _saveApplicationIdToFirestore(String applicationId) async {
    String resp = "error occurred";
    try {
      print('1');

      String _imageurl=await storeData.UploadImageToStorage(applicationId+'personal image',_personalimage!) ;
      print('2');
      String _idurl=await storeData.UploadImageToStorage(applicationId+'IDCard',_IDCard!) ;
      String _firstpage=await storeData.UploadImageToStorage(applicationId+'FirstPage',_image1!) ;
      String _secondpage=await storeData.UploadImageToStorage(applicationId+'SecondPage',_image2!) ;
      String _certificate='',_schoolCertificate='',_goodconduct='',_agreement='';
      if(widget.i==1 ||widget.i== 4 || widget.i== 5 || widget.i== 6|| widget.i== 7 ||widget.i== 8)
      _certificate=await storeData.UploadImageToStorage(applicationId+'Certificate',_Certificate!) ;
      if( widget.i== 5 || widget.i== 6|| widget.i== 7 ||widget.i== 8)
       _schoolCertificate=await storeData.UploadImageToStorage(applicationId+'SchoolCertificate',_schoolcertificate!) ;
      if( widget.i== 6|| widget.i== 7 ||widget.i== 8)
      _goodconduct=await storeData.UploadImageToStorage(applicationId+'GoodConduct',_goodConduct!) ;
      if(widget.i==9 && _selectedDate!=null && _calculateage(_selectedDate!)<18)
        _agreement=await storeData.UploadImageToStorage(applicationId+'agreement',_fatheragreement!) ;
      print('3');
      // Check if there are existing images with the same ID
      final QuerySnapshot querySnapshot = await _firestore
          .collection("IDApplication")
          .where('id', isEqualTo: applicationId)
          .where('user_id', isEqualTo: widget.userId)
          .where('department_id', isEqualTo: 3)
          .where('ApplicantID', isEqualTo: _IDNumberController.text)
          .where('applicationID', isEqualTo: 9)
          .get();

      // If there are existing images, delete them
      for (DocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      await _firestore.collection("IDApplications").add({
        'id': applicationId,
        'applicationID': 9,
        'departmentID':3,
        if(widget.i==1)
          'License Type':'Tractor',
        if(widget.i==2)
          'License Type':'Private Car',
        if(widget.i==3)
          'License Type':'Commercial Driving License',
        if(widget.i==4)
          'License Type':'Heavy Vehicle Driving License',
        if(widget.i==5)
          'License Type':' Trailer Driving License',
        if(widget.i==6)
          'License Type':'Public Taxi Driving License',
        if(widget.i==7)
          'License Type':'Public Bus Driving License',
        if(widget.i==8)
          'License Type':'Fire Truck Driving License',
        if(widget.i==9)
          'License Type':'MotorBike Driving License up to 500 cc',
        if(widget.i==10)
          'License Type':'Motorcycle Driving License (C) over 500 cc',

        'user_id':widget.userId,
        'FirstName':_firstNameController.text,
        'LastName': _lastNameController.text,
        'ApplicantID': _IDNumberController.text,
        'DateOfBirth':_selectedDate.toString(),
        'Gender':_SexController.text,
        'FatherName':_fatherNameController.text,
        'GrandFatherName':_grandfatherNameController.text,
        'Address': _AddressController.text,
        'PhoneNumber':_PhoneNumberController.text,
        'personalimage':_imageurl,
        'Firstpage':_firstpage,
        'secondpage':_secondpage,
        if(_Oldlicense.text!='')
        'OLD License Type':_Oldlicense,
        if(_OldlicenseNumber.text!='')
        'OLD License Number':_OldlicenseNumber,
        'IDCard':_idurl,
        if(widget.i==1 ||widget.i== 4 || widget.i== 5 || widget.i== 6|| widget.i== 7 ||widget.i== 8)
          'Course Cetificate':_certificate,
        if( widget.i== 5 || widget.i== 6|| widget.i== 7 ||widget.i== 8)
          'School Certificate':_schoolCertificate,
        if(widget.i== 6|| widget.i== 7 ||widget.i== 8)
        'good conduct':_goodconduct,
        if(_selectedDate!=null && _calculateage(_selectedDate!)<18)
          'fatheragreement':_agreement,
      });

      resp = 'success';
    } catch (e) {
      resp = e.toString();
    }
    return resp;
    return '';
  }
  void _previousPage() {
    if (_currentPageIndex > 0) {
      setState(() {
        _currentPageIndex--;
      });
      _pageController.animateToPage(
        _currentPageIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }
  Future<void> _getImage1() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image1 = img;
    });
  }
  Future<void> _getImage2() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image2 = img;
    });
  } Future<void> _getpersonal() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _personalimage = img;
    });
  }
  Future<void> _getID() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _IDCard = img;
    });
  }
  Future<void> _getGoodConduct() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _goodConduct = img;
    });
  }
  Future<void> _getschoolcertificate() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _schoolcertificate = img;
    });
  }
  Future<void> _getCertificate() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _Certificate = img;
    });
  } Future<void> _getagreement() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _fatheragreement = img;
    });
  }
  int _calculateage(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age ;
  }
  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String _currentLanguage = 'en';
  String getText(String key) {
  return translations[_currentLanguage]![key]!;
  }

  void _toggleLanguage() {
  setState(() {
    isEnglish=!isEnglish;
  _currentLanguage = _currentLanguage == 'en' ? 'ar' : 'en';
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
  appBar: AppBar(
  title: Text(getText('new_license_form')),
  actions: [
  IconButton(
  icon: Icon(Icons.language),
  onPressed: _toggleLanguage,
  ),
  ],
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
  child: ListView(
  children: [
  Container(
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
  padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
  child: PageView(
  controller: _pageController,
  physics: NeverScrollableScrollPhysics(),
  // Disable swiping
  children: [
  // Stage 1
  _buildStage1(),
  // Stage 2
  _buildStage2(),
  // Stage 3
  _buildStage3(),
  _buildStage4(),
  ],
  ),
  ),
  ),
  ],
  ),
  ),
  Container(
  padding: EdgeInsets.only(top: 560, left: 100),
  child: Row(
  children: [
  if (_currentPageIndex != 0)
  IconButton(
  padding: EdgeInsets.only(left: 260),
  icon: Icon(Icons.arrow_back),
  onPressed: _previousPage,
  color: Colors.blue,
  ),
  if (_currentPageIndex != 3)
  IconButton(
  padding: EdgeInsets.only(left: 20),
  color: Colors.blue,
  icon: Icon(Icons.arrow_forward),
  onPressed: _nextPage,
  ),
  ],
  ),
  ),
  ],
  ),
  );
  }

  Widget _buildStage1() {
  return Container(
  padding: EdgeInsets.all(20),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Container(
  padding: const EdgeInsets.all(15),
  height: 500,
  decoration: BoxDecoration(
  color: Colors.white.withOpacity(0.4),
  borderRadius: BorderRadius.circular(50),
  ),
  child: Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text(
  getText('stage1_text1'),
  style: TextStyle(
  fontSize: 20,
  color: Colors.blue,
  ),
  ),
  Text(
  getText('stage1_text2'),
  style: TextStyle(
  fontSize: 15,
  color: Colors.blue,
  ),
  textAlign: TextAlign.left,
  ),
  Text(
  getText('stage1_text3'),
  style: TextStyle(
  fontSize: 15,
  color: Colors.blue,
  ),
  textAlign: TextAlign.left,
  ),
  Text(
  getText('stage1_text4'),
  style: TextStyle(
  fontSize: 15,
  color: Colors.blue,
  ),
  ),
  Text(
  getText('stage1_text5'),
  style: TextStyle(
  fontSize: 15,
  color: Colors.blue,
  ),
  ),
  Text(
  getText('stage1_text6'),
  style: TextStyle(
  fontSize: 15,
  color: Colors.blue,
  ),
  ),
  Text(
  getText('stage1_text7'),
  style: TextStyle(
  fontSize: 15,
  color: Colors.blue,
  ),
  ),
  ],
  ),
  ),
  SizedBox(height: 20),
  ElevatedButton(
  onPressed: () {
  // download first page
  },
  child: Text(getText('download_first_page')),
  ),
  ElevatedButton(
  onPressed: () {
  // download second page
  },
  child: Text(getText('download_second_page')),
  ),
  ],
  ),
  );
  }

  Widget _buildStage2() {
  return Container(
  padding: EdgeInsets.all(20),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Container(
  padding: const EdgeInsets.all(15),
  height: 500,
  decoration: BoxDecoration(
  color: Colors.white.withOpacity(0.4),
  borderRadius: BorderRadius.circular(50),
  ),
  child: Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text(
  getText('select_city'),
  style: TextStyle(
  fontSize: 20,
  color: Colors.blue,
  ),
  ),
  DropdownButton<String>(
  items: [
  DropdownMenuItem(value: 'city1', child: Text('City 1')),
  DropdownMenuItem(value: 'city2', child: Text('City 2')),
  ],
  onChanged: (value) {
  // handle change
  },
  hint: Text(getText('please_select_city')),
  ),
  Text(
  getText('i_have_license_type'),
  style: TextStyle(
  fontSize: 15,
  color: Colors.blue,
  ),
  ),
  Text(
  getText('license_number'),
  style: TextStyle(
  fontSize: 15,
  color: Colors.blue,
  ),
  ),
  TextField(
  decoration: InputDecoration(labelText: getText('first_name')),
  ),
  TextField(
  decoration: InputDecoration(labelText: getText('father_name')),
  ),
  TextField(
  decoration: InputDecoration(labelText: getText('grandfather_name')),
  ),
  TextField(
  decoration: InputDecoration(labelText: getText('last_name')),
  ),
  ],
  ),
  ),
  ],
  ),
  );
  }

  Widget _buildStage3() {
  return Container(
  padding: EdgeInsets.all(20),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Container(
  padding: const EdgeInsets.all(15),
  height: 500,
  decoration: BoxDecoration(
  color: Colors.white.withOpacity(0.4),
  borderRadius: BorderRadius.circular(50),
  ),
  child: Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text(
  getText('stage1_text1'),
  style: TextStyle(
  fontSize: 20,
  color: Colors.blue,
  ),
  ),
  Text(
  getText('id_number'),
  style: TextStyle(
  fontSize: 15,
  color: Colors.blue,
  ),
  ),
  TextField(
  decoration: InputDecoration(labelText: getText('gender')),
  ),
  TextField(
  decoration: InputDecoration(labelText: getText('date_of_birth')),
  ),
  TextField(
  decoration: InputDecoration(labelText: getText('address')),
  ),
  TextField(
  decoration: InputDecoration(labelText: getText('phone_number')),
  ),
  ],
  ),
  ),
  ],
  ),
  );
  }

  Widget _buildStage4() {
  return Container(
  padding: EdgeInsets.all(20),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Container(
  padding: const EdgeInsets.all(15),
  height: 500,
  decoration: BoxDecoration(
  color: Colors.white.withOpacity(0.4),
  borderRadius: BorderRadius.circular(50),
  ),
  child: Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text(
  getText('submit'),
  style: TextStyle(
  fontSize: 20,
  color: Colors.blue,
  ),
  ),
  ElevatedButton(
  onPressed: () async {
    applicationID = await fetchData();

    print(applicationID);
    applicationID++;
    print(applicationID);
    _saveData(applicationID.toString(), _selectedDate.toString(),
        _firstNameController.text, 'Not Done');
    _saveApplicationIdToFirestore(applicationID.toString());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          pay(
            applicationID: applicationID.toString(),
            price: 24,
            firstname: widget.firstname,
            lastname: widget.lastname,
            userId: widget.userId, isEnglish: isEnglish,
          )),
    );
  },
  child: Text(getText('submit')),
  ),
  ],
  ),
  ),
  ],
  ),
  );
  }
  }
