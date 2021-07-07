import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:message_board/app_services/navigation_drawer.dart';
import 'package:message_board/cloud_services/firebase_services.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({
    required this.text,
    required this.animationController,
    required this.name,
    required this.date,
  });

  final String text;
  final AnimationController animationController;
  final String name;
  final String date;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(name[0])),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 14.0, fontStyle: FontStyle.italic),
                    ),
                    SizedBox(width: 40),
                    Text(
                      date,
                      style: TextStyle(
                          fontSize: 14.0, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
  final List<ChatMessage> _messages = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
        .collection('board_message')
        .doc(widget.topic)
        .collection(widget.topic)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.brown),
        backgroundColor: Colors.orangeAccent[100],
        title: Text(
          widget.topic,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
      ),
      drawer: NavigationDrawer(userObj: widget.userObj,),
      body: StreamBuilder<QuerySnapshot>(
        stream: _messageStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Container(
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) => _messages[index],
                      itemCount: _messages.length,
                    ),
                  ),
                  Divider(height: 1.0),
                  Container(
                    decoration: BoxDecoration(color: Theme.of(context).cardColor),
                    child: _buildTextComposer(),
                  ),
                ],
              ));
        }
      ),
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
                //onSubmitted: _handleSubmitted,
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

  //Retrieve all chat message
  Future<void> _loadMessages() async {

    await FirebaseFirestore.instance
        .collection('board_message')
        .doc(widget.topic)
        .collection(widget.topic)
        .orderBy(
          'timestamp',
        )
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final messageObj = doc.data() as Map<String, dynamic>;

        var message = ChatMessage(
          text: messageObj['message'],
          animationController: AnimationController(
            // NEW
            duration: const Duration(milliseconds: 0), // NEW
            vsync: this,
          ),
          name: messageObj['fromName'],
          date: messageObj['timestamp'],
        );

        setState(() {
          _messages.insert(0, message);
        });

        _focusNode.requestFocus();
        message.animationController.forward();
      });
    });
  }

  void _handleSubmitted(String text) async {
    _textController.clear();

    var message = ChatMessage(
      text: text,
      animationController: AnimationController(
        // NEW
        duration: const Duration(milliseconds: 300), // NEW
        vsync: this,
      ),
      name: widget.userObj['first_name'],
      date: _dateHandler(""),
    );

    setState(() {
      _messages.insert(0, message);
    });

    _focusNode.requestFocus();
    message.animationController.forward();

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
      'timestamp': _dateHandler(""),
    });
  }

  String _dateHandler(String info) {
    DateTime date = new DateTime.now();
    if (info == "date") {
      return "${date.month}-${date.day}-${date.year}";
    } else if (info == "time") {
      return "${date.hour}:${date.minute}";
    }
    return "${date.month}-${date.day}-${date.year}  ${date.hour}:${date.minute}";
  }

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}