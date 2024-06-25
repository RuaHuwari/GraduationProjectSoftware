import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/screens/admin/chat/chatdetail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<User>> fetchUsers() async {
  final response = await http.get(Uri.parse('http://$IP/palease_api/users.php'));

  if (response.statusCode == 200) {
    final List<dynamic> usersJson = json.decode(response.body);
    return usersJson.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}

class User {
  final String id;
  final String firstname;
  final String lastname;

  User({required this.id, required this.firstname, required this.lastname});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      firstname: json['first_name'],
      lastname: json['last_name'],
    );
  }
}

class NewChatScreen extends StatefulWidget {
  NewChatScreen({super.key, required this.firstname, required this.lastname, required this.userId, required this.showNotify, required this.showapplications});
  final String firstname,lastname,userId;
  final bool showNotify, showapplications;

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  late Future<List<User>> futureUsers;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
  }

  Future<void> _startChatWithUser(String userId, String userFirstName, String userLastName) async {
    String currentUserId = widget.userId; // Replace with the admin's user ID
    var chatQuery = await FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: currentUserId)
        .get();

    String? existingChatId;
    for (var doc in chatQuery.docs) {
      var users = List<String>.from(doc['users']);
      if (users.contains(userId)) {
        existingChatId = doc.id;
        break;
      }
    }

    if (existingChatId != null) {
      // Open existing chat
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailScreen(
            chatId: existingChatId!,
            firstname: widget.firstname,
            lastname: widget.lastname,
            userid: widget.userId,
            username: userFirstName+ userLastName, showNotify: widget.showNotify, showapplications: widget.showapplications,
          ),
        ),
      );
    } else {
      // Create a new chat
      var newChatId = FirebaseFirestore.instance.collection('chats').doc().id;
      FirebaseFirestore.instance.collection('chats').doc(newChatId).set({
        'users': [currentUserId, userId],
        'lastMessage': '',
        'timestamp': Timestamp.now(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailScreen(
            chatId: newChatId,
            firstname: widget.firstname,
            lastname: widget.lastname,
            userid: widget.userId,
            username: userFirstName+ userLastName, showNotify: widget.showNotify, showapplications: widget.showapplications,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Start New Chat')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by User ID',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final users = snapshot.data!
                      .where((user) => user.id.contains(searchQuery))
                      .toList();
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        title: Text('${user.firstname} ${user.lastname}'),
                        subtitle: Text('ID: ${user.id}'),
                        onTap: () => _startChatWithUser(user.id, user.firstname, user.lastname),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
