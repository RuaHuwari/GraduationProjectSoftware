import 'dart:convert';
import 'dart:typed_data';
import 'package:graduationproject/Constans/API.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/widgets/bottomnavigation.dart';
import 'package:image_picker/image_picker.dart';
import '../../Constans/colors.dart';
import '../../resources/save_data.dart';
import '../HomeScreen.dart';
import '../payement.dart';
import '../profile/Components/pickimage.dart';

class LostID extends StatefulWidget {
  LostID({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;

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
      String id,
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
        String numberofsonsStr = numberofsons.toString();
        String numberofdaughtersStr = numberofdaughters.toString();
        // Send POST request to the server
        String uri="http://$IP/palease_api/insert_application.php";
        var response=await http.post(Uri.parse(uri),body: {
          'id':id,
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
                    ? 'Date of Birth'
                    : 'Date of Birth: ${dateControllers[i].toLocal().year} - ${dateControllers[i].toLocal().month} - ${dateControllers[i].toLocal().day}',
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Lost ID ', style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent, // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.purple
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notification_add,color: Colors.white,size: 35,),
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
                        Container(
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
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color:Colors.white
                  ),
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
          ),

        ],
      ),
    );
  }

  Widget _buildStage1() {
    return Container(
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
                  'In order to get a New ID, you need to have these files ready:',
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
                Text('3. A Copy of the ID of one of the parents.',
                  style: TextStyle(
                    fontSize: 15,
                    color: primary,
                  ),),
                Text('4. You will need to pay a fee of 24.00 JOD.',
                  style: TextStyle(
                    fontSize: 15,
                    color: primary,
                  ),),
                Text("5. You must go to the police station and submit a report" ,style: TextStyle(
                  fontSize: 15,
                  color: primary,
                ),),
                Text("6. You must post a missing annoncement on newspaper" ,style: TextStyle(
                  fontSize: 15,
                  color: primary,
                ),),
                Text("7. bring in the papers that proves you did step 5 & 6 ( a photo of the police report, and a one of the newspaper announcement) " ,style: TextStyle(
                  fontSize: 15,
                  color: primary,
                ),),
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

  Widget _buildStage2() {
    return Container(
      padding: EdgeInsets.all(0),
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
            controller: _StatusController,
            decoration: InputDecoration(labelText: "Marital Status"),
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
                labelText: "Previous family name (if available)"),
            style: TextStyle(color: primary),
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
            controller: _Relegion,
            decoration: InputDecoration(labelText: "Relegion"),
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
            decoration: InputDecoration(labelText: "Governorate"),
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
            decoration: InputDecoration(labelText: "Street or village"),
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
            decoration: InputDecoration(labelText: "House Number"),
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
            decoration: InputDecoration(labelText: "Phone Number"),
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
            decoration: InputDecoration(labelText: "Land Line Number"),
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
          Text('if you are married fill in the following, if not skip them'),
          TextFormField(
            controller: _partnerid,
            decoration: InputDecoration(labelText: "Partner ID (if married)"),
            style: TextStyle(color: primary),
          ),
          TextFormField(
            controller: _partnerfullname,
            decoration: InputDecoration(
                labelText: "Partner full name (if married)"),
            style: TextStyle(color: primary),
          ),
          TextFormField(
            controller: _partnerPassportnu,
            decoration: InputDecoration(
                labelText: "Partner Passport Number (if married)"),
            style: TextStyle(color: primary),
          ),
          TextFormField(
            controller: _partnerPassporttype,
            decoration: InputDecoration(
                labelText: "Partner Passport Type (if married)"),
            style: TextStyle(color: primary),
          ),
          TextFormField(
            controller: _partnerPreviousfamillyname,
            decoration: InputDecoration(
                labelText: "Partner Previous Family Name (if married)"),
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
            decoration: InputDecoration(labelText: 'Number of Sons'),
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
              ? _buildChildrenFields('Son', _numberOfSons, _sonNameControllers,_sonIDControllers,_sonsdob)
              : SizedBox(),
          TextFormField(
            decoration: InputDecoration(labelText: 'Number of Daughters'),
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
              'Daughter', _numberOfDaughters, _daughterNameControllers,_daughterIDControllers,_daughtersdob)
              : SizedBox(),

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
          _NewsPaperAnnouncement == null
              ? ElevatedButton.icon(
            onPressed: _getNewsPaper,
            icon: Icon(Icons.attach_file),
            label: Text('Select Picture of NewsPaper Announcement'),
          )
              :   Column(
            children: [
              Text(
                'Selected File:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Image.memory(_NewsPaperAnnouncement!,height: 100,),
            ],
          ),
          _Police == null
              ? ElevatedButton.icon(
            onPressed: _getPolice,
            icon: Icon(Icons.attach_file),
            label: Text('Select Picture of the police report'),
          )
              :   Column(
            children: [
              Text(
                'Selected File:',
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
              _saveData(applicationID.toString(),_selectedDate.toString(), _firstNameController.text,_numberOfSons, _numberOfDaughters, 'Not Done', _StatusController.text);
              _saveApplicationIdToFirestore(applicationID.toString());
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pay(applicationID: applicationID.toString(),price:20,firstname:widget.firstname,lastname:widget.lastname,userId:widget.userId)),
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