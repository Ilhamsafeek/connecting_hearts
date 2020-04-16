import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zamzam/ui/sermon/channel_detail.dart';
import 'package:zamzam/ui/single_video.dart';
import 'package:zamzam/ui/sermon/channels.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final flutubePlayer = null;
  ApiListener mApiListener;
  bool loaded = false;
  dynamic projectData = [
    {"featured_image": "https://uae.microless.com/cdn/no_image.jpg", "category":""}
  ];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!loaded) {
      WebServices(this.mApiListener).getProjectData().then((data) {
        setState(() {
          projectData = data;
          loaded = true;
        });
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              // expandedHeight: 5,
              title: Row(
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child: FlatButton.icon(
                          icon: Icon(
                            Icons.voice_chat,
                            color: Colors.grey[800],
                            size: 30,
                          ),
                          label: Text(
                            'Channels',
                          ),
                          onPressed: () {
                            // Navigator.of(context, rootNavigator: true).push(
                            //   new CupertinoPageRoute<bool>(
                            //     maintainState: true,
                            //     fullscreenDialog: true,
                            //     builder: (context) => Channels('Personal'))
                            // );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Channels('Personal')),
                            );
                          })),
                  Expanded(
                      flex: 4,
                      child: FlatButton.icon(
                          icon: Icon(
                            Icons.offline_bolt,
                            color: Colors.teal,
                            size: 30,
                          ),
                          label: Text('Special Updates'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Channels('Special')),
                            );
                          })),
                ],
              ),

              backgroundColor: Colors.white,
              floating: true,
              // pinned: false,
            ),
            SliverStaggeredGrid.countBuilder(
                crossAxisCount: 4,
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                itemBuilder: (BuildContext context, int index) => Card(
                      child: Column(
                        children: <Widget>[
                          Image.network(projectData[index]['featured_image']),
                          Text(projectData[index]['category']),
                        ],
                      ),
                    ),
                itemCount: projectData.length)
          ],
        ));
  }

  Widget projectCadge() {
    return FutureBuilder<dynamic>(
      future: WebServices(this.mApiListener).getProjectData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          dynamic data = snapshot.data;

          return SliverStaggeredGrid.countBuilder(
              crossAxisCount: 4,
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
              itemBuilder: (BuildContext context, int index) => Card(
                    child: Column(
                      children: <Widget>[
                        Image.network(data[index]['featured_image']),
                        Text("Some text"),
                      ],
                    ),
                  ),
              itemCount: data.length);
        } else if (snapshot.hasError) {
          children = <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('something Went Wrong !'), //Error: ${snapshot.error}
            )
          ];
        } else {
          children = <Widget>[
            Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Container(
                    child: Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Container(color: Colors.black),
                    ),
                    ListTile(
                      leading: InkWell(
                        child: CircleAvatar(),
                      ),
                      title: Container(
                        color: Colors.black,
                        height: 10,
                        width: 10,
                      ),
                      subtitle: Container(
                        color: Colors.black,
                        height: 6,
                        width: 50.0,
                      ),
                      trailing: Icon(Icons.more_vert),
                    ),
                    AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Container(color: Colors.black),
                    ),
                    ListTile(
                      leading: InkWell(
                        child: CircleAvatar(),
                      ),
                      title: Container(
                        color: Colors.black,
                        height: 10,
                        width: 10,
                      ),
                      subtitle: Container(
                        color: Colors.black,
                        height: 6,
                        width: 50.0,
                      ),
                      trailing: Icon(Icons.more_vert),
                    ),
                  ],
                )))
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
    );
  }

  Widget videoCadge() {
    return FutureBuilder<dynamic>(
      future: WebServices(this.mApiListener)
          .getSermonData(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          children = <Widget>[
            for (var item in snapshot.data)
              Container(
                  child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Play(item)),
                      );
                    },
                    child: AspectRatio(
                      child: Image(
                        image: NetworkImage(YoutubePlayer.getThumbnail(
                            videoId:
                                YoutubePlayer.convertUrlToId(item['url']))),
                        centerSlice: Rect.largest,
                      ),
                      aspectRatio: 16 / 10,
                    ),
                  ),
                  ListTile(
                    leading: InkWell(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(item['photo']),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, anim1, anim2) =>
                                ChannelDetail(item),
                            transitionsBuilder: (context, anim1, anim2,
                                    child) =>
                                FadeTransition(opacity: anim1, child: child),
                            transitionDuration: Duration(milliseconds: 100),
                          ),
                        );
                      },
                    ),
                    title: Text(
                      item['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item['channel'] + " . " + item['date'],
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    trailing: Icon(Icons.more_vert),
                  ),
                ],
              ))
          ];

          return Center(
            child: Column(
              // children: AnimationConfiguration.toStaggeredList(
              //   duration: const Duration(milliseconds: 375),
              //   childAnimationBuilder: (widget) => SlideAnimation(
              //     horizontalOffset: 50.0,
              //     child: SlideAnimation(
              //       child: widget,
              //     ),
              //   ),
              children: children,
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
              child: Text('something Went Wrong !'), //Error: ${snapshot.error}
            )
          ];
        } else {
          children = <Widget>[
            Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Container(
                    child: Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Container(color: Colors.black),
                    ),
                    ListTile(
                      leading: InkWell(
                        child: CircleAvatar(),
                      ),
                      title: Container(
                        color: Colors.black,
                        height: 10,
                        width: 10,
                      ),
                      subtitle: Container(
                        color: Colors.black,
                        height: 6,
                        width: 50.0,
                      ),
                      trailing: Icon(Icons.more_vert),
                    ),
                    AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Container(color: Colors.black),
                    ),
                    ListTile(
                      leading: InkWell(
                        child: CircleAvatar(),
                      ),
                      title: Container(
                        color: Colors.black,
                        height: 10,
                        width: 10,
                      ),
                      subtitle: Container(
                        color: Colors.black,
                        height: 6,
                        width: 50.0,
                      ),
                      trailing: Icon(Icons.more_vert),
                    ),
                  ],
                )))
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
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));

    setState(() {});

    return null;
  }
}
