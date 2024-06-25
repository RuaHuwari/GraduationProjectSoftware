import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/screens/profile/Components/pickimage.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class UserProfile extends StatefulWidget {
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  UserProfile({required this.userId, required this.firstname, required this.lastname, required this.isEnglish});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Uint8List? _image;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _dob;
  String? _address;
  String? _profileImageUrl;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
 bool isEnglish=true;
  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchProfileImage();
    isEnglish=widget.isEnglish;
  }

  Future<void> _fetchUserData() async {
    final response = await http.get(Uri.parse('http://$IP/palease_api/user.php?userId=${widget.userId}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _firstName = data['first_name'];
        _lastName = data['last_name'];
        _email = data['email'];
        _dob = data['dob'];
        _address = data['address'];
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> _fetchProfileImage() async {
    final doc = await _firestore.collection('profileimage').doc(widget.userId).get();
    if (doc.exists) {
      setState(() {
        _profileImageUrl = doc['url'];
      });
    }
  }

  Future<void> _getImage() async {
      Uint8List img = await pickImage(ImageSource.gallery);
      setState(() {
        _image = img;
      });
    await _uploadProfileImage();
    }
  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }
  Future<void> _uploadProfileImage() async {
    if (_image == null) return;

    final ref = _storage.ref().child('profile_images').child('${widget.userId}.jpg');
    await ref.putData(_image!);
    final url = await ref.getDownloadURL();

    await _firestore.collection('profileimage').doc(widget.userId).set({'url': url});

    setState(() {
      _profileImageUrl = url;
    });
  }
  Future<void> _saveUserData() async {
    final response = await http.post(
      Uri.parse('http://$IP/palease_api/saveuser.php?userId=${widget.userId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'first_name': _firstName,
        'last_name': _lastName,
        'email': _email,
        'dob': _dob,
        'address': _address,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save user data');
    }
    print(response.body);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(
        context,
        isEnglish ? 'User Profile' : 'الملف الشخصي',
        widget.userId,
        widget.firstname,
        widget.lastname,
        isEnglish,
        _toggleLanguage,
      ),
      body: _firstName == null || _lastName == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            _profileImageUrl == null && _image == null
                ? CircleAvatar(radius: 50, backgroundColor: Colors.grey)
                : CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              backgroundImage: _image != null
                  ? MemoryImage(_image!) as ImageProvider
                  : _profileImageUrl != null
                  ? NetworkImage(_profileImageUrl!) as ImageProvider
                  : null,
            ),

            TextButton(
              onPressed: _getImage,
              child: Text(isEnglish?'Change Profile Image':'تغيير صورة الملف الشخصي'),
            ),
            SizedBox(height:20),
            TextField(
              decoration: InputDecoration(labelText: isEnglish?'First Name':'الاسم الاول'),
              controller: TextEditingController(text: _firstName),
              onChanged: (value) => _firstName = value,
            ),
            SizedBox(height:20),
            TextField(
              decoration: InputDecoration(labelText: isEnglish?'Last Name':'الاسم الاخير'),
              controller: TextEditingController(text: _lastName),
              onChanged: (value) => _lastName = value,
            ),
            SizedBox(height:20),
            TextField(
              decoration: InputDecoration(labelText: isEnglish?'Email':'البريد الالكتروني'),
              controller: TextEditingController(text: _email),
              onChanged: (value) => _email = value,
            ),
            SizedBox(height:20),
            TextField(
              decoration: InputDecoration(labelText: isEnglish?'Date of Birth':'تاريخ الميلاد'),
              controller: TextEditingController(text: _dob),
              onChanged: (value) => _dob = value,
            ),
            SizedBox(height:20),
            TextField(
              decoration: InputDecoration(labelText: isEnglish?'Address':'العنوان'),
              controller: TextEditingController(text: _address),
              onChanged: (value) => _address = value,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveUserData,
              child: Text(isEnglish?'Save Changes':'حفظ التغييرات'),
            ),
          ],
        ),
      ),
    );
  }
}
