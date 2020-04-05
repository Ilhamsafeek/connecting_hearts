import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zamzam/ui/screens/screen1.dart';
import 'package:zamzam/ui/screens/screen2.dart';
import 'package:zamzam/ui/screens/screen3.dart';
import 'package:zamzam/ui/screens/screen4.dart';
import 'package:zamzam/ui/screens/screen5.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/signin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zamzam/services/services.dart';
import 'package:zamzam/ui/payment.dart';
import 'package:zamzam/ui/my_contribution.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:zamzam/ui/profile.dart';
import 'package:zamzam/ui/single_video.dart';
import 'package:zamzam/data_search.dart';
// Main code for all the tabs
class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => new MyTabsState();
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  static final homePageKey = GlobalKey<MyTabsState>();
  TabController tabcontroller;
  FirebaseMessaging messaging = FirebaseMessaging();
  ApiListener mApiListener;

  @override
  void initState() {
    super.initState();
    tabcontroller = new TabController(vsync: this, length: 5);

    messaging.configure(
      onLaunch: (Map<String, dynamic> event) async {
        dynamic video = json.decode(event['data']['args']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Play(video)),
        );
      },
      onMessage: (Map<String, dynamic> event) async {
        // foreground

        dynamic video = json.decode(event['data']['args']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Play(video)),
        );
      },
      onResume: (Map<String, dynamic> event) async {
        //background

        dynamic video = json.decode(event['data']['args']);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Play(video)),
        );
      },
    );
    // messaging.subscribeToTopic('all');
    messaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    messaging.getToken().then((token) {
      print("your token is : $token");
    });

    messaging.onTokenRefresh.listen((token) {
      WebServices(this.mApiListener).updateUserToken(token);

      print("your token is chnged to : $token");
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: homePageKey,
      appBar: new AppBar(
        actions: <Widget>[
      
          IconButton(
            onPressed: () {
            
              showSearch(context: context, delegate: DataSearch());

            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, anim1, anim2) => Profile(),
                  transitionsBuilder: (context, anim1, anim2, child) =>
                      FadeTransition(opacity: anim1, child: child),
                  transitionDuration: Duration(milliseconds: 100),
                ),
              );
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      bottomNavigationBar: new Material(
          child: new TabBar(
              controller: tabcontroller,
              indicatorColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelColor: Color.fromRGBO(104, 45, 127, 1),
              labelStyle: TextStyle(fontSize: 11.0),
              tabs: <Tab>[
            new Tab(
              icon: new Icon(Icons.home),
              text: "Home",
            ),
            new Tab(
              icon: new Icon(Icons.streetview),
              text: "Charity",
            ),
            new Tab(
              icon: new Icon(Icons.card_travel),
              text: "Jobs",
            ),
            new Tab(
              icon: new Icon(Icons.inbox),
              text: "Inbox",
            ),
            new Tab(
              icon: new Icon(Icons.more_horiz),
              text: "More",
            ),
          ])),
      body: new TabBarView(controller: tabcontroller, children: <Widget>[
        // All the Class goes here
        Home(),
        Charity(),
        Jobs(),
        Inbox(),
        Library()
      ]),
      // drawer: _drawer(),
    );
  }

  Widget _drawer() {
    return new Drawer(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text('Pilot Profile'),
          accountEmail: Text('$CURRENT_USER'),
          currentAccountPicture: CircleAvatar(
            child: Icon(
              Icons.person,
              size: 35.0,
              color: Colors.black45,
            ),
            backgroundColor: Colors.grey,
          ),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profile'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.verified_user),
          title: Text('My contribution'),
          onTap: () {
            Navigator.pop(context);
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
            Navigator.pop(context);
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
            Navigator.pop(context);
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
                    child: FlatButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut().then((action) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Signin()));
                        });
                      },
                      child: Text('Sign out',
                          style: TextStyle(
                              fontFamily: "Exo2",
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
    ));
  }

  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }
}
