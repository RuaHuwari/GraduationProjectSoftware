import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Orphanage {
  final String name;
  final String governate;
  final String about;

  Orphanage({
    required this.name,
    required this.governate,
    required this.about,
  });
}

class orphanagedata extends StatefulWidget {
  orphanagedata({
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.id, required this.isEnglish,
  });

  final String id;
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  State<orphanagedata> createState() => _orphanagedataState();
}

class _orphanagedataState extends State<orphanagedata> {
  bool isEnglish = true;

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  List<Orphanage> universities = [];
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
        "universityName": widget.id,
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
    isEnglish = widget.isEnglish;
   // fetchUniversityData();
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
        // Pass the language state to the app bar
      ),
    );
  }
}
