import 'package:firebase_messaging/firebase_messaging.dart';
class FirebaseApi{
  final _firebaseMessaging=FirebaseMessaging.instance;
  Future <void> initMessages() async{
    await _firebaseMessaging.requestPermission();
    final fTCMToken= await _firebaseMessaging.getToken();
    print('Token: $fTCMToken');
  }
}