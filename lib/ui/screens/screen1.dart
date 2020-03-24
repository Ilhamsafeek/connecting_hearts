import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final flutubePlayer = null;
  ApiListener mApiListener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
            child: new RefreshIndicator(
          child: SingleChildScrollView(child: Container(child: videoCadge())),
          color: Colors.black,
          onRefresh: _handleRefresh,
        )));
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
                  AspectRatio(
                    child: YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId:
                            YoutubePlayer.convertUrlToId(item['url']),
                        flags: YoutubePlayerFlags(
                          autoPlay: false,
                          mute: false,
                          hideThumbnail: false,
                          disableDragSeek: false,
                        ),
                      ),
                      thumbnailUrl: YoutubePlayer.getThumbnail(
                          videoId: YoutubePlayer.convertUrlToId(item['url'])),
                    ),
                    aspectRatio: 16 / 9,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(item['profile_url']),
                    ),
                    title: Text(
                      item['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item['lecturer'] + " . " + item['date'],
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    trailing: Icon(Icons.more_vert),
                  ),
                ],
              ))
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
