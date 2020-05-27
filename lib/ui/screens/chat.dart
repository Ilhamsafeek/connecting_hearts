import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zamzam/services/services.dart';
import 'package:zamzam/ui/screens/chat_detail.dart';


class Chat extends StatefulWidget {
  Chat({Key key}) : super(key: key);

  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List myList;
  static ApiListener mApiListener;
  StreamController _messageController;
  Timer timer;

  @override
  void initState() {
    super.initState();
    _messageController = new StreamController();
    timer = Timer.periodic(Duration(seconds: 1), (_) => loadMessages());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  loadMessages() async {
    WebServices(mApiListener).getChatTopics().then((res) async {
      _messageController.add(res);
      return res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Image.asset(
            //   'assets/chat.png',
            //   height: 250,
            //   color: Colors.grey[200],
            // ),

            StreamBuilder(
              stream: _messageController.stream,
              builder: (context, snapshot) {
                List<Widget> children;
                if (snapshot.hasError) {
                  children = <Widget>[
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    )
                  ];
                } else {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      children = <Widget>[
                        Icon(
                          Icons.info,
                          color: Colors.blue,
                          size: 60,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Select a lot'),
                        )
                      ];
                      break;
                    case ConnectionState.waiting:
                      children = <Widget>[
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                child: SpinKitPulse(
                                  color: Colors.grey,
                                  size: 120.0,
                                ),
                                width: 50,
                                height: 50,
                              ),
                            ],
                          ),
                        )
                      ];
                      break;
                    case ConnectionState.active:
                      children = <Widget>[
                        for (var item in snapshot.data)
                          ListTile(
                            leading: CircleAvatar(
                              // backgroundImage:
                              //     NetworkImage(item['photo']),
                              radius: 30,
                            ),
                            title: Text(item['topic']),
                            subtitle: Text("Have you completed the Project?"),
                            onTap: () {
                              Navigator.of(context).push(
                                  CupertinoPageRoute<Null>(
                                      builder: (BuildContext context) {
                                return new ChatDetail(
                                    item['topic'], item['chat_id'],0);
                              }));
                            },
                          ),

                        // Divider(),
                      ];
                      break;
                    case ConnectionState.done:
                      children = <Widget>[
                        for (var item in snapshot.data)
                          ListTile(
                            leading: CircleAvatar(
                              // backgroundImage:
                              //     NetworkImage(item['photo']),
                              radius: 30,
                            ),
                            title: Text(item['topic']),
                            subtitle: Text("Have you completed the Project?"),
                            onTap: () {
                              Navigator.of(context).push(
                                  CupertinoPageRoute<Null>(
                                      builder: (BuildContext context) {
                                return new ChatDetail(
                                    item['topic'], item['chat_id'],0);
                              }));
                            },
                          ),
                      ];
                      break;
                  }
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                );
              },
            ),

            // Text('There are no conversations to display.',
            //     style: TextStyle(color: Colors.grey))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(CupertinoPageRoute<Null>(builder: (BuildContext context) {
            return new ChatDetail('New Chat', '0',0);
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
