import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
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
  UniversitiesData({
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.name, required this.isEnglish,
  });

  final String name;
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  State<UniversitiesData> createState() => _UniversitiesDataState();
}

class _UniversitiesDataState extends State<UniversitiesData> {
  bool isEnglish = true;

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  List<University> universities = [];
  String _about = "";
  String _aboutArabic = "";
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
        if (data.containsKey('about') && data.containsKey('link') && data.containsKey('about_arabic')) {
          setState(() {
            _about = data['about'];
            _link = data['link'];
            _aboutArabic = data['about_arabic'];
            _errorMessage = "";
          });
        } else if (data.containsKey('error')) {
          setState(() {
            _errorMessage = data['error'];
            _about = "";
            _link = "";
            _aboutArabic = "";
          });
        }
      } else {
        setState(() {
          _errorMessage = "No data received from the server";
          _about = "";
          _link = "";
          _aboutArabic = "";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Failed to fetch data. Please try again.";
        _about = "";
        _link = "";
        _aboutArabic = "";
      });
    }
  }

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    isEnglish = widget.isEnglish;
    fetchUniversityData();
    _initializeVideoController();
  }

  void _initializeVideoController() {
    if (widget.name.compareTo('Al-Najah National University') == 0 ||
        widget.name.compareTo('Al-Najah National University (Kadoory Branch)') == 0)
      _controller = VideoPlayerController.asset('assets/najah.mp4')
        ..initialize().then((_) {
          setState(() {});
        });
    if (widget.name.compareTo('Birzeit') == 0) {
      _controller = VideoPlayerController.asset('assets/Berzeit.mp4')
        ..initialize().then((_) {
          setState(() {});
        });
    }
    if (widget.name.compareTo('Kadoory University') == 0) {
      _controller = VideoPlayerController.asset('assets/Kadoory.mp4')
        ..initialize().then((_) {
          setState(() {});
        });
    }
    if (widget.name.compareTo('Polytechnic') == 0) {
      _controller = VideoPlayerController.asset('assets/Poly.mp4')
        ..initialize().then((_) {
          setState(() {});
        });
    }
    if (widget.name.compareTo('Al-Quds University') == 0) {
      _controller = VideoPlayerController.asset('assets/AlQuds.mp4')
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(
        context,
        isEnglish ? 'University Info' : 'معلومات الجامعة',
        widget.userId,
        widget.firstname,
        widget.lastname,
        isEnglish,
        _toggleLanguage, // Pass the toggle method to the app bar
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.purple,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 50, right: 50),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      if (_about.isNotEmpty || _aboutArabic.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontFamily: 'NotoSerif',
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              isEnglish ? 'About:' : 'حول:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Secondary,
                                fontSize: 30,
                              ),
                            ),
                            Text(
                              isEnglish ? _about : _aboutArabic,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'SansSerif',
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      Center(
                        child: Container(
                          width: 500,
                          height: 400,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: _controller.value.isInitialized
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
                      SizedBox(height: 50),
                      if (_link.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _launchURL(_link);
                                },
                                child: Text(
                                  isEnglish
                                      ? 'Go to the Link for Applying to ${widget.name}'
                                      : 'اذهب إلى الرابط للتقديم في ${widget.name}',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            SizedBox(height: 100),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
