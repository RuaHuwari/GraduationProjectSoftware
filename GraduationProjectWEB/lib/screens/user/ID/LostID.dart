import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/resources/save_data.dart';
import 'package:graduationprojectweb/screens/profile/Components/pickimage.dart';
import 'package:graduationprojectweb/screens/user/payement.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/screens/user/HomeScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class LostID extends StatefulWidget {
   LostID({ required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  _LostIDState createState() => _LostIDState();
}

class _LostIDState extends State<LostID> {
  final _formKey = GlobalKey<FormState>();
  StoreData storeData=new StoreData();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  DateTime? _selectedDate;
  Uint8List? _image;
  TextEditingController _idNumberController = TextEditingController();
  TextEditingController _fatherNameController = TextEditingController();
  TextEditingController _motherNameController = TextEditingController();
  TextEditingController _grandfatherNameController = TextEditingController();
  TextEditingController _SexController = TextEditingController();
  TextEditingController _StatusController = TextEditingController();
  TextEditingController _PreviousFamilyNameController = TextEditingController();
  TextEditingController _placeOfBirthController = TextEditingController();
  TextEditingController _Relegion = TextEditingController();
  TextEditingController _Address_city = TextEditingController();
  TextEditingController _Address_Village = TextEditingController();
  TextEditingController _Address_street = TextEditingController();
  TextEditingController _Address_houseNU = TextEditingController();
  TextEditingController _Phone_number = TextEditingController();
  TextEditingController _LandLineNumber = TextEditingController();
  TextEditingController _partnerid = TextEditingController();
  TextEditingController _partnerfullname = TextEditingController();
  TextEditingController _partnerPassportnu = TextEditingController();
  TextEditingController _partnerPassporttype = TextEditingController();
  TextEditingController _partnerPreviousfamillyname = TextEditingController();
  int _numberOfSons = 0;
  int _numberOfDaughters = 0;

  bool imageAvailable = false;
  late int applicationID;

  late TextEditingController userIdController;
  String selectedValue='all';
  List<TextEditingController> _sonNameControllers = [];
  List<TextEditingController> _sonIDControllers = [];
  List<TextEditingController> _daughterIDControllers = [];
  List<TextEditingController> _daughterNameControllers = [];
  List<DateTime> _sonsdob=[];
  List<DateTime> _daughtersdob=[];

  Uint8List? _birthCertificate;
  Uint8List? _NewsPaperAnnouncement;
  Uint8List? _Police;
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  bool _isLoading = false;
  bool isEnglish=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEnglish=widget.isEnglish;
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
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
    if (_currentPageIndex < 5) { // Change 2 to the total number of stages - 1
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
  Future<void> _selectDate(BuildContext context, int i, List<DateTime> dateControllers) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        dateControllers[i] = pickedDate;
      });
    }
  }

  Future<void> _saveData(
      String dob,
      String name,
      int numberofsons,
      int numberofdaughters,
      String status,
      String maritalstatus,
      ) async {
    if (name == "" ||
        maritalstatus == ""
        || status==""
        || maritalstatus=="") {
      print("please fill in all field");
    } else {
      try {
        // Format the dob parameter as a string
        String formattedDOB = dob; // Or any other desired format
        String applicationid = "4";
        String departmentid = "1";
        // Send POST request to the server
        String uri="http://$IP/palease_api/insert_application.php";
        var response=await http.post(Uri.parse(uri),body: {
          "applicationid": applicationid,
          "departmentid": departmentid,
          "user_id": widget.userId,
          "applicantID":_idNumberController.text,
          "dob": formattedDOB,
          "name": name,
          "status": "Not Done",
          "created_at": DateTime.now().toString(),
          "updated_at": DateTime.now().toString()
        },
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Application submitted successfully!'),
            ),
          );
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
  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }
  void showMessageDialog(BuildContext context,String text,String text2) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text,style: TextStyle(color:primary,fontWeight: FontWeight.bold),),
          content: Text(text2),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => homescreen(
                          userId: widget.userId,
                          firstname: widget.firstname,
                          lastname: widget.lastname, isEnglish: isEnglish,)),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  Future<String> _saveApplicationIdToFirestore(String applicationId) async {
    String resp = "error occurred";
    try {
      // Add data for each son to the map
      Map<String, dynamic> sonsData = {};
      for (int i = 0; i < _numberOfSons; i++) {
        String sonNameFieldName = 'Son${i + 1}Name';
        String sonDateFieldName = 'Son${i + 1}DateOfBirth';
        String sonIDFieldName = 'Son${i + 1}ID';
        sonsData[sonNameFieldName] = _sonNameControllers[i].text;
        sonsData[sonDateFieldName] = _sonsdob[i].toString();
        sonsData[sonIDFieldName]=_sonIDControllers[i].text;
      }
      Map<String, dynamic> daughtersData = {};
      for (int i = 0; i < _numberOfSons; i++) {
        String daughterNameFieldName = 'Daughter${i + 1}Name';
        String daughterDateFieldName = 'Daughter${i + 1}DateOfBirth';
        String daughterIDFieldName = 'Daughter${i + 1}ID';
        sonsData[daughterNameFieldName] = _daughterNameControllers[i].text;
        sonsData[daughterDateFieldName] = _daughtersdob[i].toString();
        sonsData[daughterIDFieldName]=_daughterIDControllers[i].text;
      }
      print('1');

      String _imageurl=await storeData.UploadImageToStorage(applicationId+'personal image',_image!) ;
      print('2');
      String _birthurl=await storeData.UploadImageToStorage(applicationId+'Birth Certificate',_birthCertificate!) ;
      print('3');
      String _Policeurl=await storeData.UploadImageToStorage(applicationId+'policereport', _Police!);
      print('4');
      String _NewsPaper=await storeData.UploadImageToStorage(applicationId+'NewPaper Announcement', _NewsPaperAnnouncement!);
      // Check if there are existing images with the same ID
      final QuerySnapshot querySnapshot = await _firestore
          .collection("IDApplication")
          .where('id', isEqualTo: applicationId)
          .where('user_id', isEqualTo: widget.userId)
          .where('department_id', isEqualTo: 1)
          .where('ApplicantID', isEqualTo: _idNumberController.text)
          .where('applicationID', isEqualTo: 4)
          .get();

      // If there are existing images, delete them
      for (DocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      await _firestore.collection("IDApplications").add({
        'id': applicationId,
        'applicationID': 4,
        'departmentID':1,
        'user_id':widget.userId,
        'FirstName':_firstNameController.text,
        'LastName': _lastNameController.text,
        'ApplicantID': _idNumberController.text,
        'DateOfBirth':_selectedDate.toString(),
        'Gender':_SexController.text,
        'FatherName':_fatherNameController.text,
        'MotherName':_motherNameController.text,
        'GrandFatherName':_grandfatherNameController.text,
        'MaritalStatus':_StatusController.text,
        'PreviousFamilyName':_PreviousFamilyNameController.text,
        'PlaceOfBirth': _placeOfBirthController.text,
        'Religion':_Relegion.text,
        'Governorate': _Address_city.text,
        'StreetORVillage':_Address_Village.text,
        'HouseNumber':_Address_houseNU.text,
        'PhoneNumber':_Phone_number.text,
        'LandLine':_LandLineNumber.text,
        'PartnerID': _partnerid.text,
        'PartnerName': _partnerfullname.text,
        'partnerPassportType':_partnerPassporttype.text,
        'PartnerPAssportNumber':_partnerPassportnu.text,
        'PartnerPreviousFamilyName':_partnerPreviousfamillyname.text,
        'personalimage':_imageurl,
        'BirthCertificate':_birthurl,
        'News Paper Announcement': _NewsPaper,
        'Police Report': _Policeurl,
        ...sonsData,
        ...daughtersData,
      });

      resp = 'success';
    } catch (e) {
      resp = e.toString();
    }
    return resp;
    return '';
  }

  Future<void> _getImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<void> _getBirthCertificate() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _birthCertificate = img;
    });
  }
  Future<void> _getPolice() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _Police = img;
    });
  }
  Future<void> _getNewsPaper() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _NewsPaperAnnouncement = img;
    });
  }


