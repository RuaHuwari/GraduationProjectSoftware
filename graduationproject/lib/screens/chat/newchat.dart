import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Constans/API.dart';
import 'package:graduationproject/screens/api_connection/api_connection.dart';
import 'package:graduationproject/screens/chat/chatdetail.dart';
import 'package:graduationproject/screens/chat/workermodel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'chatting.dart';

Future<List<Role>> fetchRoles() async {
  final response = await http.get(Uri.parse('http://$IP/palease_api/roles.php'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> rolesJson = json.decode(response.body);
    return rolesJson.entries.map((entry) => Role.fromJson(entry.key, entry.value)).toList();
  } else {

    throw Exception('Failed to load roles');
  }
}

class NewChatScreen extends StatefulWidget {

  NewChatScreen({super.key,  required this.firstname, required this.lastname, required this.userId});
  final String firstname,lastname,userId;
  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  late Future<List<Role>> futureRoles;

  @override
  void initState() {
    super.initState();
    futureRoles = fetchRoles();
  }
  Future<void> _startChatWithUser(String userId, String userFirstName, String lastname) async {
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
            workername: userFirstName+ lastname,
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
            workername: userFirstName+lastname,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Start New Chat', style: TextStyle(
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
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen(userId: widget.userId,firstname: widget.firstname,lastname: widget.lastname,)),
            );
          },

          icon:Icon(Icons.arrow_back_ios,color: Colors.white,),

        ),
      ),
      body: FutureBuilder<List<Role>>(
        future: futureRoles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final roles = snapshot.data!;
            return ListView.builder(
              itemCount: roles.length,
              itemBuilder: (context, index) {
                final role = roles[index];
                return ExpansionTile(
                  title: Text(role.name,style: TextStyle(color: Colors.purple),),
                  children: role.workers.map((worker) {
                    return ListTile(
                      title: Text(worker.name +' '+ worker.lastname),
                      onTap: () {
                        _startChatWithUser(worker.id, worker.name,worker.lastname);
                      },
                    );
                  }).toList(),
                );
              },
            );
          }
        },
      ),
    );
  }
}