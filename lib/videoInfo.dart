import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VideoFeed extends StatefulWidget {
  VideoFeed({Key key}) : super(key: key);

  _VideoFeedState createState() => _VideoFeedState();
}

class _VideoFeedState extends State<VideoFeed> {
  ApiListener mApiListener;
  List<Map> data = [
    {
      'url': 'https://www.youtube.com/watch?v=3R6KnQLvZNI',
      'thumbnail': "https://i.ytimg.com/vi/3R6KnQLvZNI/maxresdefault.jpg",
      'title': 'Complete flutter course with 14+ apps',
      'date': 'May 15, 2019',
      'creator': 'Hitesh Choudhary',
      'profile_url':
          'https://yt3.ggpht.com/a/AGF-l7-GpYFwHDMQVXkOcO3Ra8bIoZhhiU3oluiJBw=s88-mo-c-c0xffffffff-rj-k-no',
    },
    {
      'url': 'https://www.youtube.com/watch?v=sPW7nDBqt8w',
      'thumbnail': 'https://i.ytimg.com/vi/sPW7nDBqt8w/maxresdefault.jpg',
      'title': 'The Flutter YouTube Channel is Here!',
      'date': 'Feb 22, 2019',
      'creator': 'Flutter',
      'profile_url':
          'https://yt3.ggpht.com/a/AGF-l7-pLWHhqjLR5ZVoKzV9_eU6IjYrDyhvSLRjsw=s88-mo-c-c0xffffffff-rj-k-no',
    },
    {
      'url': 'https://www.youtube.com/watch?v=vqPG1tU6-c0',
      'thumbnail': 'https://i.ytimg.com/vi/vqPG1tU6-c0/maxresdefault.jpg',
      'title': 'Introducing The Boring Show!',
      'date': 'Feb 22, 2019',
      'creator': 'Flutter',
      'profile_url':
          'https://yt3.ggpht.com/a/AGF-l7-pLWHhqjLR5ZVoKzV9_eU6IjYrDyhvSLRjsw=s88-mo-c-c0xffffffff-rj-k-no',
    },
    {
      'url': 'https://www.youtube.com/watch?v=frEG8f0Aa1c',
      'thumbnail': 'https://i.ytimg.com/vi/frEG8f0Aa1c/maxresdefault.jpg',
      'title': 'Flutter vs React native',
      'date': 'Apr 10, 2019',
      'creator': 'Hitesh Choudhary',
      'profile_url':
          'https://yt3.ggpht.com/a/AGF-l7-GpYFwHDMQVXkOcO3Ra8bIoZhhiU3oluiJBw=s88-mo-c-c0xffffffff-rj-k-no',
    },
    {
      'url': 'https://youtu.be/GE0oeBj9Cr0',
      'thumbnail': 'https://i.ytimg.com/vi/GE0oeBj9Cr0/maxresdefault.jpg',
      'title': 'How to create first flutter for web project   step by step',
      'date': 'May 11, 2019',
      'creator': 'Hitesh Choudhary',
      'profile_url':
          'https://yt3.ggpht.com/a/AGF-l7-GpYFwHDMQVXkOcO3Ra8bIoZhhiU3oluiJBw=s88-mo-c-c0xffffffff-rj-k-no',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
            child: new RefreshIndicator(
          child: SingleChildScrollView(child: Container(child: videoCadge())),
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
                          controlsVisibleAtStart: false,
                        ),
                      ),
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
