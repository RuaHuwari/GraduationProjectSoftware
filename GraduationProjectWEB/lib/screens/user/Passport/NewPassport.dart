import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/resources/save_data.dart';
import 'package:graduationprojectweb/screens/profile/Components/pickimage.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/screens/user/HomeScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduationprojectweb/screens/user/payement.dart';

class NewPassport extends StatefulWidget {
  NewPassport({ required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;
  @override
  _NewIDState createState() => _NewIDState();
}

class _NewIDState extends State<NewPassport> {
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
  TextEditingController _placeOfBirthController = TextEditingController();
  TextEditingController _Address = TextEditingController();
  TextEditingController _Phone_number = TextEditingController();
  TextEditingController _Career = TextEditingController();

  bool imageAvailable = false;
  late int applicationID;

  late TextEditingController userIdController;
  String selectedValue='all';
  Uint8List? _birthCertificate;
  Uint8List? _fatheragreement;
  Uint8List? _careerimg;
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  bool _isLoading = false;

  String t(String key) {
    const translations = {
      'title': ['New Passport', 'جواز سفر جديد'],
      'stage1_text': ['In order to get New ID, you need to have these files ready:', 'للحصول على هوية جديدة، يجب أن تكون هذه الملفات جاهزة:'],
      'stage1_file1': ['1. Personal image, with Blue background.', '1. صورة شخصية بخلفية زرقاء.'],
      'stage1_file2': ['2. Birth Certificate.', '2. شهادة الميلاد.'],
      'stage1_file3': ['3. An agreement from the parent if you are younger than 18.', '3. موافقة من ولي الأمر إذا كنت أقل من 18 عامًا.'],
      'stage1_file4': ['4. Career proof if you are older than 18.', '4. إثبات مهنة إذا كنت أكبر من 18 عامًا.'],
      'stage1_file5': ['5. You will need to pay 35 JOD to get the new passport.', '5. ستحتاج إلى دفع 35 دينار للحصول على جواز السفر الجديد.'],
      'stage1_note': ['After you get everything ready, You can proceed in this page and start filling the requirements.', 'بعد أن تكون جميع المستندات جاهزة، يمكنك المتابعة في هذه الصفحة وبدء ملء المتطلبات.'],
      'page_1': ['Page 1', 'الصفحة 1'],
      'first_name': ['First Name', 'الاسم الأول'],
      'first_name_validation': ['Please enter your first name', 'يرجى إدخال اسمك الأول'],
      'last_name': ['Last Name', 'اسم العائلة'],
      'last_name_validation': ['Please enter your last name', 'يرجى إدخال اسم العائلة'],
      'id_number': ['ID Number', 'رقم الهوية'],
      'id_number_validation': ['Please enter your ID number', 'يرجى إدخال رقم الهوية'],
      'gender': ['Gender (M/F)', 'الجنس (ذكر/أنثى)'],
      'gender_validation': ['Please enter your Gender', 'يرجى إدخال الجنس'],
      'dob': ['Date of Birth', 'تاريخ الميلاد'],
      'fathers_name': ["Father's Name", 'اسم الأب'],
      'fathers_name_validation': ["Please enter your father's name", 'يرجى إدخال اسم الأب'],
      'mothers_name': ["Mother's Name", 'اسم الأم'],
      'mothers_name_validation': ["Please enter your mother's name", 'يرجى إدخال اسم الأم'],
      'grandfathers_name': ["Grandfather's Name", 'اسم الجد'],
      'grandfathers_name_validation': ["Please enter your grandfather's name", 'يرجى إدخال اسم الجد'],
      'place_of_birth': ['Place of Birth', 'مكان الميلاد'],
      'place_of_birth_validation': ['Please enter your Place of birth', 'يرجى إدخال مكان الميلاد'],
      'full_address': ['Full Address', 'العنوان الكامل'],
      'address_validation': ['Please enter Your Address', 'يرجى إدخال العنوان'],
      'phone_number': ['Phone Number', 'رقم الهاتف'],
      'phone_number_validation': ['Please enter your Phone Number', 'يرجى إدخال رقم الهاتف'],
      'career': ['Career', 'المهنة'],
      'career_validation': ['Please enter your Career', 'يرجى إدخال المهنة'],
      'select_image': ['Select Image of Applicant', 'اختر صورة المتقدم'],
      'select_birth_certificate': ['Select Birth Certificate', 'اختر شهادة الميلاد'],
      'select_father_agreement': ['Select Picture of statement', 'اختر صورة للبيان'],
      'select_career_proof': ['Select Picture of career proof', 'اختر صورة لإثبات المهنة'],
      'submit': ['Submit', 'إرسال'],
      'selected_file': ['Selected File:', 'الملف المحدد:'],
    };

    return isEnglish ? translations[key]![0] : translations[key]![1];
  }
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
        String applicationid = "2";
        String departmentid = "2";
        // Send POST request to the server
        String uri="http://$IP/palease_api/insert_application.php";
        var response=await http.post(Uri.parse(uri),body: {
          'id':ID,
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
      print('1');

      String _imageurl=await storeData.UploadImageToStorage(applicationId+'personal image',_image!) ;
      print('2');
      String _birthurl=await storeData.UploadImageToStorage(applicationId+'Birth Certificate',_birthCertificate!) ;
      print('3');

      String _fatheragreementurl='';
      if(_isUnderage(_selectedDate!))
      _fatheragreementurl=await storeData.UploadImageToStorage(applicationId+'fatheragreement', _fatheragreement!);
      print('4');
      String _careerurl='';
      if(_isUnderage(_selectedDate!)==false)
      _careerurl=await storeData.UploadImageToStorage(applicationId+'careerproof', _careerimg!);
      // Check if there are existing images with the same ID
      final QuerySnapshot querySnapshot = await _firestore
          .collection("IDApplication")
          .where('id', isEqualTo: applicationId)
          .where('user_id', isEqualTo: widget.userId)
          .where('department_id', isEqualTo: 2)
          .where('ApplicantID', isEqualTo: _idNumberController.text)
          .where('applicationID', isEqualTo: 2)
          .get();

      // If there are existing images, delete them
      for (DocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      await _firestore.collection("IDApplications").add({
        'id': applicationId,
        'applicationID': 2,
        'departmentID':2,
        'user_id':widget.userId,
        'FirstName':_firstNameController.text,
        'LastName': _lastNameController.text,
        'ApplicantID': _idNumberController.text,
        'DateOfBirth':_selectedDate.toString(),
        'Gender':_SexController.text,
        'FatherName':_fatherNameController.text,
        'MotherName':_motherNameController.text,
        'GrandFatherName':_grandfatherNameController.text,
        'PlaceOfBirth': _placeOfBirthController.text,
        'Address': _Address.text,
        'PhoneNumber':_Phone_number.text,
        'Career':_Career.text,
        'personalimage':_imageurl,
        'BirthCertificate':_birthurl,
        if(_isUnderage(_selectedDate!))
        'father Agreement':_fatheragreementurl,
        if(_isUnderage(_selectedDate!)==false)
        'career proof':_careerurl,
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
  Future<void> _getFatherAgreement() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _fatheragreement = img;
    });
  }
  Future<void> _getcareer() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _careerimg = img;
    });
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
      appBar: buildabbbar.buildAbbbar(context, isEnglish?'New Passport':'اصدار جواز سفر جديد', widget.userId, widget.firstname, widget.lastname,isEnglish,_toggleLanguage),
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
            padding: const EdgeInsets.only(top: 40.0,left:50,right:50),
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
                    padding: const EdgeInsets.fromLTRB(80.0, 18.0, 80.0, 18.0),
                    child:
                    PageView(
                      controller: _pageController,
                      physics: NeverScrollableScrollPhysics(),
                      // Disable swiping
                      children: [
                        _buildStage1(),
                        _buildStage2(),
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
            padding: EdgeInsets.only(top: 560,left:100),
            child: Row(
              children: [
                if (_currentPageIndex != 0)
                  IconButton(
                    padding: EdgeInsets.only(left: 260),
                    icon: Icon(Icons.arrow_back),
                    onPressed: _previousPage,
                    color: primary,

                  ),
                if (_currentPageIndex !=3) // Change 2 to the total number of stages - 1
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
                    t('stage1_text'),
                    style: TextStyle(fontSize: 30, color: primary),
                  ),
                  SizedBox(height: 50),
                  Text(
                    t('stage1_file1'),
                    style: TextStyle(fontSize: 25, color: primary),
                  ),
                  Text(
                    t('stage1_file2'),
                    style: TextStyle(fontSize: 25, color: primary),
                  ),
                  Text(
                    t('stage1_file3'),
                    style: TextStyle(fontSize: 25, color: primary),
                  ),
                  Text(
                    t('stage1_file4'),
                    style: TextStyle(fontSize: 25, color: primary),
                  ),
                  Text(
                    t('stage1_file5'),
                    style: TextStyle(fontSize: 25, color: primary),
                  ),
                  Text("    "),
                  Text(
                    t('stage1_note'),
                    style: TextStyle(fontSize: 25, color: primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStage2() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('page_1'),
            style: TextStyle(color: primary, fontSize: 20, fontFamily: 'SansSerif'),
          ),
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(labelText: t('first_name')),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('first_name_validation');
              }
              return null;
            },
          ),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(labelText: t('last_name')),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('last_name_validation');
              }
              return null;
            },
          ),
          TextFormField(
            controller: _idNumberController,
            decoration: InputDecoration(labelText: t('id_number')),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('id_number_validation');
              }
              return null;
            },
          ),
          TextFormField(
            controller: _SexController,
            decoration: InputDecoration(labelText: t('gender')),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('gender_validation');
              }
              return null;
            },
          ),
          ListTile(
            title: Text(
              _selectedDate == null
                  ? t('dob')
                  : '${t('dob')}: ${_selectedDate!.toLocal().year} - ${_selectedDate!.toLocal().month} - ${_selectedDate!.toLocal().day}',
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
          Text(
            t('page_1'),
            style: TextStyle(color: primary, fontSize: 20, fontFamily: 'SansSerif'),
          ),
          TextFormField(
            controller: _fatherNameController,
            decoration: InputDecoration(labelText: t('fathers_name')),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('fathers_name_validation');
              }
              return null;
            },
          ),
          TextFormField(
            controller: _motherNameController,
            decoration: InputDecoration(labelText: t('mothers_name')),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('mothers_name_validation');
              }
              return null;
            },
          ),
          TextFormField(
            controller: _grandfatherNameController,
            decoration: InputDecoration(labelText: t('grandfathers_name')),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('grandfathers_name_validation');
              }
              return null;
            },
          ),
          TextFormField(
            controller: _placeOfBirthController,
            decoration: InputDecoration(labelText: t('place_of_birth')),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('place_of_birth_validation');
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  bool _isUnderage(DateTime dob) {
    final now = DateTime.now();
    var age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age < 18;
  }

  Widget _buildStage4() {
    return Container(
      padding: EdgeInsets.all(20),
      child:ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _Address,
            decoration: InputDecoration(labelText: t('full_address')),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('address_validation');
              }
              return null;
            },
          ),
          TextFormField(
            controller: _Phone_number,
            decoration: InputDecoration(labelText: t('phone_number')),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('phone_number_validation');
              }
              return null;
            },
          ),
          TextFormField(
            controller: _Career,
            decoration: InputDecoration(labelText: t('career')),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t('career_validation');
              }
              return null;
            },
          ),
          _image==null?
          ElevatedButton.icon(
            onPressed: _getImage,
            icon: Icon(Icons.image),
            label: Text(t('select_image')),
          ):Column(
            children: [
              Text(
                t('selected_file'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Image.memory(_image!,height: 100,),
            ],
          ),


          _birthCertificate == null
              ? ElevatedButton.icon(
            onPressed: _getBirthCertificate,
            icon: Icon(Icons.attach_file),
            label: Text(t('select_birth_certificate')),
          )
              :   Column(
            children: [
              Text(
                t('selected_file'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Image.memory(_birthCertificate!,height: 100,),
            ],
          ),
          if (_selectedDate != null && _isUnderage(_selectedDate!))
            _fatheragreement==null?
            ElevatedButton.icon(
              onPressed: _getFatherAgreement,
              icon: Icon(Icons.image),
              label: Text(t('select_father_agreement')),
            ):Column(
              children: [
                Text(
                  t('selected_file'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Image.memory(_fatheragreement!,height: 100,),
              ],
            ),
          if(_selectedDate!=null && _isUnderage(_selectedDate!)==false)
            _careerimg==null?
            ElevatedButton.icon(
              onPressed: _getcareer,
              icon: Icon(Icons.image),
              label: Text(t('select_career_proof')),
            ):Column(
              children: [
                Text(
                  t('selected_file'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Image.memory(_careerimg!,height: 100,),
              ],
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {

              applicationID = await fetchData();
              print(applicationID);
              applicationID++;
              print(applicationID);
              _saveData(applicationID.toString(),_selectedDate.toString(), _firstNameController.text,  'Not Done', );
              _saveApplicationIdToFirestore(applicationID.toString());
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pay(applicationID: applicationID.toString(),price:2,firstname:widget.firstname,lastname:widget.lastname,userId:widget.userId, isEnglish: isEnglish,)),
              );
            },
            child: Text(t('submit')),
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
