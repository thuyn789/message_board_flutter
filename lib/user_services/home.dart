import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:message_board/app_services/login.dart';
import 'package:message_board/cloud_services/firebase_services.dart';
import 'package:message_board/user_services/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController yourMessage = TextEditingController();
  //This variable is to control the appearance of the "Add Message" button
  bool isAdmin = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Column(
          children: [
            Text(
              'Home',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Let the epic begin',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Signing Out?'),
                      content: Text('Do you want to sign out?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                            AuthServices().signOut();
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    );
                  });
            },
            icon: Icon(Icons.person),
            label: Text('Sign Out?'),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        decoration: BoxDecoration(color: Colors.lightBlueAccent),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('messages').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return new ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return new ListTile(
                  title: new Text(data['message']),
                  //subtitle: new Text(data['date_created']),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0, color: Colors.white),
          backgroundColor: Colors.brown,

          /// If true user is forced to close dial manually
          /// by tapping main button and overlay is not rendered.
          closeManually: false,
          children: [
            //check if admin is log in
            //this function is only available to admin
            if (isAdmin)
              SpeedDialChild(
                child: Icon(Icons.add),
                backgroundColor: Colors.white,
                label: 'Add Messages',
                labelStyle: TextStyle(fontSize: 18.0, color: Colors.red),
                onTap: () {
                  print('Add Message button clicked');
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Your Message'),
                          content: TextField(
                            controller: yourMessage,
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                yourMessage.clear();
                                Navigator.pop(context, true);
                              },
                              child: Text('CLOSE'),
                            ),
                            TextButton(
                              onPressed: () async {
                                CollectionReference messages = FirebaseFirestore
                                    .instance
                                    .collection('messages');
                                await messages.add({
                                  'message': yourMessage.text,
                                  'date_created': DateTime.now(),
                                }).then((value) {
                                  print("Message Added");
                                  yourMessage.clear();
                                  Navigator.pop(context, true);
                                }).catchError((error) =>
                                    print("Failed to add message: $error"));
                              },
                              child: Text('POST MESSAGE'),
                            ),
                          ],
                        );
                      });
                },
              ),
            SpeedDialChild(
              child: Icon(Icons.person_pin_rounded),
              backgroundColor: Colors.white,
              label: 'User Profile',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.red),
              onTap: () {},
            ),
          ]),
    );
  }
}
