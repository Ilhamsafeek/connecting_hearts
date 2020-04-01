import 'package:flutter/material.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/signin.dart';

import 'package:zamzam/ui/payment.dart';
import 'package:zamzam/ui/my_contribution.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: CircleAvatar(
                      minRadius: 55,
                      child: Icon(
                        Icons.person,
                        color: Colors.white54,
                        size: 60,
                      ),
                      backgroundColor: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      CURRENT_USER,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                // Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => LoginScreen()),
                // );
              },
            ),
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('My contribution'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyContribution()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text('My Appeals'),
              onTap: () {
               
              },
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Payment'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Payment()),
                );
              },
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Payment()),
                );
              },
            ),
            Expanded(
              child: new Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: FlatButton.icon(
                          icon: Icon(
                            FontAwesomeIcons.powerOff,
                            size: 18,
                          ),
                          onPressed: () async {
                            await FirebaseAuth.instance
                                .signOut()
                                .then((action) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Signin()));
                            });
                          },
                          label: Text('Sign out',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('v1.0'),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