// Sample translations, adjust as needed
  static const Map<String, String> en = {
    'title': 'Lost ID',
    'stage1_intro': 'In order to get a New ID, you need to have these files ready:',
    'file1': '1. Personal image, with Blue background.',
    'file2': '2. Birth Certificate.',
    'file3': '3. A Copy of the ID of one of the parents.',
    'file4': '4. You will need to pay a fee of 24.00 JOD.',
    'file5': '5. You must go to the police station and submit a report.',
    'file6': '6. You must post a missing announcement on the newspaper.',
    'file7': '7. Bring in the papers that prove you did step 5 & 6 (a photo of the police report, and one of the newspaper announcement).',
    'proceed': 'After you get everything ready, you can proceed on this page and start filling the requirements.',
    'first_name': 'First Name',
    'last_name': 'Last Name',
    'id_number': 'ID Number',
    'gender': 'Gender (M/F)',
    'dob': 'Date of Birth',
    'father_name': "Father's Name",
    'mother_name': "Mother's Name",
    'grandfather_name': "Grandfather's Name",
    'status': 'Marital Status',
    'prev_family_name': 'Previous family name (if available)',
    'place_of_birth': 'Place of Birth',
    'religion': 'Religion',
    'governorate': 'Governorate',
    'street': 'Street or village',
    'house_number': 'House Number',
    'phone_number': 'Phone Number',
    'land_line': 'Land Line Number',
    'married_note': 'If you are married, fill in the following. If not, skip them:',
    'partner_id': 'Partner ID (if married)',
    'partner_full_name': 'Partner full name (if married)',
    'partner_passport_number': 'Partner Passport Number (if married)',
    'partner_passport_type': 'Partner Passport Type (if married)',
    'partner_prev_family_name': 'Partner Previous Family Name (if married)',
  };

  static const Map<String, String> ar = {
    'title': 'هوية مفقودة',
    'stage1_intro': 'للحصول على هوية جديدة، تحتاج إلى تجهيز هذه الملفات:',
    'file1': '1. صورة شخصية بخلفية زرقاء.',
    'file2': '2. شهادة الميلاد.',
    'file3': '3. نسخة من هوية أحد الوالدين.',
    'file4': '4. ستحتاج إلى دفع رسوم قدرها 24.00 دينار أردني.',
    'file5': '5. يجب أن تذهب إلى مركز الشرطة وتقديم بلاغ.',
    'file6': '6. يجب أن تنشر إعلان عن فقدان الهوية في الجريدة.',
    'file7': '7. إحضار الأوراق التي تثبت أنك قمت بالخطوة 5 و 6 (صورة من تقرير الشرطة وصورة من إعلان الجريدة).',
    'proceed': 'بعد تجهيز كل شيء، يمكنك المتابعة في هذه الصفحة وبدء ملء المتطلبات.',
    'first_name': 'الاسم الأول',
    'last_name': 'الاسم الأخير',
    'id_number': 'رقم الهوية',
    'gender': 'الجنس (ذكر/أنثى)',
    'dob': 'تاريخ الميلاد',
    'father_name': 'اسم الأب',
    'mother_name': 'اسم الأم',
    'grandfather_name': 'اسم الجد',
    'status': 'الحالة الاجتماعية',
    'prev_family_name': 'اسم العائلة السابق (إذا كان متاحًا)',
    'place_of_birth': 'مكان الميلاد',
    'religion': 'الدين',
    'governorate': 'المحافظة',
    'street': 'الشارع أو القرية',
    'house_number': 'رقم المنزل',
    'phone_number': 'رقم الهاتف',
    'land_line': 'رقم الهاتف الأرضي',
    'married_note': 'إذا كنت متزوجًا، املأ المعلومات التالية. إذا لم تكن كذلك، فتجاوزها:',
    'partner_id': 'رقم هوية الشريك (إذا كان متزوجًا)',
    'partner_full_name': 'الاسم الكامل للشريك (إذا كان متزوجًا)',
    'partner_passport_number': 'رقم جواز سفر الشريك (إذا كان متزوجًا)',
    'partner_passport_type': 'نوع جواز سفر الشريك (إذا كان متزوجًا)',
    'partner_prev_family_name': 'اسم العائلة السابق للشريك (إذا كان متزوجًا)',
  };

