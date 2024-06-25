import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:graduationproject/Constans/API.dart';
import 'package:graduationproject/resources/save_data.dart';
import 'package:graduationproject/screens/profile/Components/pickimage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/screens/HomeScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' ;
import 'package:file_picker/file_picker.dart';
import 'package:graduationproject/Constans/colors.dart';
import 'package:graduationproject/widgets/bottomnavigation.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduationproject/resources/save_data.dart';
import 'package:graduationproject/screens/payement.dart';

class NewPassport extends StatefulWidget {
  NewPassport({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
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

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _stopLoading() {
    setState(() {
      _isLoading = false;
    });
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
                          lastname: widget.lastname)),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 35,),
          onPressed: () {
            // Add your notification button onPressed logic here
            // For example, navigate to a notifications page
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
          },
        ),

        title: Text('Get New Passport', style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent,
        // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
           color: Colors.purple
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notification_add, color: Colors.white, size: 35,),
            onPressed: () {
              // Add your notification button onPressed logic here
              // For example, navigate to a notifications page
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
            },
          ),
        ],
      ),
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
            padding: const EdgeInsets.only(top: 80.0),
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
                    padding: const EdgeInsets.fromLTRB(18.0, 30.0, 18.0, 18.0),
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
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 560),
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
          navigator.buildNavigator(context,widget.userId,widget.firstname,widget.lastname),
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
                borderRadius: BorderRadius.circular(50)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'In order to get New ID, you need to have these files ready:',
                  style: TextStyle(
                    fontSize: 20,
                    color: primary,
                  ),),
                Text('1. Personal image, with Blue background.',
                    style: TextStyle(
                      fontSize: 15,
                      color: primary,

                    ), textAlign: TextAlign.left),
                Text('2. Birth Cirtificate.', style: TextStyle(
                  fontSize: 15,
                  color: primary,
                ), textAlign: TextAlign.left),
                Text('3. An agreement from the parent if you are younger than 18',
                  style: TextStyle(
                    fontSize: 15,
                    color: primary,
                  ),),
                Text('4. Career proof if you are older than 18',
                  style: TextStyle(
                    fontSize: 15,
                    color: primary,
                  ),),
                Text('5. You will need to pay 35 JOD to get the new passport',
                  style: TextStyle(
                    fontSize: 15,
                    color: primary,
                  ),),
                Text("    "),
                Text(
                  'After you get everything ready, You can proceed in this page and start filling the requirements.',
                  style: TextStyle(
                    fontSize: 15,
                    color: primary,
                  ),),

              ],
            ),
          ),
          // Example: TextFormField(), ElevatedButton(), etc.
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

  Widget _buildStage2() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Page 1', style: TextStyle(
              color: primary,
              fontSize: 20,
              fontFamily: 'SansSerif'
          ),),
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(labelText: 'First Name',),
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
            decoration: InputDecoration(labelText: 'Last Name'),
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
            decoration: InputDecoration(labelText: 'ID Number'),
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
            decoration: InputDecoration(labelText: "Gender (M/F)"),
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
                  ? 'Date of Birth'
                  : 'Date of Birth: ${_selectedDate!.toLocal()
                  .year} - ${_selectedDate!.toLocal().month} - ${_selectedDate!
                  .toLocal().day}',
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
            decoration: InputDecoration(labelText: "Father's Name",),
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
            decoration: InputDecoration(labelText: "Mother's Name",),
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
            decoration: InputDecoration(labelText: "Grandfather's Name"),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your grandfather\'s name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _placeOfBirthController,
            decoration: InputDecoration(labelText: "Place of Birth"),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Place of birth';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _Address,
            decoration: InputDecoration(labelText: "Full Address"),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Your Address';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _Phone_number,
            decoration: InputDecoration(labelText: "Phone Number"),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Phone Number';
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
      child:ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _Career,
            decoration: InputDecoration(labelText: "Career"),
            style: TextStyle(color: primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Phone Number';
              }
              return null;
            },
          ),
          _image==null?
          ElevatedButton.icon(
            onPressed: _getImage,
            icon: Icon(Icons.image),
            label: Text('Select Image of Applicant'),
          ):Column(
            children: [
              Text(
                'Selected File:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Image.memory(_image!,height: 100,),
            ],
          ),


          _birthCertificate == null
              ? ElevatedButton.icon(
            onPressed: _getBirthCertificate,
            icon: Icon(Icons.attach_file),
            label: Text('Select Birth Certificate'),
          )
              :   Column(
            children: [
              Text(
                'Selected File:',
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
              label: Text('Select Picture of statment'),
            ):Column(
              children: [
                Text(
                  'Selected File:',
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
              label: Text('Select Picture of career proof'),
            ):Column(
              children: [
                Text(
                  'Selected File:',
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
                MaterialPageRoute(builder: (context) => pay(applicationID: applicationID.toString(),price:2,firstname:widget.firstname,lastname:widget.lastname,userId:widget.userId)),
              );
            },
            child: Text('Submit'),
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
