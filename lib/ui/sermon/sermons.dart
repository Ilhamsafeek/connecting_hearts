import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zamzam/model/Gridmodel.dart';
import 'package:zamzam/services/services.dart';
import 'package:zamzam/ui/sermon/channels.dart';
import 'package:zamzam/ui/single_video.dart';

class Sermons extends StatefulWidget {
  Sermons({Key key}) : super(key: key);

  _SermonsState createState() => _SermonsState();
}

class _SermonsState extends State<Sermons> {
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
            title: Text('Sermons'),
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
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: GestureDetector(
                          child: Card(
                              color: Colors.grey[200],
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Image.asset('assets/slider_2.png'),
                                    ),
                                    OutlineButton(
                                      onPressed: null,
                                      child: Text('jumma Bayan'),
                                      color: Colors.red,
                                    )
                                  ])),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute<Null>(
                                builder: (BuildContext context) {
                              return new Channels('Jumma Bayan');
                            }));
                          },
                        )),
                        Expanded(
                            child: GestureDetector(
                          child: Card(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                ListTile(
                                  title: Image.asset('assets/slider_3.png'),
                                ),
                                OutlineButton(
                                  onPressed: null,
                                  child: Text('Special Bayan'),
                                  color: Colors.red,
                                )
                              ])),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute<Null>(
                                builder: (BuildContext context) {
                              return new Channels('Special Bayan');
                            }));
                          },
                        ))
                      ],
                    ),
                    Text('Recently added '),
                    FutureBuilder<dynamic>(
                        future: WebServices(this.mApiListener).getChannelData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          List<Widget> children;

                          if (snapshot.hasData) {
                            children = <Widget>[
                              GridView.count(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 4,
                                  children: <Widget>[
                                    for (var item in snapshot.data)
                                      InkWell(
                                          child: GridItem(GridModel(
                                              item['photo'],
                                              "${item['channel']}",
                                              null)),
                                          onTap: () {}),
                                  ]),
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
                          ));
                        }),
                    FutureBuilder<dynamic>(
                      future: WebServices(this.mApiListener)
                          .getSermonData(), // a previously-obtained Future<String> or null
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        List<Widget> children;

                        if (snapshot.hasData) {
                          var data = snapshot.data;
                          children = <Widget>[
                            for (var item in data)
                              Container(
                                  child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: AspectRatio(
                                      child: Image(
                                        width: 30,
                                        image: NetworkImage(
                                            YoutubePlayer.getThumbnail(
                                                videoId: YoutubePlayer
                                                    .convertUrlToId(
                                                        item['url']))),
                                        centerSlice: Rect.largest,
                                      ),
                                      aspectRatio: 16 / 10,
                                    ),
                                    title: Text(item['title']),
                                    subtitle: Text(item['channel']),
                                    // trailing: FlatButton.icon(
                                    //   onPressed: () {},
                                    //   icon: Icon(Icons.file_download),
                                    //   label: Text('4.5MB'),
                                    // ),
                                    trailing: Text(item['date'], style: TextStyle(fontSize: 10),),
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
                  ],
                ));
          },
          childCount: 1,
        ))
      ],
    ));
  }
}
