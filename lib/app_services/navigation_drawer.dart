import 'package:flutter/material.dart';
import 'package:message_board/app_services//login.dart';
import 'package:message_board/cloud_services/firebase_services.dart';
import 'package:message_board/user_services/home.dart';
import 'package:message_board/user_services/user_profile.dart';

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({
    Key? key,
    required this.userObj,
  }) : super(key: key);

  //User Object - A map of DocumentSnapshot
  //Contain user information, name, uid, and email
  final userObj;

  @override
  Widget build(BuildContext context) {
    final firstName = userObj['first_name'];
    final lastName = userObj['last_name'];
    final name = '$firstName $lastName';
    final email = userObj['email'];
    final urlAvatar = userObj['urlAvatar'];

    return Drawer(
      child: Material(
        color: Colors.orangeAccent[100],
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlAvatar: urlAvatar,
              name: name,
              email: email,
              onClicked: () {},
            ),
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
    required String urlAvatar,
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
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlAvatar)),
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
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(userObj: userObj,),
            ));
        break;
      case 2:
        print('Account Settings');
        break;
      case 3:
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
