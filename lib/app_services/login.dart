import 'package:message_board/app_services/signup.dart';
import 'package:message_board/cloud_services/firebase_services.dart';
import 'package:message_board/user_services/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        decoration: BoxDecoration(color: Colors.lightBlueAccent),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 75),
            //Page Title
            Text(
              'Welcome',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            //Subtitle
            Text(
              'Please login to continue',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 75),
            //Text field for email
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
            //Text field for password
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
            SizedBox(height: 10),
            //Forgot password button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                    onPressed: () {
                      print('Forgot button clicked');
                    },
                    child: Text('Forgot Password?')),
              ],
            ),
            SizedBox(height: 15),
            //Login button
            Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.white),
              child: MaterialButton(
                //When clicked, the app will contact firebase for authentication
                //using user's inputted login credential
                onPressed: () async {
                  //print('Login button clicked');
                  bool successful = await AuthServices().login(_email.text, _password.text);
                  if (successful) {
                    //when successful, navigate user to home page
                    String accountType = await AuthServices().checkUser(FirebaseAuth.instance.currentUser!.uid);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                  } else {
                    //when not successful, popup alert
                    //and prompt user to try again
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                                'Incorrect email/password. Please try again!'),
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
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.red),
              child: MaterialButton(
                //When clicked, the app will contact firebase for authentication
                //using user's inputted login credential
                onPressed: () async {
                  //print('Login button clicked');
                  await AuthServices().signInWithGoogle().then((UserCredential credential) {
                    MaterialPageRoute(builder: (context) => HomePage());
                  });
                },
                child: Text(
                  'Login with Google',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            //Create new account button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('First Time to Fan App?'),
                MaterialButton(
                    onPressed: () {
                      print('Signup button clicked');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                    },
                    child: Text('Create New Account')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
