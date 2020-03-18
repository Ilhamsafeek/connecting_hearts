import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zamzam/ui/screens/screen1.dart';
import 'package:zamzam/ui/screens/screen2.dart';
import 'package:zamzam/ui/screens/screen3.dart';
import 'package:zamzam/ui/screens/screen4.dart';
import 'package:zamzam/ui/screens/screen5.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/signin.dart';


// Main code for all the tabs
class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => new MyTabsState();
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  static final homePageKey = GlobalKey<MyTabsState>();
  TabController tabcontroller;
  String userId;

  @override
  void initState() {
    currentUser().then((value) {
      if (value != null) {
        setState(() {
          this.userId = value.phoneNumber;
        });
      }
    });
    super.initState();
    tabcontroller = new TabController(vsync: this, length: 5);
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
        title: Image(
          image: AssetImage("images/appbarlogo.png"),
        ),
        actions: <Widget>[
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.videocam),
          // ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person),
          ),
        ],
      ),
      bottomNavigationBar: new Material(
          child: new TabBar(
              controller: tabcontroller,
              indicatorColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.redAccent[700],
              labelStyle: TextStyle(fontSize: 11.0),
              tabs: <Tab>[
            new Tab(
              icon: new Icon(Icons.home),
              text: "Home",
            ),
            new Tab(
              icon: new Icon(Icons.whatshot),
              text: "Trending",
            ),
            new Tab(
              icon: new Icon(Icons.subscriptions),
              text: "Subscriptions",
            ),
            new Tab(
              icon: new Icon(Icons.inbox),
              text: "Inbox",
            ),
            new Tab(
              icon: new Icon(Icons.folder),
              text: "Library",
            ),
          ])),
      body: new TabBarView(controller: tabcontroller, children: <Widget>[
        // All the Class goes here
        Home(),
        Trending(),
        Subscriptioins(),
        Inbox(),
        Library()
      ]),
      drawer: _drawer(),
    );
  }

  
  Widget _drawer() {
    return new Drawer(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text('Pilot Profile'),
          accountEmail: Text('${this.userId}'),
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
            // Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => Beneficiaries()),
            // );
          },
        ),
        ListTile(
          leading: Icon(Icons.verified_user),
          title: Text('Transaction History'),
          onTap: () {
            // Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => History()),
            // );
          },
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text('My Appeals'),
          onTap: null,
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: null,
        ),
        Container(),
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
