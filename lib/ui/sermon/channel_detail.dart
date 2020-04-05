import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zamzam/ui/single_video.dart';

class ChannelDetail extends StatefulWidget {
  @override
  _ChannelDetailState createState() => _ChannelDetailState();
  final dynamic channelData;
  ChannelDetail(this.channelData, {Key key}) : super(key: key);
}

class _ChannelDetailState extends State<ChannelDetail> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        expandedHeight: 200.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            widget.channelData['channel'],
            style: TextStyle(color: Colors.white, shadows: []),
          ),
          background: Image.asset(
            'assets/mufti_menk.jpg',
            fit: BoxFit.cover,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share this appeal',
            onPressed: () {
              Share.share('check out my website https://example.com',
                  subject: 'Look what I made!');
            },
          ),
        ],
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              alignment: Alignment.center,
              child: _detailSection(widget.channelData['channel_id']),
            );
          },
          childCount: 1,
        ),
      )
    ]));
  }

  Widget _detailSection(channelId) {
    return Column(
      children: AnimationConfiguration.toStaggeredList(
        duration: const Duration(milliseconds: 375),
        childAnimationBuilder: (widget) => SlideAnimation(
          horizontalOffset: 50.0,
          child: FadeInAnimation(
            child: widget,
          ),
        ),
        children: <Widget>[
          ExpansionTile(
            title: Text(
              "Description about this channel",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text('Addedd 3 years ago'),
            leading: CircleAvatar(
              backgroundImage: new AssetImage('assets/mufti_menk.jpg'),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(widget.channelData['description']),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: FlatButton.icon(
                    color: Colors.blue[900],
                    icon: Icon(Icons.wb_sunny, color: Colors.white),
                    onPressed: () {},
                    label: Text(
                      'Subscribe',
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
                ],
              ),
            ],
            initiallyExpanded: false,
          ),
          Divider(),
          FutureBuilder<dynamic>(
            future: WebServices(this.mApiListener)
                .getSermonData(), // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;

              if (snapshot.hasData) {
                var data = snapshot.data.where((el)=> el['channel_id']==channelId).toList();
                children = <Widget>[
                  for (var item in data)
                    Container(
                        child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: AspectRatio(
                            child: Image(
                              width: 30,
                              image: NetworkImage(YoutubePlayer.getThumbnail(
                                  videoId: YoutubePlayer.convertUrlToId(
                                      item['url']))),
                              centerSlice: Rect.largest,
                            ),
                            aspectRatio: 16 / 10,
                          ),
                          title: Text(item['title']),
                          subtitle: Text(item['date']),
                          // trailing: FlatButton.icon(
                          //   onPressed: () {},
                          //   icon: Icon(Icons.file_download),
                          //   label: Text('4.5MB'),
                          // ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Play(item)),
                            );
                          },
                        ),
                        Divider(height:1)
                      ],
                    ))
                ];

                return Center(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
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
      ),
    );
  }

}
