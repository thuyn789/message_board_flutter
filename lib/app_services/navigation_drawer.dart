import 'package:flutter/material.dart';
import 'package:message_board/app_services//login.dart';
import 'package:message_board/cloud_services/firebase_services.dart';
import 'package:message_board/user_services/home.dart';
import 'package:message_board/user_services/user_profile.dart';

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({
    required this.userObj,
  });

  //User Object - A map of DocumentSnapshot
  //Contain user information, name, uid, and email
  final userObj;

  @override
  Widget build(BuildContext context) {
    //final name = 'Sarah Abs';
    //final email = 'sarah@abs.com';
    //final urlImage =
    //'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80';

    return Drawer(
      child: Material(
        color: Colors.orangeAccent[100],
        child: ListView(
          children: <Widget>[
            /*buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserPage(
                  name: 'Sarah Abs',
                  urlImage: urlImage,
                ),
              )),
            ),*/
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Message Boards',
                    icon: Icons.message,
                    onClicked: () => menuAction(context, 0),
                  ),
                  SizedBox(height: 16),
                  buildMenuItem(
                    text: 'User Profile',
                    icon: Icons.person_pin_rounded,
                    onClicked: () => menuAction(context, 1),
                  ),
                  SizedBox(height: 24),
                  Divider(color: Colors.brown),
                  SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Account Settings',
                    icon: Icons.account_box,
                    onClicked: () => menuAction(context, 2),
                  ),
                  SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Sign Out?',
                    icon: Icons.person,
                    onClicked: () => menuAction(context, 3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.brown),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.brown),
                  ),
                ],
              ),
              Spacer(),
              CircleAvatar(
                radius: 24,
                backgroundColor: Color.fromRGBO(30, 60, 168, 1),
                child: Icon(Icons.add_comment_outlined, color: Colors.white),
              )
            ],
          ),
        ),
      );

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.brown;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void menuAction(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                userObj: userObj,
              ),
            ));
        break;
      case 1:
        print('User Profile');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(
                userObj: userObj,
              ),
            ));
        break;
      case 2:
        print('Account Settings');
        break;
      case 3:
        print('Sign Out');
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
                      Navigator.pop(context, true);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                      AuthServices().signOut();
                    },
                    child: Text('Yes'),
                  ),
                ],
              );
            });
        break;
    }
  }
}
