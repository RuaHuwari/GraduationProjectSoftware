import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/screens/chat/chatdetail.dart';
import 'package:graduationproject/screens/chat/newchat.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Constans/API.dart';
import '../../widgets/bottomnavigation.dart';

class ChatScreen extends StatefulWidget {
  final String firstname;
  final String lastname;
  final String userId;

  ChatScreen({
    required this.firstname,
    required this.lastname,
    required this.userId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Chats ', style: TextStyle(
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
      ),
      body: Stack(
        children: [StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .where('users', arrayContains: widget.userId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No chats available'));
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
                      return ListTile(title: Text('Loading...'));
                    }
                    if (userSnapshot.hasError) {
                      return ListTile(title: Text('Error loading user: ${userSnapshot.error}'));
                    }
                    if (!userSnapshot.hasData) {
                      return ListTile(title: Text('User not found'));
                    }

                    var userName = userSnapshot.data!.name;

                    return ListTile(
                      title: Text(userName,style: TextStyle(color: Colors.purple),),
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
                              workername: userName
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
          Padding(
            padding: const EdgeInsets.only(top:600.0,left:300),
            child: Container(
              height: 70,
              width:70,
              decoration: BoxDecoration(
                color: Colors.purple[200],
                borderRadius: BorderRadius.circular(20)
              ),
              child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.add),
                iconSize: 40,
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
            ),
          ),
          navigator.buildNavigator(context, widget.userId, widget.firstname, widget.lastname)
    ],
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
      name: json['first_name']+ ' '+ json['last_name'],
    );
  }
}
