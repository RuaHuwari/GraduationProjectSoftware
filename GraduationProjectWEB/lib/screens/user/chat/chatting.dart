import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/screens/user/chat/chatdetail.dart';
import 'package:graduationprojectweb/screens/user/chat/newchat.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final String firstname;
  final String lastname;
  final String userId;
  final bool isEnglish;

  ChatScreen({
    required this.firstname,
    required this.lastname,
    required this.userId,
    required this.isEnglish
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isEnglish = true;

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  Future<User> fetchUser(String userId) async {
    final response = await http.get(Uri.parse('http://$IP/palease_api/getUser.php?userId=$userId'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(
        context,
        isEnglish ? 'Chats' : 'الدردشات',
        widget.userId,
        widget.firstname,
        widget.lastname,
        isEnglish,
        _toggleLanguage,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('users', arrayContains: widget.userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(isEnglish ? 'Error: ${snapshot.error}' : 'خطأ: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(isEnglish ? 'No chats available' : 'لا توجد دردشات متاحة'));
          }

          var chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index];
              var chatData = chat.data() as Map<String, dynamic>;
              var otherUserId = chatData['users'].firstWhere((id) => id != widget.userId);
              var lastMessage = chatData['lastMessage'] ?? '';

              return FutureBuilder<User>(
                future: fetchUser(otherUserId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(title: Text(isEnglish ? 'Loading...' : 'جار التحميل...'));
                  }
                  if (userSnapshot.hasError) {
                    return ListTile(title: Text(isEnglish ? 'Error loading user: ${userSnapshot.error}' : 'خطأ في تحميل المستخدم: ${userSnapshot.error}'));
                  }
                  if (!userSnapshot.hasData) {
                    return ListTile(title: Text(isEnglish ? 'User not found' : 'المستخدم غير موجود'));
                  }

                  var userName = userSnapshot.data!.name;

                  return ListTile(
                    title: Text(userName, style: TextStyle(color: Colors.purple)),
                    subtitle: Text(lastMessage),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailScreen(
                            chatId: chat.id,
                            firstname: widget.firstname,
                            lastname: widget.lastname,
                            userid: widget.userId,
                            workername: userName,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewChatScreen(
                firstname: widget.firstname,
                lastname: widget.lastname,
                userId: widget.userId,
              ),
            ),
          );
        },
      ),
    );
  }
}

class User {
  final String id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['first_name'] + ' ' + json['last_name'],
    );
  }
}
