import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:message_board/app_services/login.dart';
import 'package:message_board/app_services/navigation_drawer.dart';
import 'package:message_board/cloud_services/firebase_services.dart';
import 'package:message_board/user_services/user_profile.dart';

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
        backgroundColor: Colors.orangeAccent[100],
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Home',
              style: TextStyle(
                fontSize: 30,
                color: Colors.brown,
                fontWeight: FontWeight.bold,
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
              primary: Colors.blue,
            ),
          )
        ],
      ),
      drawer: NavigationDrawer(),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 75),
            //Page Title
            Text(
              'Home',
              style: TextStyle(
                fontSize: 40,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            //Subtitle
            Text(
              'Please choose a topic',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 75),
            //Text field for email
          ],
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
