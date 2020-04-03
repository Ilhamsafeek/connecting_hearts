import 'package:flutter/material.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/signin.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:zamzam/ui/payment.dart';
import 'package:zamzam/ui/my_contribution.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zamzam/ui/about.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  ApiListener mApiListener;
  TextEditingController username;
  TextEditingController email;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: CircleAvatar(
                      minRadius: 45,
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
            ExpansionTile(
              title: Text("Profile"),
              subtitle: Text(
                'Username, Email',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              leading: Icon(Icons.person),
              children: <Widget>[
                FutureBuilder<dynamic>(
                    future: WebServices(this.mApiListener).getUserData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      List<Widget> children;

                      if (snapshot.hasData) {
                        final _usernameController = TextEditingController(
                            text: "${snapshot.data['username']}");
                        final _emailController = TextEditingController(
                            text: "${snapshot.data['email']}");
                        children = <Widget>[
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: TextFormField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Username',
                                    hintText: '',
                                  ),
                                  textInputAction: TextInputAction.next,
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Email',
                                    hintText: '',
                                  ),
                                  textInputAction: TextInputAction.next,
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Center(
                                child: RaisedButton(
                                    color: Colors.blue[900],
                                    child: Text(
                                      'Save',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      WebServices(this.mApiListener)
                                          .updateUser(_usernameController.text,
                                              _emailController.text)
                                          .then((value) {
                                        if (value == 200) {
                                          _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Profile Updated Successfully"),
                                          ));
                                        } else {
                                          _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Something went wrong. Please try again."),
                                          ));
                                        }
                                      });
                                    })),
                          ),
                        ];
                      } else if (snapshot.hasError) {
                        children = <Widget>[
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                                'something Went Wrong !'), //Error: ${snapshot.error}
                          )
                        ];
                      } else {
                        children = <Widget>[
                          SizedBox(
                            child: SpinKitPulse(
                              color: Colors.grey,
                              size: 120.0,
                            ),
                            width: 50,
                            height: 50,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(''),
                          )
                        ];
                      }
                      return Center(
                        child: Column(
                          children: children,
                        ),
                      );
                    }),
              ],
              initiallyExpanded: false,
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
              onTap: () {},
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
                  MaterialPageRoute(builder: (context) => About()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.powerOff,
                size: 18,
              ),
              title: Text('Sign out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut().then((action) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Signin()));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
