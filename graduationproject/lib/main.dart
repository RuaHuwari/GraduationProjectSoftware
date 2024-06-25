import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:graduationproject/API/firebase_api.dart';
import 'package:graduationproject/screens/welcomescreen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   try {
     await Firebase.initializeApp(
       options: const FirebaseOptions(
           apiKey: 'AIzaSyCodwGR6bFCVwO4OSTCAPmtDMP4E0JT-uk',
           appId: '1:107720447480:android:2a90fab17977970558f20d',
           messagingSenderId: '107720447480',
           projectId: 'palease',
           storageBucket: "palease.appspot.com",
           authDomain: "palease.firebaseapp.com",
           databaseURL: "https://palease-default-rtdb.firebaseio.com",
          )
     );
     await FirebaseAppCheck.instance.activate();
     await FirebaseApi().initMessages();
   } catch (e) {
     print('Error initializing Firebase: $e');
   }



  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: ('inter'),
        useMaterial3: true,
      ),
      home:const WelcomeScreen(),
    );
  }
}