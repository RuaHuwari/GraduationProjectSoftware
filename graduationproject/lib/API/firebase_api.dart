import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi{
  Future <void> handleBackgrounmessaging(RemoteMessage message)async {
    print('title: ${message.notification?.title}');
    print('body: ${message.notification?.body}');
    print('data: ${message.data}');

  }
  final _firebaseMessaging=FirebaseMessaging.instance;

  Future <void> initMessages() async{
    await _firebaseMessaging.requestPermission();
    final fTCMToken= await _firebaseMessaging.getToken();
    print('Token: $fTCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgrounmessaging);
  }

}