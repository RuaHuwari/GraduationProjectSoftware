import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatting.dart';

class ChatDetailScreen extends StatelessWidget {
  final String firstname;
  final String lastname;
  final String userid;
  final String chatId;
  final String workername;

  ChatDetailScreen({
    required this.chatId,
    required this.firstname,
    required this.lastname,
    required this.userid, required this.workername,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    FocusNode focusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
          title: Text(this.workername,style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.purple,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen(userId: this.userid,firstname: this.firstname,lastname: this.lastname,)),
            );
          },

          icon:Icon(Icons.arrow_back_ios,color: Colors.white,),

        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
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

                    bool isCurrentUser = senderId == this.userid;

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
                          .doc(chatId)
                          .collection('messages')
                          .add({
                        'senderId': this.userid,
                        'text': messageController.text,
                        'timestamp': Timestamp.now(),
                      });
                      FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatId)
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
    );
  }
}
