import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/widgets/bottomnavigation.dart';
import 'package:graduationproject/widgets/buildbutton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
class ID extends StatefulWidget {
  ID({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  _IDState createState() => _IDState();
}

class _IDState extends State<ID> {
  String? _filePath;

  Future<void> _openFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _filePath = result.files.single.path!;
        });
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('ID Services', style: TextStyle(
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
      body:Stack(

        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
           color: Colors.purple
            ),

            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 22),
              child:Text('What would you like to do?',style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),),
            ),
          ),
          Padding(padding: const EdgeInsets.only(top:0,left:30,right: 30),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButton.buildbutton(context, 'newID', 'Get New ID', 'assets/document.png',widget.userId,widget.firstname,widget.lastname),
                buildButton.buildbutton(context, 'lostID', 'Lost ID', 'assets/data-loss.png',widget.userId,widget.firstname,widget.lastname),
                buildButton.buildbutton(context, 'renewID', 'Renew ID', 'assets/renewal.png',widget.userId,widget.firstname,widget.lastname)

              ],
            ),
          ),
          navigator.buildNavigator(context,widget.userId,widget.firstname,widget.lastname)
        ],

      ),
    );
  }
}