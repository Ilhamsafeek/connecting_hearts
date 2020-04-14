import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zamzam/ui/project_detail.dart';
import 'package:zamzam/ui/single_video.dart';
import 'package:zamzam/ui/success_page.dart';

class Inbox extends StatefulWidget {
  Inbox({Key key}) : super(key: key);

  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: SingleChildScrollView(
        child: Notifications(),
      ),
    );
  }
}

class Notifications extends StatefulWidget {
  Notifications({Key key}) : super(key: key);

  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  ApiListener mApiListener;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        RefreshIndicator(
          child: SingleChildScrollView(
              child: Container(
            child: FutureBuilder<dynamic>(
              future: WebServices(this.mApiListener)
                  .getNotificationData(), // a previously-obtained Future<String> or null
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                List<Widget> children;

                if (snapshot.hasData) {
                  children = <Widget>[
                    for (var item in snapshot.data)
                      Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              child: item['type'] == 'approval'
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.orange,
                                    )
                                  : item['type'] == 'project'
                                      ? Icon(Icons.short_text)
                                      : Icon(Icons.videocam),
                            ),
                            title: Text(item['message']),
                            subtitle: Text(
                              item['time'],
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: Text(
                              item['type'],
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                            onTap: () {
                              dynamic type = item['type'];
                              switch (type) {
                                case 'sermon':
                               
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Play(json.decode(item['data']))));
                                  break;
                                case 'project':
                                  print(json.decode(item['data']));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProjectDetail(
                                              json.decode(item['data']))));
                                  break;
                                case 'approval':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SuccessPage(
                                              json.decode(item['data']))));
                                  break;
                                default:
                                 print(json.decode(item['data']));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Play(json.decode(item['data']))));
                              }
                             

                            },
                          ),
                          Divider(
                            height: 0,
                          ),
                        ],
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                );
              },
            ),
          )),
          onRefresh: _handleRefresh,
        )
      ],
    ));
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));

    setState(() {});

    return null;
  }
}

class Messages extends StatefulWidget {
  Messages({Key key}) : super(key: key);

  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  ApiListener mApiListener;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
