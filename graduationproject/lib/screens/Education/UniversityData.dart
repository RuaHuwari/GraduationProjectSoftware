import 'package:flutter/material.dart';
import 'package:graduationproject/Constans/API.dart';
import 'package:graduationproject/screens/Education/Education.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:graduationproject/Constans/colors.dart';
import 'package:graduationproject/widgets/bottomnavigation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class University {
  final String name;
  final String governate;
  final String about;

  University({
    required this.name,
    required this.governate,
    required this.about,
  });
}

class UniversitiesData extends StatefulWidget {
  UniversitiesData({required this.userId, required this.firstname, required this.lastname, required this.name});
final String name;
  final String userId;
  final String firstname;
  final String lastname;

  @override
  State<UniversitiesData> createState() => _UniversitiesDataState();
}

class _UniversitiesDataState extends State<UniversitiesData> {
  List<University> universities = [];
  String _about = "";
  String _link = "";
  String _errorMessage = "";
  _launchURL(String url) async {
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
  Future<void> fetchUniversityData() async {
    String uri = "http://$IP/palease_api/univirsitydata.php";
    var response = await http.post(
      Uri.parse(uri),
      body: {
        "universityName": widget.name,
      },
    );
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('about') && data.containsKey('link')) {
          setState(() {
            _about = data['about'];
            _link = data['link'];
            _errorMessage = "";
          });
        } else if (data.containsKey('error')) {
          setState(() {
            _errorMessage = data['error'];
            _about = "";
            _link = "";
          });
        }
      } else {
        setState(() {
          _errorMessage = "No data received from the server";
          _about = "";
          _link = "";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Failed to fetch data. Please try again.";
        _about = "";
        _link = "";
      });
    }
  }
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    fetchUniversityData();
    if(widget.name.compareTo('Al-Najah National University')==0 || widget.name.compareTo('Al-Najah National University (Kadoory Branch)')==0)
    _controller = VideoPlayerController.asset('assets/najah.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    if(widget.name.compareTo('Birzeit')==0){
      _controller = VideoPlayerController.asset('assets/Berzeit.mp4')
        ..initialize().then((_) {
          setState(() {});
        });
    }
    if(widget.name.compareTo('Kadoory University')==0){
      _controller = VideoPlayerController.asset('assets/Kadoory.mp4')
        ..initialize().then((_) {
          setState(() {});
        });
    }
    if(widget.name.compareTo('Polytechnic')==0){
      _controller = VideoPlayerController.asset('assets/Poly.mp4')
        ..initialize().then((_) {
          setState(() {});
        });
    }
    if(widget.name.compareTo('Al-Quds University')==0){
      _controller = VideoPlayerController.asset('assets/AlQuds.mp4')
        ..initialize().then((_) {
          setState(() {});
        });
    }
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
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                Education(userId: widget.userId,
                    firstname: widget.firstname,
                    lastname: widget.lastname)));
          },
        ),
        title: Text('University Data', style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent,
        // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
           color: Colors.purple,
          ),
        ),

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
            padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
            child: Container(
              decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:20.0,right:20,top:10),
                child:SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      if (_about.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.name,style: TextStyle(
                              color: Colors.deepPurple,
                              fontFamily: 'NotoSerif',
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),),
                            Text(
                              'About:',
                  
                              style: TextStyle(fontWeight: FontWeight.bold,
                              color: Secondary,
                              fontSize: 30),
                            ),
                            Text(_about, textAlign: TextAlign.left,style: TextStyle(
                              fontFamily: 'SansSerif',
                              fontSize: 20
                            ),),
                          ],
                        ),
                      Center(
                        child: Container(
                          width: 500,
                          height: 400,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child:_controller.value.isInitialized
                                ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            )
                                : CircularProgressIndicator(),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          });
                        },
                        child: Icon(
                          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                      ),
                      SizedBox(height:50),
                      if (_link.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _launchURL(_link);
                                },
                                child: Text('Go to the Link for Applying to '+ widget.name, style: TextStyle(fontSize: 15),),
                              ),
                            ),
                            SizedBox(height:100)
                          ],
                        ),
                    ],
                  ),
                ),

              ),
            ),
          ),
          navigator.buildNavigator(context,widget.userId,widget.firstname,widget.lastname),
        ],
      ),
    );
  }
}
