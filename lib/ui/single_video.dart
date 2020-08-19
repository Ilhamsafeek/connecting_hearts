
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Play extends StatefulWidget {
  
  final dynamic video;
    static const routeName = '/play';
  Play(this.video, {Key key}) : super(key: key);
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
                    child: YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId:
                            widget.video['id']['videoId'],
                        flags: YoutubePlayerFlags(
                          autoPlay: true,
                          mute: false,
                          hideThumbnail: false,
                          disableDragSeek: false,
                        ),
                      ),
                     
                    ),
                     aspectRatio: 16 / 9,
                   
                  ),
     
      ),
    );
  }
}
