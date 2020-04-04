import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zamzam/ui/sermon/channel_detail.dart';
import 'package:zamzam/ui/single_video.dart';
import 'package:zamzam/ui/sermon/channels.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final flutubePlayer = null;
  ApiListener mApiListener;

  List myList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              // expandedHeight: 5,
              backgroundColor: Colors.white,
              floating: true,
              // pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Row(
                  children: <Widget>[
                    InkWell(
                        child: Chip(
                          label: Text(
                            'Sermon Channels',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.grey[600],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Channels('Personal')),
                          );
                        }),
                        InkWell(
                        child:Chip(label: Text('Zamzam Updates')),
                     onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Channels('Special')),
                          );
                        }),
                    
                    
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                      alignment: Alignment.center,
                      child: Center(
                          child: new RefreshIndicator(
                        child: SingleChildScrollView(
                            child: Container(child: videoCadge())),
                        color: Colors.black,
                        onRefresh: _handleRefresh,
                      )));
                },
                childCount: 1,
              ),
            ),
          ],
        ));
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
                        backgroundImage: NetworkImage(item['profile_url']),
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
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FlipAnimation(
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
              child: Text('something Went Wrong !'), //Error: ${snapshot.error}
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
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));

    setState(() {});

    return null;
  }
}
