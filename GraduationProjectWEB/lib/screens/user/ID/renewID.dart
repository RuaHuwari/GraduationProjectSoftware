import 'dart:convert';
import 'dart:html' as html;
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

class renewId extends StatefulWidget {
  renewId({ required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  _LostIDState createState() => _LostIDState();
}

class _LostIDState extends State<renewId> {
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

  Uint8List? _OldID;
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  bool _isLoading = false;

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
  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
        String applicationid = "3";
        String departmentid = "1";
        String numberofsonsStr = numberofsons.toString();
        String numberofdaughtersStr = numberofdaughters.toString();
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
      String _oldurl=await storeData.UploadImageToStorage(applicationId+'OldId',_OldID!) ;
      print('3');
      // Check if there are existing images with the same ID
      final QuerySnapshot querySnapshot = await _firestore
          .collection("IDApplication")
          .where('id', isEqualTo: applicationId)
          .where('user_id', isEqualTo: widget.userId)
          .where('department_id', isEqualTo: 1)
          .where('ApplicantID', isEqualTo: _idNumberController.text)
          .where('applicationID', isEqualTo: 3)
          .get();

      // If there are existing images, delete them
      for (DocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      await _firestore.collection("IDApplications").add({
        'id': applicationId,
        'applicationID': 3,
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
        'Old ID':_OldID,
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

  Future<void> _getOldID() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _OldID = img;
    });
  }

  Widget _buildChildrenFields(String title, int numberOfChildren,
      List<TextEditingController> controllers, List<TextEditingController> IDControllers,
      List<DateTime> dateControllers) {
    List<Widget> fields = [];
    for (int i = 0; i < numberOfChildren; i++) {
      fields.add(
        Column(
          children: [
            TextFormField(
              controller: IDControllers[i],
              decoration: InputDecoration(labelText: isEnglish?'$title ${i + 1} ID':'$title ${i+1} رقم هوية'),
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
              decoration: InputDecoration(labelText: isEnglish?'$title ${i + 1} Name':'$title ${i+1} اسم'),
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
                    ? isEnglish?'Date of Birth':'تاريخ الميلاد'
                    : isEnglish?'Date of Birth: ${dateControllers[i].toLocal().year} - ${dateControllers[i].toLocal().month} - ${dateControllers[i].toLocal().day}':'${dateControllers[i].toLocal().year} - ${dateControllers[i].toLocal().month} - ${dateControllers[i].toLocal().day}:تاريخ الميلاد: ',
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
  bool isEnglish = true;

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(context, isEnglish?'Renew ID':'تجديد الهوية', widget.userId, widget.firstname, widget.lastname,isEnglish,_toggleLanguage),
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
            padding: const EdgeInsets.only(top: 30.0,left:50,right:50),
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
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                    child:
                    PageView(
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
                        _buildStage5(),
                        _buildStage6(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left:100,top:560),
            child: Row(
              children: [
                if (_currentPageIndex != 0)
                  IconButton(
                    padding: EdgeInsets.only(left: 260),
                    icon: Icon(Icons.arrow_back),
                    onPressed: _previousPage,
                    color: primary,

                  ),
                if (_currentPageIndex !=
                    5) // Change 2 to the total number of stages - 1
                  IconButton(
                    padding: EdgeInsets.only(left: 20),

                    color: primary,
                    //alignment: Alignment.bottomRight,
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
                  borderRadius: BorderRadius.circular(50)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEnglish?'In order to ReNew your ID, you need to have these files ready:':'حتى تستطيع ان تباشر بتجديد هويتك يجب ان يكون لديك الاتي: ',
                    style: TextStyle(
                      fontSize: 30,
                      color: primary,
                    ),),
                  SizedBox(height:50),
                  Text(isEnglish?'1. Personal image, with Blue background.':'أولا: صورة شخصية بخلفية زرقاء',
                      style: TextStyle(
                        fontSize: 25,
                        color: primary,

                      ), textAlign: TextAlign.left),
                  Text(isEnglish?'2. A picture of the Old ID.':'ثانيا: ثورة من هويتك القديمة', style: TextStyle(
                    fontSize: 25,
                    color: primary,
                  ), textAlign: TextAlign.left),
                  Text(isEnglish?'3. You will need to pay a fee of 7.00 JOD.':'ثالثا: عليك ان تدفع رسوم بما مقجاره 7.00 دينار اردني',
                    style: TextStyle(
                      fontSize: 25,
                      color: primary,
                    ),),
                  Text(
                    isEnglish?'After you get everything ready, You can proceed in this page and start filling the requirements.':'بعد أن يصبح لديك كل شيء جاهزاً، يمكنك البدء بتقديم الطلب ',
                    style: TextStyle(
                      fontSize: 25,
                      color: primary,
                    ),),

                ],
              ),
            ),
            // Example: TextFormField(), ElevatedButton(), etc.
          ],
        ),
      ),
    );
  }

  Widget _buildStage2() {
    return Container(
      padding: EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(labelText: isEnglish?'First Name':'الاسم الأول',),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(labelText: isEnglish?'Last Name':'اسم العائلة'),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _idNumberController,
            decoration: InputDecoration(labelText: isEnglish?'ID Number':'رقم الهوية'),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your ID number';
              }
              return null;
            },
          ),

          TextFormField(
            controller: _SexController,
            decoration: InputDecoration(labelText: isEnglish?"Gender (M/F)":'الجنس'),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Gender';
              }
              return null;
            },
          ),
          ListTile(
            title: Text(
              _selectedDate == null
                  ? isEnglish?'Date of Birth':'تاريخ الميلاد '
                  : isEnglish?'Date of Birth: ${_selectedDate!.toLocal()
                  .year} - ${_selectedDate!.toLocal().month} - ${_selectedDate!
                  .toLocal().day}':'تاريخ الميلاد:${_selectedDate!.toLocal()
                  .year} - ${_selectedDate!.toLocal().month} - ${_selectedDate!
                  .toLocal().day} ',
              style: TextStyle(color: primary),
            ),
            trailing: Icon(Icons.calendar_today),
            onTap: () => _selectDate1(context),
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
          TextFormField(
            controller: _fatherNameController,
            decoration: InputDecoration(labelText: isEnglish?"Father's Name":'اسم الأب',),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your father\'s name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _motherNameController,
            decoration: InputDecoration(labelText: isEnglish?"Mother's Name":'اسم الأم',),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Mother\'s name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _grandfatherNameController,
            decoration: InputDecoration(labelText: isEnglish?"Grandfather's Name":'اسم الجد'),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your grandfather\'s name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _StatusController,
            decoration: InputDecoration(labelText: isEnglish?"Marital Status":'الحالة الاجتماعية'),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Status';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _PreviousFamilyNameController,
            decoration: InputDecoration(
                labelText: isEnglish?"Previous family name (if available)":'اسم العائلة السابق (ان وجد) '),
            style: TextStyle(color: primary),
          ),
          TextFormField(
            controller: _placeOfBirthController,
            decoration: InputDecoration(labelText: isEnglish?"Place of Birth":'مكان الولادة'),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Place of birth';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _Relegion,
            decoration: InputDecoration(labelText: isEnglish?"Relegion":'الديانة'),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Relegion';
              }
              return null;
            },
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
          TextFormField(
            controller: _Address_city,
            decoration: InputDecoration(labelText: isEnglish?"Governorate":'المحافظة'),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the Governorate where you belong to';
              }
              return null;
            },
          ),

          TextFormField(
            controller: _Address_street,
            decoration: InputDecoration(labelText: isEnglish?"Street or village":'الشارع او القرية'),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the Street you live in';
              }
              return null;
            },
          ),

          TextFormField(
            controller: _Address_houseNU,
            decoration: InputDecoration(labelText: isEnglish?"House Number":'رقم المنزل'),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your House Number';
              }
              return null;
            },
          ),

          TextFormField(
            controller: _Phone_number,
            decoration: InputDecoration(labelText: isEnglish?"Phone Number":'رقم الهاتف '),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Phone Number';
              }
              return null;
            },
          ),

          TextFormField(
            controller: _LandLineNumber,
            decoration: InputDecoration(labelText: isEnglish?"Land Line Number":'رقم هاتف المنزل'),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Land Line';
              }
              return null;
            },
          ),

        ],
      ),
    );
  }

  Widget _buildStage5() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isEnglish?'if you are married fill in the following, if not skip them':'ان كنت متزوجا، املأ التالي، وان لم تكن فانتقل للصفحة القادمة'),
          TextFormField(
            controller: _partnerid,
            decoration: InputDecoration(labelText: isEnglish?"Partner ID (if married)":'رقمية هوية الزوج/الزوجة'),
            style: TextStyle(color: primary),
          ),
          TextFormField(
            controller: _partnerfullname,
            decoration: InputDecoration(
                labelText: isEnglish?"Partner full name (if married)":'اسم الزوج/الزوجة كاملا'),
            style: TextStyle(color: primary),
          ),
          TextFormField(
            controller: _partnerPassportnu,
            decoration: InputDecoration(
                labelText: isEnglish?"Partner Passport Number (if married)":'رقم جواز سفر الزوج/الزوجة'),
            style: TextStyle(color: primary),
          ),
          TextFormField(
            controller: _partnerPassporttype,
            decoration: InputDecoration(
                labelText: isEnglish?"Partner Passport Type (if married)":'نوع جواز سفر الزوج/الزوجة'),
            style: TextStyle(color: primary),
          ),
          TextFormField(
            controller: _partnerPreviousfamillyname,
            decoration: InputDecoration(
                labelText: isEnglish?"Partner Previous Family Name (if married)":'اسم عائلة الزوج/الزوجة السابق'),
            style: TextStyle(color: primary),
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
              ? _buildChildrenFields(isEnglish?'Son':'الابن', _numberOfSons, _sonNameControllers,_sonIDControllers,_sonsdob)
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
              isEnglish?'Daughter':'الابنة', _numberOfDaughters, _daughterNameControllers,_daughterIDControllers,_daughtersdob)
              : SizedBox(),

          _image==null?
          ElevatedButton.icon(
            onPressed: _getImage,
            icon: Icon(Icons.image),
            label: Text(isEnglish?'Select Image of Applicant':'ارفق صورة مقدم الطلب'),
          ):Column(
            children: [
              Text(
                isEnglish?'Selected File:':'الملف المختار',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Image.memory(_image!,height: 100,),
            ],
          ),


          _OldID== null
              ? ElevatedButton.icon(
            onPressed: _getOldID,
            icon: Icon(Icons.attach_file),
            label: Text(isEnglish?'Select Picture of Old ID':'ارفق صورة الهوية القديمة'),
          )
              :   Column(
            children: [
              Text(
                isEnglish?'Selected File:':'الملف المختار',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Image.memory(_OldID!,height: 100,),
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
