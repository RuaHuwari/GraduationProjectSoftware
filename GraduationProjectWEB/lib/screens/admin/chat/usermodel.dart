
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromFirestore(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      name: doc['name'],
    );
  }
}

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final Timestamp timestamp;

  Message({required this.senderId, required this.receiverId, required this.text, required this.timestamp});

  factory Message.fromFirestore(DocumentSnapshot doc) {
    return Message(
      senderId: doc['senderId'],
      receiverId: doc['receiverId'],
      text: doc['text'],
      timestamp: doc['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
