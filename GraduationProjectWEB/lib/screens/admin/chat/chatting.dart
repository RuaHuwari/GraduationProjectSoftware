import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/screens/admin/Notify.dart';
import 'package:graduationprojectweb/screens/admin/applications.dart';
import 'package:graduationprojectweb/screens/admin/chat/chatdetail.dart';
import 'package:graduationprojectweb/screens/admin/chat/newchat.dart';
import 'package:graduationprojectweb/screens/admin/dashboardscreen.dart';
import 'package:graduationprojectweb/screens/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final String firstname;
  final String lastname;
  final String userId;
  final bool showNotify;
  final bool showapplications;

  ChatScreen({
    required this.firstname,
    required this.lastname,
    required this.userId,
    required this.showNotify,
    required this.showapplications,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedIndex = 0;

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
    if (widget.showNotify && widget.showapplications) {
      setState(() {
        _selectedIndex = 3;
      });
    } else if (widget.showapplications) {
      setState(() {
        _selectedIndex = 2;
      });
    } else {
      setState(() {
        _selectedIndex = 1;
      });
    }
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationRail(
            extended: false,
            backgroundColor: Colors.deepPurple.shade400,
            unselectedIconTheme: IconThemeData(color: Colors.white, opacity: 1),
            unselectedLabelTextStyle: TextStyle(
              color: Colors.white,
            ),
            selectedIconTheme: IconThemeData(color: Colors.deepPurple.shade900),
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text("Home"),
              ),
              if (widget.showNotify)
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart),
                  label: Text("Notify Users"),
                ),
              if (widget.showapplications)
                NavigationRailDestination(
                  icon: Icon(Icons.book_outlined),
                  label: Text("Applications"),
                ),
              NavigationRailDestination(
                icon: Icon(Icons.move_to_inbox),
                label: Text("Inbox"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.logout),
                label: Text("Log Out"),
              ),
            ],
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index; // Update the selectedIndex state variable

                // Perform actions based on the selected index
                switch (index) {
                  case 0:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardScreen(
                              userId: widget.userId,
                              firstname: widget.firstname,
                              lastname: widget.lastname)),
                    );
                    break;
                  case 1:
                  // Action for Reports
                    if (widget.showNotify)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Notify(
                                userId: widget.userId,
                                firstname: widget.firstname,
                                lastname: widget.lastname,
                                showNotify: true,
                                showapplications: true)),
                      );
                    else if (widget.showapplications) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Applications(
                                userId: widget.userId,
                                firstname: widget.firstname,
                                lastname: widget.lastname,
                                showNotify: widget.showNotify,
                                showapplications: widget.showapplications)),
                      );
                    } else
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                userId: widget.userId,
                                firstname: widget.firstname,
                                lastname: widget.lastname,
                                showNotify: widget.showNotify,
                                showapplications: widget.showapplications)),
                      );
                    break;
                  case 2:
                    if (widget.showNotify && widget.showapplications)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Applications(
                                userId: widget.userId,
                                firstname: widget.firstname,
                                lastname: widget.lastname,
                                showNotify: widget.showNotify,
                                showapplications: widget.showapplications)),
                      );
                    else if (widget.showapplications)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                userId: widget.userId,
                                firstname: widget.firstname,
                                lastname: widget.lastname,
                                showNotify: widget.showNotify,
                                showapplications: widget.showapplications)),
                      );
                    else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const home()),
                      );
                    }
                    break;
                  case 3:
                    if (widget.showNotify && widget.showapplications)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                userId: widget.userId,
                                firstname: widget.firstname,
                                lastname: widget.lastname,
                                showNotify: widget.showNotify,
                                showapplications: widget.showapplications)),
                      );
                    else if (widget.showapplications) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const home()),
                      );
                    }
                    break;
                  case 4:
                    if (widget.showNotify && widget.showapplications)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const home()),
                      );
                    break;
                  default:
                  // Default action or error handling
                    break;
                }
              });
            },
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inbox',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder(
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
                          var otherUserId = chatData['users']
                              .firstWhere((id) => id != widget.userId);
                          var lastMessage = chatData['lastMessage'] ?? '';

                          return FutureBuilder<User>(
                            future: fetchUser(otherUserId),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return ListTile(title: Text('Loading...'));
                              }
                              if (userSnapshot.hasError) {
                                return ListTile(
                                    title: Text(
                                        'Error loading user: ${userSnapshot.error}'));
                              }
                              if (!userSnapshot.hasData) {
                                return ListTile(
                                    title: Text('User not found'));
                              }

                              var userName = userSnapshot.data!.name;

                              return ListTile(
                                title: Text(
                                  userName,
                                  style: TextStyle(
                                      fontSize: 23,
                                      color: Colors.deepPurpleAccent,
                                      fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  lastMessage,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatDetailScreen(
                                        chatId: chat.id,
                                        firstname: widget.firstname,
                                        lastname: widget.lastname,
                                        userid: widget.userId,
                                        username: userName, showNotify: widget.showNotify, showapplications: widget.showapplications,
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
                ),
              ],
            ),
          ),
        ],
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
                userId: widget.userId, showNotify: widget.showNotify, showapplications: widget.showapplications,
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
      name: json['first_name'],
    );
  }
}
