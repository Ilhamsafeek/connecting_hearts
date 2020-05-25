import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/signin.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zamzam/ui/onboarding_page.dart';

import 'package:zamzam/ui/payment.dart';
import 'package:zamzam/ui/my_contribution.dart';
import 'package:zamzam/ui/about.dart';
import 'package:zamzam/utils/dialogs.dart';



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
  Widget _signoutProgress;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.asset('assets/profile-background.png',
                          color: Colors.grey[100]),
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
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            CURRENT_USER,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    ],
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
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'please enter first name.';
                                      }
                                      if (value.length < 5) {
                                        return 'choose a firast name with atleast 5 chars.';
                                      }
                                    },
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
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'please enter last name.';
                                      }
                                      if (value.length < 5) {
                                        return 'choose a last name with atleast 5 chars.';
                                      }
                                    },
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
                                    keyboardType: TextInputType.text,
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
                                    keyboardType: TextInputType.emailAddress,
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
                            ListTile(
                                title: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              showWaitingProgress(context);
                                              await WebServices(
                                                      this.mApiListener)
                                                  .updateUser(
                                                      _usernameController.text,
                                                      _emailController.text,
                                                      _firstNameController.text,
                                                      _lastNameController.text)
                                                  .then((value) {
                                                Navigator.pop(context);
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
                                            }
                                          },
                                          child: Text(
                                            'Save Profile',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () => {}),
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
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new MyContribution();
                }));
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.bookmark),
            //   title: Text('My Appeals'),
            //   onTap: () async {
            //     // try {
            //     //   final result = await InternetAddress.lookup('google.com');
            //     //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            //     //     print('connected');
            //     //   }
            //     // } on SocketException catch (_) {
            //     //   print('not connected');
            //     // }

            //     Navigator.of(context).push(
            //         CupertinoPageRoute<Null>(builder: (BuildContext context) {
            //       return new OnBoardingPage();
            //     }));
            //   },
            // ),

            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Payment'),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new Payment();
                }));
              },
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new About();
                }));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.power_settings_new,
              ),
              title: Text('Sign out'),
              subtitle: SizedBox(height: 2.0, child: _signoutProgress),
              onTap: () async {
                setState(() {
                  _signoutProgress = LinearProgressIndicator(
                    backgroundColor: Colors.grey[200],
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                  );
                });
                await FirebaseAuth.instance.signOut().then((action) {
                  // Navigator.pop(context);
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
