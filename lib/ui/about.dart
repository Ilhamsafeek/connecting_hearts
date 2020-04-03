import 'package:flutter/material.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zamzam/ui/payment.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();

  // final dynamic projectData;
  // Payment(this.projectData, {Key key}) : super(key: key);
}

class _AboutState extends State<About> {
  ApiListener mApiListener;
  dynamic totalContribution = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = new IOSInitializationSettings();
    var initSetting = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: selectNotification);
    WebServices(mApiListener).getPaymentData().then((value) {
      print(value);
      setState(() {
        dynamic total = 0;
        for (var item in value) {
          total = total + double.parse(item['amount']);
        }
        totalContribution = total;
      });
    });
  }

  Future selectNotification(String payload) {
     Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Payment()),
        );
  }

  void showNotification() {
    var android = AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription",
        priority: Priority.High);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    flutterLocalNotificationsPlugin.show(0, 'title', 'body', platform,
        payload: "send message");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Center(child: Image.asset('assets/logo.png', height: 80)),
                    RaisedButton(
                      onPressed: () {
                        showNotification();
                      },
                      child: Text('Notify'),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
