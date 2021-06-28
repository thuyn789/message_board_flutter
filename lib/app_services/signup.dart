import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:message_board/app_services/login.dart';
import 'package:message_board/cloud_services/firebase_services.dart';
import 'package:message_board/user_services/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:message_board/user.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        decoration: BoxDecoration(color: Colors.lightBlueAccent),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 50),
            Text(
              'Create New Account',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Please fill out the form',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 75),
            TextFormField(
              controller: _firstName,
              decoration: InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 5),
            TextFormField(
              controller: _lastName,
              decoration: InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 5),
            TextFormField(
              controller: _email,
              decoration: InputDecoration(
                hintText: 'name@email.com',
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                labelText: 'Email Address',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 5),
            TextFormField(
              obscureText: true,
              controller: _password,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.white),
              child: MaterialButton(
                onPressed: () async {
                  //print('Signup button clicked');
                  bool successful = await AuthServices().signUp(
                      _email.text.trim(),
                      _password.text.trim()
                  ).then((value) async {
                    User? user = FirebaseAuth.instance.currentUser;
                    await FirebaseFirestore.instance.collection("users").doc(user!.uid).set(
                        {
                          'user_id': user.uid.trim(),
                          'first_name': _firstName.text.trim(),
                          'last_name':  _lastName.text.trim(),
                          'email': _email.text.trim(),
                          'user_role': 'customer'.trim(),
                          'reg_date_time': user.metadata.creationTime
                        });
                    return true;
                  });
                  if (successful) {
                    //when successful, navigate user to home page
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                  } else {
                    //when not successful, popup alert
                    //and prompt user to try again
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                                'Error Occurred. Please try again!'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('OK'),
                              ),
                            ],
                          );
                        });
                  }
                },
                child: Text(
                  'Signup',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
