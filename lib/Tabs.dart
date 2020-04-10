import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zamzam/ui/payment.dart';
import 'package:zamzam/ui/screens/screen1.dart';
import 'package:zamzam/ui/screens/screen2.dart';
import 'package:zamzam/ui/screens/screen3.dart';
import 'package:zamzam/ui/screens/screen4.dart';
import 'package:zamzam/ui/screens/screen5.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zamzam/services/services.dart';
import 'package:zamzam/ui/profile.dart';
import 'package:zamzam/ui/single_video.dart';
import 'package:zamzam/data_search.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'badge_icon.dart';

// Main code for all the tabs
class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => new MyTabsState();
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  static final homePageKey = GlobalKey<MyTabsState>();
  TabController tabcontroller;
  FirebaseMessaging messaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ApiListener mApiListener;

  int _currentIndex = 0;
  PageController _pageController;
  int _tabBarNotificationCount = 0;

  StreamController<int> _countController = StreamController<int>();

  Future<void> updateNotificationCount(int nofificationcount) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt("notificationCount", nofificationcount);
  }

  Future<int> getNotificationCount() async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getInt("notificationCount");
    return allSearches;
  }

  @override
  void initState() {
    super.initState();
    getNotificationCount().then((value) {
      if (value == null) {
        setState(() {
          _tabBarNotificationCount = 0;
          _countController.sink.add(_tabBarNotificationCount);
        });
      } else {
        setState(() {          
          _tabBarNotificationCount = value;
          _countController.sink.add(_tabBarNotificationCount);
        });
      }
    });
    _pageController = PageController();

    messaging.configure(
      onLaunch: (Map<String, dynamic> event) async {
        dynamic video = json.decode(event['data']['args']);

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Play(video)),
        // );
        showNotification();
      },
      onMessage: (Map<String, dynamic> event) async {
        // foreground

        dynamic video = json.decode(event['data']['args']);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Play(video)),
        // );
        showNotification();
        _tabBarNotificationCount = _tabBarNotificationCount + 1;
        _countController.sink.add(_tabBarNotificationCount);
        updateNotificationCount(_tabBarNotificationCount);
      },
      onResume: (Map<String, dynamic> event) async {
        //background
        _tabBarNotificationCount = _tabBarNotificationCount + 1;
        _countController.sink.add(_tabBarNotificationCount);
        updateNotificationCount(_tabBarNotificationCount);
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

    // Local notification
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = new IOSInitializationSettings();
    var initSetting = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: _selectNotification);
  }

  Future _selectNotification(String payload) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Payment()),
    );
  }

  void showNotification() {
    var android = AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription",
        priority: Priority.High, importance: Importance.Max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    flutterLocalNotificationsPlugin.show(0, 'title', 'body', platform,
        payload: "send message");
  }

  @override
  void dispose() {
    _pageController.dispose();
    _countController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                _tabBarNotificationCount = _tabBarNotificationCount + 1;
                _countController.sink.add(_tabBarNotificationCount);
              }),
          IconButton(
              icon: Icon(Icons.announcement),
              onPressed: () {
                _tabBarNotificationCount = _tabBarNotificationCount - 1;
                _countController.sink.add(_tabBarNotificationCount);
              }),
          IconButton(
            onPressed: () async {
              await showSearch<String>(
                context: context,
                delegate: DataSearch(
                  onSearchChanged: DataSearch().getRecentSearchesLike,
                ),
              );
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
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Home(),
            Charity(),
            Jobs(),
            Inbox(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text('Home'),
            icon: Icon(Icons.apps),
            activeColor: Theme.of(context).primaryColor,
          ),
          BottomNavyBarItem(
            title: Text('Charity'),
            icon: Icon(Icons.people),
            activeColor: Theme.of(context).primaryColor,
          ),
          BottomNavyBarItem(
            title: Text('Jobs'),
            icon: Icon(Icons.card_travel),
            activeColor: Theme.of(context).primaryColor,
          ),
          BottomNavyBarItem(
            title: Text('Notifications'),
            //Actually icon was in Icon type. we have changed in the cache of bottomnavybaritem. (Ctrl + click on BottomNavyBarItem to edit)
            icon: StreamBuilder(
              initialData: _tabBarNotificationCount,
              stream: _countController.stream,
              builder: (_, snapshot) => BadgeIcon(
                icon: Icon(
                  Icons.notifications,
                  size: 27.0,
                ),
                badgeCount: snapshot.data,
              ),
            ),
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
