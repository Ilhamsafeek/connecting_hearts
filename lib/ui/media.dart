import 'dart:convert';

import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zamzam/model/Gridmodel.dart';
import 'package:zamzam/services/services.dart';
import 'package:zamzam/ui/sermon/channels.dart';
import 'package:zamzam/ui/single_video.dart';
import 'package:timeago/timeago.dart' as timeago;
class Media extends StatefulWidget {
  Media({Key key}) : super(key: key);

  _MediaState createState() => _MediaState();
}

class _MediaState extends State<Media> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
            expandedHeight: 138,
            pinned: true,
            title: Text('ZamZam Media'),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/sermon_title.png',
                color: Colors.white60,
              ),
            )),
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
                padding: EdgeInsets.only(top: 20, left: 8, right: 8),
                child: Column(
                  children: <Widget>[
                    FutureBuilder<dynamic>(
                      future: WebServices(this.mApiListener)
                          .getYoutubeChannelData(), // a previously-obtained Future<String> or null
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        List<Widget> children;

                        if (snapshot.hasData) {
                          
                          var data = snapshot.data;
                          children = <Widget>[
                            for (var item in data['items'])
                              Container(
                                  child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: AspectRatio(
                                      child: Image(
                                        width: 30,
                                        image: NetworkImage(item['snippet']
                                            ['thumbnails']['medium']['url']),
                                        centerSlice: Rect.largest,
                                      ),
                                      aspectRatio: 320 / 180,
                                    ),
                                    title: Text(item['snippet']['title']),
                                    subtitle: Text(timeago.format(DateTime.parse(item['snippet']['publishTime']))),
                                    // trailing: FlatButton.icon(
                                    //   onPressed: () {},
                                    //   icon: Icon(Icons.file_download),
                                    //   label: Text('4.5MB'),
                                    // ),
                                    // trailing: Text(item['kind'], style: TextStyle(fontSize: 10),),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Play(item)),
                                      );
                                    },
                                  ),
                                  Divider(height: 1)
                                ],
                              ))
                          ];

                          return Center(
                            child: Column(
                              children: AnimationConfiguration.toStaggeredList(
                                duration: const Duration(milliseconds: 375),
                                childAnimationBuilder: (widget) =>
                                    SlideAnimation(
                                  horizontalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: widget,
                                  ),
                                ),
                                children: children,
                              ),
                            ),
                          );
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
                    )

                    // FutureBuilder<dynamic>(
                    //     future: WebServices(this.mApiListener)
                    //         .getYoutubeChannelData(),
                    //     builder: (BuildContext context,
                    //         AsyncSnapshot<dynamic> snapshot) {
                    //       List<Widget> children;

                    //       if (snapshot.hasData) {

                    //         children = <Widget>[Text(json.encode(snapshot.data['items'])+": ")];
                    //       } else if (snapshot.hasError) {
                    //         children = <Widget>[
                    //           Icon(
                    //             Icons.error_outline,
                    //             color: Colors.red,
                    //             size: 60,
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.only(top: 16),
                    //             child: Text(
                    //                 'something Went Wrong !'), //Error: ${snapshot.error}
                    //           )
                    //         ];
                    //       } else {
                    //         children = <Widget>[
                    //           SizedBox(
                    //             child: SpinKitPulse(
                    //               color: Colors.grey,
                    //               size: 120.0,
                    //             ),
                    //             width: 50,
                    //             height: 50,
                    //           ),
                    //           const Padding(
                    //             padding: EdgeInsets.only(top: 16),
                    //             child: Text(''),
                    //           )
                    //         ];
                    //       }
                    //       return Center(
                    //           child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: children,
                    //       ));
                    //     }),
                  ],
                ));
          },
          childCount: 1,
        ))
      ],
    ));
  }
}