// Use these translations in your widget
  String t(String key, bool isEnglish) {
    return isEnglish ? en[key]! : ar[key]!;
  }

  Widget _buildChildrenFields(
      String title, int numberOfChildren,
      List<TextEditingController> controllers, List<TextEditingController> IDControllers,
      List<DateTime> dateControllers) {
    List<Widget> fields = [];
    for (int i = 0; i < numberOfChildren; i++) {
      fields.add(
        Column(
          children: [
            TextFormField(
              controller: IDControllers[i],
              decoration: InputDecoration(labelText: '$title ${i + 1} ID'),
              style: TextStyle(color: primary),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter $title ${i + 1} ID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: controllers[i],
              decoration: InputDecoration(labelText: '$title ${i + 1} Name'),
              style: TextStyle(color: primary),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter $title ${i + 1} Name';
                }
                return null;
              },
            ),
            ListTile(
              title: Text(
                dateControllers[i] == null
                    ? t('dob', isEnglish)
                    : '${t('dob', isEnglish)}: ${dateControllers[i].toLocal().year} - ${dateControllers[i].toLocal().month} - ${dateControllers[i].toLocal().day}',
                style: TextStyle(color: primary),
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, i, dateControllers),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields,
    );
  }

  Widget _buildStage1(bool isEnglish) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(0),
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
                    t('stage1_intro', isEnglish),
                    style: TextStyle(
                      fontSize: 30,
                      color: primary,
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    t('file1', isEnglish),
                    style: TextStyle(
                      fontSize: 25,
                      color: primary,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    t('file2', isEnglish),
                    style: TextStyle(
                      fontSize: 25,
                      color: primary,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    t('file3', isEnglish),
                    style: TextStyle(
                      fontSize: 25,
                      color: primary,
                    ),
                  ),
                  Text(
                    t('file4', isEnglish),
                    style: TextStyle(
                      fontSize: 25,
                      color: primary,
                    ),
                  ),
                  Text(
                    t('file5', isEnglish),
                    style: TextStyle(
                      fontSize: 25,
                      color: primary,
                    ),
                  ),
                  Text(
                    t('file6', isEnglish),
                    style: TextStyle(
                      fontSize: 25,
                      color: primary,
                    ),
                  ),
                  Text(
                    t('file7', isEnglish),
                    style: TextStyle(
                      fontSize: 25,
                      color: primary,
                    ),
                  ),
                  Text(
                    t('proceed', isEnglish),
                    style: TextStyle(
                      fontSize: 25,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStage2(bool isEnglish) {
    return Container(
      padding: EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Page 1',
            style: TextStyle(
              color: primary,
              fontSize: 20,
              fontFamily: 'SansSerif',
            ),
          ),
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(labelText: t('first_name', isEnglish)),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('first_name', isEnglish);
              }
              return null;
            },
          ),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(labelText: t('last_name', isEnglish)),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('last_name', isEnglish);
              }
              return null;
            },
          ),
          TextFormField(
            controller: _idNumberController,
            decoration: InputDecoration(labelText: t('id_number', isEnglish)),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('id_number', isEnglish);
              }
              return null;
            },
          ),
          TextFormField(
            controller: _SexController,
            decoration: InputDecoration(labelText: t('gender', isEnglish)),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('gender', isEnglish);
              }
              return null;
            },
          ),
          ListTile(
            title: Text(
              _selectedDate == null
                  ? t('dob', isEnglish)
                  : '${t('dob', isEnglish)}: ${_selectedDate!.toLocal().year} - ${_selectedDate!.toLocal().month} - ${_selectedDate!.toLocal().day}',
              style: TextStyle(color: primary),
            ),
            trailing: Icon(Icons.calendar_today),
            onTap: () => _selectDate1(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStage3(bool isEnglish) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _fatherNameController,
            decoration: InputDecoration(labelText: t('father_name', isEnglish)),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('father_name', isEnglish);
              }
              return null;
            },
          ),
          TextFormField(
            controller: _motherNameController,
            decoration: InputDecoration(labelText: t('mother_name', isEnglish)),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('mother_name', isEnglish);
              }
              return null;
            },
          ),
          TextFormField(
            controller: _grandfatherNameController,
            decoration: InputDecoration(labelText: t('grandfather_name', isEnglish)),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('grandfather_name', isEnglish);
              }
              return null;
            },
          ),
          TextFormField(
            controller: _StatusController,
            decoration: InputDecoration(labelText: t('status', isEnglish)),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('status', isEnglish);
              }
              return null;
            },
          ),
          TextFormField(
            controller: _PreviousFamilyNameController,
            decoration: InputDecoration(labelText: t('prev_family_name', isEnglish)),
            style: TextStyle(color: primary),
          ),
          TextFormField(
            controller: _placeOfBirthController,
            decoration: InputDecoration(labelText: t('place_of_birth', isEnglish)),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('place_of_birth', isEnglish);
              }
              return null;
            },
          ),
          TextFormField(
            controller: _Relegion,
            decoration: InputDecoration(labelText: t('religion', isEnglish)),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('religion', isEnglish);
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStage4(bool isEnglish) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _Address_city,
            decoration: InputDecoration(labelText: t('governorate', isEnglish)),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('governorate', isEnglish);
              }
              return null;
            },
          ),
          TextFormField(
            controller: _Address_street,
            decoration: InputDecoration(labelText: t('street', isEnglish)),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('street', isEnglish);
              }
              return null;
            },
          ),
          TextFormField(
            controller: _Address_houseNU,
            decoration: InputDecoration(labelText: t('house_number', isEnglish)),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('house_number', isEnglish);
              }
              return null;
            },
          ),
          TextFormField(
            controller: _Phone_number,
            decoration: InputDecoration(labelText: t('phone_number', isEnglish)),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('phone_number', isEnglish);
              }
              return null;
            },
          ),
          TextFormField(
            controller: _LandLineNumber,
            decoration: InputDecoration(labelText: t('land_line', isEnglish)),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('land_line', isEnglish);
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStage5(bool isEnglish) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t('married_note', isEnglish)),
          TextFormField(
            controller: _partnerid,
            decoration: InputDecoration(labelText: t('partner_id', isEnglish)),
            style: TextStyle(color: primary),
          ),
          TextFormField(
            controller: _partnerfullname,
            decoration: InputDecoration(labelText: t('partner_full_name', isEnglish)),
            style: TextStyle(color: primary),
          ),
          TextFormField(
            controller: _partnerPassportnu,
            decoration: InputDecoration(labelText: t('partner_passport_number', isEnglish)),
            style: TextStyle(color: primary),
          ),
          TextFormField(
            controller: _partnerPassporttype,
            decoration: InputDecoration(labelText: t('partner_passport_type', isEnglish)),
            style: TextStyle(color: primary),
          ),
          TextFormField(
            controller: _partnerPreviousfamillyname,
            decoration: InputDecoration(labelText: t('partner_prev_family_name', isEnglish)),
            style: TextStyle(color: primary),
          ),
        ],
      ),
    );
  }

