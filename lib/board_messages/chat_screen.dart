import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:message_board/app_services/navigation_drawer.dart';
import 'package:message_board/board_messages//chat_message.dart';
import 'package:message_board/cloud_services/firebase_services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    required this.userObj,
    required this.topic,
  });

  //User Object - A map of DocumentSnapshot
  //Contain user information, name, uid, and email
  final userObj;

  final String topic;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.brown),
        backgroundColor: Colors.orangeAccent[100],
        title: Text(
          widget.topic.toUpperCase(),
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
      ),
      drawer: NavigationDrawer(userObj: widget.userObj,),
      body: Container(
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: Column(
            children: <Widget>[
              Flexible(
                //padding: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _messageStreamWidget(),
                ),
              ),
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
            ],
          )
      ),
    );
  }

  Widget _messageStreamWidget() {
    return StreamBuilder<QuerySnapshot>(
        stream: AuthServices().messageStream(widget.topic),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }

          return ListView(
              reverse: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return Row(
                  children: <Widget>[
                    ChatMessage(
                      text: data['message'],
                      name: data['fromName'],
                      date: data['timestamp'],
                    )
                  ],
                );
              }).toList(),
            );
        }
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 18.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message',
                  fillColor: Colors.blueGrey,
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    String message = _textController.text.trim();
                    if (message.isEmpty) {
                      print("Empty message");
                      return null;
                    } else {
                      _handleSubmitted(_textController.text);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) async {
    _textController.clear();

    //Send message to database
    await _sendMessageToDb(text);
  }

  Future<void> _sendMessageToDb(String message) async {
    String userID = widget.userObj['user_id'];

    final database = FirebaseFirestore.instance.collection('board_message');

    await database.doc(widget.topic).collection(widget.topic).add({
      'fromUserID': userID,
      'fromName': widget.userObj['first_name'],
      'message': message,
      'timestamp': _dateHandler(),
      'sendAt' : DateTime.now(),
    });
  }

  String _dateHandler() {
    DateTime dateTime = new DateTime.now();
    return "${dateTime.month}-${dateTime.day}-${dateTime.year}  ${dateTime.hour}:${dateTime.minute}";
  }
}