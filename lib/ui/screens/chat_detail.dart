import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:zamzam/services/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ChatDetail extends StatefulWidget {
  final dynamic chatTopic;
  final dynamic chatId;
  ChatDetail(this.chatTopic, this.chatId, {Key key}) : super(key: key);

  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  static ApiListener mApiListener;
  Stream<dynamic> _bids;

  @override
  void initState() {
    _bids = (() async* {
      var url = 'https://www.chadmin.online/api/getchatbyid';
      var response = await http.post(url, body: {
        'chat_id': widget.chatId,
      });
      var jsonServerData = json.decode(response.body);
      print(jsonServerData);
      print("=======>>>>>>($jsonServerData)");
      yield jsonServerData;
    })();
    super.initState();
  }

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
                          stream: _bids,
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
                                              child: Text(item['message']),
                                            )
                                          : Bubble(
                                              style: styleMe,
                                              child: Text(item['message']),
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
                                    SizedBox(height: 5)
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
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ChatInput(widget.chatId),
            ),
          ],
        ),
      ),
    );

    // bottomSheet: _bottomSheet

    // );
  }
}

class ChatInput extends StatefulWidget {
  final dynamic chatId;

  ChatInput(this.chatId, {Key key}) : super(key: key);
  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  TextEditingController _messageController = TextEditingController();
  ApiListener mApiListener;
  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.transparent),
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
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
                        width: 56, height: 56, child: Icon(Icons.send, color: Colors.white,)),
                    onTap: () {
                      setState(() async {
                        await WebServices(mApiListener)
                            .createChat(widget.chatId, _messageController.text);
                        _messageController.clear();
                        _messageController.text = '';
                      });
                    },
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
