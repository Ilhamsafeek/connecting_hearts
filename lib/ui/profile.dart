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

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
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
                Form(
                  key: _formKey,
                  child: FutureBuilder<dynamic>(
                      future: WebServices(this.mApiListener).getUserData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        List<Widget> children;

                        if (snapshot.hasData) {
                          final _usernameController = TextEditingController(
                              text: "${snapshot.data['username']}");
                          final _emailController = TextEditingController(
                              text: "${snapshot.data['email']}");
                          final _firstNameController = TextEditingController(
                              text: "${snapshot.data['firstname']}");
                          final _lastNameController = TextEditingController(
                              text: "${snapshot.data['lastname']}");
                          children = <Widget>[
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _firstNameController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'please enter first name.';
                                      }
                                      if (value.length < 5) {
                                        return 'choose a firast name with atleast 5 chars.';
                                      }
                                    },
                                    // controller: _usernameController,
                                    decoration: InputDecoration(
                                      // border: OutlineInputBorder(),
                                      labelText: 'First Name',
                                      hintText: '',
                                    ),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _lastNameController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'please enter last name.';
                                      }
                                      if (value.length < 5) {
                                        return 'choose a last name with atleast 5 chars.';
                                      }
                                    },
                                    // controller: _usernameController,
                                    decoration: InputDecoration(
                                      // border: OutlineInputBorder(),
                                      labelText: 'Last Name',
                                      hintText: '',
                                    ),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ]),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'please enter username.';
                                      }
                                      if (value.length < 5) {
                                        return 'choose a username with atleast 5 chars.';
                                      }
                                    },
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
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'please enter email address.';
                                      }
                                      if (value.length < 5) {
                                        return 'choose a username with atleast 5 chars.';
                                      }
                                      if (!RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)) {
                                        return 'email format is not valid';
                                      }
                                    },
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
                                        _formKey.currentState.validate()
                                            ? WebServices(this.mApiListener)
                                                .updateUser(
                                                    _usernameController.text,
                                                    _emailController.text,
                                                    _firstNameController.text,
                                                    _lastNameController.text)
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
                                              })
                                            : _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Please check the inputs"),
                                              ));
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
                ),
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
