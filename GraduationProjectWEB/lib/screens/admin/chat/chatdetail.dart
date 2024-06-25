import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/screens/admin/Notify.dart';
import 'package:graduationprojectweb/screens/admin/applications.dart';
import 'package:graduationprojectweb/screens/admin/chat/chatting.dart';
import 'package:graduationprojectweb/screens/admin/dashboardscreen.dart';
import 'package:graduationprojectweb/screens/home.dart';

class ChatDetailScreen extends StatefulWidget {
  final String firstname;
  final String lastname;
  final String userid;
  final String chatId;
  final String username;
  final bool showNotify;
  final bool showapplications;
  ChatDetailScreen({
    required this.chatId,
    required this.firstname,
    required this.lastname,
    required this.userid, required this.username, required this.showNotify, required this.showapplications,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
int _selectedIndex=0;

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    FocusNode focusNode = FocusNode();
    if(widget.showNotify && widget.showapplications){
      setState(() {
        _selectedIndex=3;
      });
    }else if(widget.showapplications){
      setState(() {
        _selectedIndex=2;
      });
    }else{
      setState(() {
        _selectedIndex=1;
      });
    }
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              userId: widget.userid,
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
                                userId: widget.userid,
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
                                userId: widget.userid,
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
                                userId: widget.userid,
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
                                userId: widget.userid,
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
                                userId: widget.userid,
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
                                userId: widget.userid,
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
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .doc(widget.chatId)
                        .collection('messages')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
            
                      var messages = snapshot.data!.docs;
            
                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          var message = messages[index];
                          var messageData = message.data() as Map<String, dynamic>;
                          var messageText = messageData['text'] ?? 'No message content';
                          var senderId = messageData['senderId'] ?? 'Unknown sender';
            
                          bool isCurrentUser = senderId == this.widget.userid;
            
                          return Align(
                            alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isCurrentUser ? Colors.purple[200] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    messageText,
                                    style: TextStyle(
                                        color: isCurrentUser ? Colors.white : Colors.black,
                                        fontSize: 25
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          focusNode: focusNode,
                          decoration: InputDecoration(hintText: 'Enter message'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (messageController.text.isNotEmpty) {
                            FirebaseFirestore.instance
                                .collection('chats')
                                .doc(widget.chatId)
                                .collection('messages')
                                .add({
                              'senderId': this.widget.userid,
                              'text': messageController.text,
                              'timestamp': Timestamp.now(),
                            });
                            FirebaseFirestore.instance
                                .collection('chats')
                                .doc(widget.chatId)
                                .update({
                              'lastMessage': messageController.text,
                              'timestamp': Timestamp.now(),
                            });
                            messageController.clear();
                            focusNode.requestFocus();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
