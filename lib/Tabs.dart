import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:zamzam/ui/payment.dart';
import 'package:zamzam/ui/screens/new_chat.dart';
import 'package:zamzam/ui/screens/offline.dart';
import 'package:zamzam/ui/screens/home.dart';
import 'package:zamzam/ui/screens/charity.dart';
import 'package:zamzam/ui/screens/notifications.dart';
import 'package:zamzam/ui/screens/chat.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zamzam/services/services.dart';
import 'package:zamzam/ui/profile.dart';
import 'package:zamzam/ui/single_video.dart';
import 'package:zamzam/data_search.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zamzam/webview.dart';

import 'badge_icon.dart';
import 'constant/Constant.dart';

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
  // final ScrollController controller = ScrollController();

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
  void didChangeDependencies() {
   
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
    
  
    super.didChangeDependencies();
  }

  Future _selectNotification(String payload) {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
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
    flutterLocalNotificationsPlugin.show(0, 'Connecting hearts',
        'Watch or Listen to new sermon update', platform,
        payload: "send message");
  }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   _countController.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: new Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: new AppBar(
              title: Image.asset(
                'assets/ch_logo.png',
                height: 35,
                color: Colors.white60,
              ),
              actions: <Widget>[
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
                  icon: StreamBuilder(
                    initialData: _tabBarNotificationCount,
                    stream: _countController.stream,
                    builder: (_, snapshot) => BadgeIcon(
                      icon: Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                      badgeCount: snapshot.data,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Notifications()),
                    );
                    _tabBarNotificationCount = 0;
                    _countController.sink.add(_tabBarNotificationCount);
                    updateNotificationCount(_tabBarNotificationCount);
                  },
                ),
              ],
            ),
          ),
          body: OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              final bool connected = connectivity != ConnectivityResult.none;
              return new Stack(
                fit: StackFit.expand,
                children: [
                  connected
                      ? SizedBox.expand(
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() => _currentIndex = index);
                            },
                            children: <Widget>[
                              Home(),
                              Charity(),
                              USER_ROLE == 'Management'
                                  ? Webview()
                                  : Chat(),
                              Profile(),
                            ],
                          ),
                        )
                      : Offline()
                ],
              );
            },
            child: Column(
              children: <Widget>[
                new Text(
                  'There are no bottons to push :)',
                ),
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
                title: Text(
                  'Home',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                icon: Icon(Icons.apps, color: Theme.of(context).primaryColor),
                activeColor: Theme.of(context)
                    .primaryColor, //Theme.of(context).primaryColor,
              ),
              BottomNavyBarItem(
                title: Text(
                  'Charity',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                icon: Icon(Icons.people, color: Theme.of(context).primaryColor),
                activeColor: Theme.of(context).primaryColor,
              ),
              BottomNavyBarItem(
                title: Text(
                  USER_ROLE == 'Management' ? 'Report' : 'Messages',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                icon: Icon(
                  USER_ROLE == 'Management'
                                  ? Icons.insert_chart
                                  : Icons.chat,
                   
                  color: Theme.of(context).primaryColor),
                activeColor: Theme.of(context).primaryColor,
              ),
              BottomNavyBarItem(
                title: Text(
                  'Account',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                //Actually icon was in Icon type. we have changed in the cache of bottomnavybaritem. (Ctrl + click on BottomNavyBarItem to edit)
                icon: Icon(Icons.person, color: Theme.of(context).primaryColor),
                activeColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
        onWillPop: () {
          print('Back button pressed');
          if (_currentIndex != 0) {
            setState(() => _currentIndex = 0);
            _pageController.jumpToPage(0);
            return new Future(() => false);
          }
          return new Future(() => true);
        });
  }
}