// Adjust the build method to pass isEnglish to the stages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(context, t('title', isEnglish), widget.userId, widget.firstname, widget.lastname, isEnglish, _toggleLanguage),
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
                    padding: const EdgeInsets.fromLTRB(80.0, 18.0, 80.0, 0),
                    child: PageView(
                      controller: _pageController,
                      physics: NeverScrollableScrollPhysics(),
                      // Disable swiping
                      children: [
                        // Stage 1
                        _buildStage1(isEnglish),
                        // Stage 2
                        _buildStage2(isEnglish),
                        // Stage 3
                        _buildStage3(isEnglish),
                        _buildStage4(isEnglish),
                        _buildStage5(isEnglish),
                        _buildStage6(),
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
                    color: primary,
                  ),
                if (_currentPageIndex != 5) // Change 5 to the total number of stages - 1
                  IconButton(
                    padding: EdgeInsets.only(left: 20),
                    color: primary,
                    // alignment: Alignment.bottomRight,
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

  Widget _buildStage6() {
    return Container(
      padding: EdgeInsets.all(20),
      child:ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: isEnglish?'Number of Sons':'عدد الابناء'),
            style: TextStyle(color: primary),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _numberOfSons = int.tryParse(value) ?? 0;
                _sonNameControllers = List.generate(
                    _numberOfSons, (index) => TextEditingController());
                _sonIDControllers=List.generate(_numberOfSons, (index) => TextEditingController());
                _sonsdob = List<DateTime>.generate(_numberOfSons, (index) => DateTime.now());


              });
            },
          ),
          _numberOfSons > 0
              ? _buildChildrenFields(isEnglish?'Son':'ابن', _numberOfSons, _sonNameControllers,_sonIDControllers,_sonsdob)
              : SizedBox(),
          TextFormField(
            decoration: InputDecoration(labelText: isEnglish?'Number of Daughters':'عدد البنات'),
            style: TextStyle(color: primary),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _numberOfDaughters = int.tryParse(value) ?? 0;
                _daughterNameControllers = List.generate(
                    _numberOfDaughters, (index) => TextEditingController());
                _daughterIDControllers=List.generate(_numberOfDaughters, (index) => TextEditingController());
                _daughtersdob = List<DateTime>.generate(_numberOfDaughters, (index) => DateTime.now());

              });
            },
          ),
          _numberOfDaughters > 0
              ? _buildChildrenFields(
              isEnglish?'Daughter':'الابنة', _numberOfDaughters, _daughterNameControllers,_daughterIDControllers,_daughtersdob,)
              : SizedBox(),

          _image==null?
          ElevatedButton.icon(
            onPressed: _getImage,
            icon: Icon(Icons.image),
            label: Text(isEnglish?'Select Image of Applicant':'أرفق صورة مقدم الطلب'),
          ):Column(
            children: [
              Text(
                isEnglish?'Selected File:':'الملف المختار',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Image.memory(_image!,height: 100,),
            ],
          ),


          _birthCertificate == null
              ? ElevatedButton.icon(
            onPressed: _getBirthCertificate,
            icon: Icon(Icons.attach_file),
            label: Text(isEnglish?'Select Birth Certificate':'أرف صورة لشهادة الميلاد'),
          )
              :   Column(
            children: [
              Text(
                isEnglish?'Selected File:':'الملف المختار',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Image.memory(_birthCertificate!,height: 100,),
            ],
          ),
          _NewsPaperAnnouncement == null
              ? ElevatedButton.icon(
            onPressed: _getNewsPaper,
            icon: Icon(Icons.attach_file),
            label: Text(isEnglish?'Select Picture of NewsPaper Announcement':'ارفاق صورة لاعلان الجريدة'),
          )
              :   Column(
            children: [
              Text(
                isEnglish?'Selected File:':'الملف المختار',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Image.memory(_NewsPaperAnnouncement!,height: 100,),
            ],
          ),
          _Police == null
              ? ElevatedButton.icon(
            onPressed: _getPolice,
            icon: Icon(Icons.attach_file),
            label: Text(isEnglish?'Select Picture of the police report':'ارفق صورة لبلاغ الشرطة'),
          )
              :   Column(
            children: [
              Text(
                isEnglish?'Selected File:':'الملف المختار',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Image.memory(_Police!,height: 100,),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {

              applicationID = await fetchData();
              print(applicationID);
              applicationID++;
              print(applicationID);
              _saveData(applicationID.toString(),_selectedDate.toString(), _numberOfSons, _numberOfDaughters, 'Not Done', _StatusController.text);
              _saveApplicationIdToFirestore(applicationID.toString());
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pay(applicationID: applicationID.toString(),price:20,firstname:widget.firstname,lastname:widget.lastname,userId:widget.userId, isEnglish: isEnglish,)),
              );

            },
            child: Text(isEnglish?'Submit':'تقديم الطلب'),
          ),
          SizedBox(height:5),

          if (_isLoading) Container(
            height:10,
            width:10,
            child: CircularProgressIndicator(
                strokeWidth:10
            ),
          )
        ],
      ),

    );
  }

}
class ApplicationData {
  final int id;
  final int applicantId;
  final String application;
  final int applicationID;
  final String creationDate;
  final String status;
  final String link;

  ApplicationData({
    required this.id,
    required this.applicantId,
    required this.applicationID,
    required this.application,
    required this.creationDate,
    required this.status,
    required this.link,
  });

  factory ApplicationData.fromJson(Map<String, dynamic> json, int index) {
    return ApplicationData(
      id: index, // Assign ID based on index
      applicantId: json['ApplicantID'],
      applicationID: json['application_data_id'],
      application: json['application_type'],
      creationDate: json['created_at'],
      status: json['Status'],
      link: 'Show Application',
    );
  }
}
