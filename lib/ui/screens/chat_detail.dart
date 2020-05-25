import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:zamzam/services/services.dart';
import 'dart:async';

class ChatDetail extends StatefulWidget {
  final dynamic chatTopic;
  final dynamic chatId;
  ChatDetail(this.chatTopic, this.chatId, {Key key}) : super(key: key);

  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  static ApiListener mApiListener;
  StreamController _messageController;
  TextEditingController _chatController = TextEditingController();
  Timer timer;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _messageController = new StreamController();
    timer = Timer.periodic(Duration(seconds: 1), (_) => loadMessages());

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  loadMessages() async {
    print('Chat ID ========>>>>> ${widget.chatId}');
    WebServices(mApiListener).getChatById(widget.chatId).then((res) async {
      _messageController.add(res);
      return res;
    });
  }

  // Future<Null> _handleRefresh() async {
  //   _bids().then((res) async {
  //     _messageController.add(res);
  //     return null;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );

    return Scaffold(
       key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.chatTopic),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                color: Colors.grey[200],
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 10),
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: StreamBuilder<dynamic>(
                          stream: _messageController.stream,
                          builder: (context, snapshot) {
                            List<Widget> children;
                            if (snapshot.hasError) {
                              print(snapshot.error);
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
                                    SizedBox(
                                      child: SpinKitPulse(
                                        color: Colors.grey,
                                        size: 120.0,
                                      ),
                                      width: 50,
                                      height: 50,
                                    ),

                                    // const Padding(
                                    //   padding: EdgeInsets.only(top: 16),
                                    //   child: Text('Awaiting chat...'),
                                    // )
                                  ];
                                  break;
                                case ConnectionState.active:
                                  children = <Widget>[
                                    Bubble(
                                      alignment: Alignment.center,
                                      color: Color.fromARGB(255, 212, 234, 244),
                                      elevation: 1 * px,
                                      margin: BubbleEdges.only(top: 8.0),
                                      child: Text('TODAY',
                                          style: TextStyle(fontSize: 10)),
                                    ),
                                    for (var item in snapshot.data)
                                      item['chat_from_phone'] != CURRENT_USER
                                          ? Bubble(
                                              style: styleSomebody,
                                              child: Text(item['message'],
                                                  style: TextStyle(
                                                      fontSize: 15.5)),
                                            )
                                          : Bubble(
                                              style: styleMe,
                                              child: Text(item['message'],
                                                  style: TextStyle(
                                                      fontSize: 15.5)),
                                            ),
                                  ];
                                  break;
                                case ConnectionState.done:
                                  children = <Widget>[
                                    Bubble(
                                      alignment: Alignment.center,
                                      color: Color.fromARGB(255, 212, 234, 244),
                                      elevation: 1 * px,
                                      margin: BubbleEdges.only(top: 8.0),
                                      child: Text('TODAY',
                                          style: TextStyle(fontSize: 10)),
                                    ),
                                    for (var item in snapshot.data)
                                      item['chat_from_phone'] != CURRENT_USER
                                          ? Bubble(
                                              style: styleSomebody,
                                              child: Text(item['message']),
                                            )
                                          : Bubble(
                                              style: styleMe,
                                              child: Text(item['message']),
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
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: _chatBox()),
          ],
        ),
      ),
    );

    // bottomSheet: _bottomSheet

    // );
  }

  Widget _chatBox() {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.transparent),
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _chatController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Please enter the message',
                hintStyle: TextStyle(
                  fontSize: 16,
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: border,
                disabledBorder: border,
                border: border,
                errorBorder: border,
                focusedErrorBorder: border,
                focusedBorder: border,
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              child: ClipOval(
                child: Material(
                  color: Colors.blue, // button color
                  child: InkWell(
                      splashColor: Colors.red, // inkwell color
                      child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                      onTap: () async {
                        if (_chatController.text != '') {
                          await WebServices(mApiListener).createChat(
                              widget.chatTopic,
                              widget.chatId,
                              _chatController.text);
                          _chatController.clear();
                          _chatController.text = '';
                          print(widget.chatId.runtimeType);
                          if (widget.chatId != '0') {
                          } else {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Message sent to management."),
                            ));
                            await Future.delayed(new Duration(seconds: 2));
                            Navigator.pop(context);
                          }
                        }
                      }),
                ),
              ))
        ],
      ),
    );
  }
}
