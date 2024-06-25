import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graduationprojectweb/API/firebase_api.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:graduationprojectweb/screens/home.dart';
import 'package:webview_all/webview_all.dart';
class PlatformUtils {
  static bool get isMobile {
    if (kIsWeb) {
      return false;
    } else {
      return Platform.isIOS || Platform.isAndroid;
    }
  }

  static bool get isDesktop {
    if (kIsWeb) {
      return false;
    } else {
      return Platform.isLinux || Platform.isFuchsia || Platform.isWindows || Platform.isMacOS;
    }
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBZBczR4oKUf8r-Rqoyl3p8Y-d8q3vqY3w",
            authDomain: "palease.firebaseapp.com",
            databaseURL: "https://palease-default-rtdb.firebaseio.com",
            projectId: "palease",
            storageBucket: "palease.appspot.com",
            messagingSenderId: "107720447480",
            appId: "1:107720447480:web:6202108be143071158f20d")
    );
    await FirebaseAppCheck.instance.activate();

  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  // Stripe.publishableKey = 'pk_test_51POdSTP53P5Ck9Xo5EyfpHkcQjTtL4AK02eHOEHxFeRac95yqv7tC9lHasJKECuk65ut5DYfGCubaGtGIX6KoZIt00FOJyJdhl';


  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home(),
    );
  }

}
