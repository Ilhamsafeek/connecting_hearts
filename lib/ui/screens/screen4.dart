
import 'package:flutter/material.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zamzam/ui/project_detail.dart';
import 'package:zamzam/ui/single_video.dart';

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
  dynamic notificationData;
  @override
  void initState() {
    super.initState();
   notificationData = WebServices(this.mApiListener)
                  .getNotificationData();
  }
  


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        RefreshIndicator(
          child: SingleChildScrollView(
              child: Container(
            child: FutureBuilder<dynamic>(
              future: notificationData, 
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                List<Widget> children;

                if (snapshot.hasData) {
                   if (snapshot.data.length != 0) {
                  dynamic data = snapshot.data.where((el) {
                    if (el['target'].contains(CURRENT_USER)) {
                      return true;
                    } else {
                      return false;
                    }
                  }).toList();

                  children = <Widget>[
                    for (var item in data)
                      Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[400],
                              child: item['type'] == 'approval'
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
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
                            onTap: () async {
                              dynamic type = item['type'];
                              switch (type) {
                                case 'sermon':
                                  await WebServices(this.mApiListener)
                                      .getSermonData()
                                      .then((value) {
                                    dynamic sermonData;
                                    sermonData = value
                                        .where((el) =>
                                            el['sermon_id'] ==
                                            '${item['data']}')
                                        .toList()[0];

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Play(sermonData)));
                                  });

                                  break;
                                case 'project':
                                  CircularProgressIndicator();
                                  await WebServices(this.mApiListener)
                                      .getProjectData()
                                      .then((value) {
                                    dynamic projectData;
                                    projectData = value
                                        .where((el) =>
                                            el['appeal_id'] ==
                                            '${item['data']}')
                                        .toList()[0];

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProjectDetail(projectData)));
                                  });

                                  break;
                                case 'approval':
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => SuccessPage(
                                  //             json.decode(item['data']))));
                                  break;
                                default:
                                  await WebServices(this.mApiListener)
                                      .getSermonData()
                                      .then((value) {
                                    dynamic sermonData;
                                    sermonData = value
                                        .where((el) =>
                                            el['sermon_id'] ==
                                            '${item['data']}')
                                        .toList()[0];

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Play(sermonData)));
                                  });
                              }
                            },
                          ),
                          Divider(
                            height: 0,
                          ),
                        ],
                      ),
                  ];
                   }else{
                      children = <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: ListTile(
                                      title: Image.asset(
                                        "assets/my_contribution.png",
                                        width: 120,
                                        height: 120,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                      title: Text(
                                    'you have not received notification yet. You will be notified once you get notifications.',
                                    style: TextStyle(
                                        color: Colors.black45, fontSize: 14),
                                    textAlign: TextAlign.center,
                                  )),
                                ];
                              
                   }
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
