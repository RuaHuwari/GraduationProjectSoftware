import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduationproject/screens/profile/Components/pickimage.dart';
import 'package:graduationproject/widgets/bottomnavigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../resources/save_data.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key,}) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  Uint8List? _image;
  StoreData _storeData = StoreData(); // Instantiate StoreData class
  String? _imageUrl; // URL of the image fetched from Firebase

  @override
  void initState() {
    super.initState();
    // Fetch the image URL from Firebase Firestore when the widget initializes
    fetchImage();
  }

  void fetchImage() async {
    // Fetch image URL from Firestore
    String? imageUrl = await _storeData.getImageUrl('407489830');
    if (imageUrl != null) {
      setState(() {
        _imageUrl = imageUrl;
      });
    }
  }
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });

    if (_image != null) {
      // Call saveData method to store the image
      String result = await _storeData.saveData(id: '407489830', file: _image!);
      print(result); // Print the result (success or error)
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          _image != null
              ? CircleAvatar(
            radius: 64,
            backgroundImage: MemoryImage(_image!),
          )
              : const CircleAvatar(
            //backgroundImage: AssetImage("assets/images/Profile Image.png"),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () {
                  selectImage();
                },
                child: SvgPicture.asset(
                  "assets/icons/Camera Icon.svg",
                  color: Color.fromRGBO(100, 19, 189, 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}