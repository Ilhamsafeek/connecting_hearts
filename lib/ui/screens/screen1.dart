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

  List myList;
  final List<String> images = [
    "https://uae.microless.com/cdn/no_image.jpg",
    "https://images-na.ssl-images-amazon.com/images/I/81aF3Ob-2KL._UX679_.jpg",
    "https://www.boostmobile.com/content/dam/boostmobile/en/products/phones/apple/iphone-7/silver/device-front.png.transform/pdpCarousel/image.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgUgs8_kmuhScsx-J01d8fA1mhlCR5-1jyvMYxqCB8h3LCqcgl9Q",
    "https://ae01.alicdn.com/kf/HTB11tA5aiAKL1JjSZFoq6ygCFXaw/Unlocked-Samsung-GALAXY-S2-I9100-Mobile-Phone-Android-Wi-Fi-GPS-8-0MP-camera-Core-4.jpg_640x640.jpg",
    "https://media.ed.edmunds-media.com/gmc/sierra-3500hd/2018/td/2018_gmc_sierra-3500hd_f34_td_411183_1600.jpg",
    "https://hips.hearstapps.com/amv-prod-cad-assets.s3.amazonaws.com/images/16q1/665019/2016-chevrolet-silverado-2500hd-high-country-diesel-test-review-car-and-driver-photo-665520-s-original.jpg",
    "https://www.galeanasvandykedodge.net/assets/stock/ColorMatched_01/White/640/cc_2018DOV170002_01_640/cc_2018DOV170002_01_640_PSC.jpg",
    "https://media.onthemarket.com/properties/6191869/797156548/composite.jpg",
    "https://media.onthemarket.com/properties/6191840/797152761/composite.jpg",
  ];

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
                          Image.network(images[index]),
                          Text("Some text"),
                        ],
                      ),
                    ),
                itemCount: 10)

            // SliverFillRemaining(
            //   child: StaggeredGridView.countBuilder(
            //     crossAxisCount: 4,
            //     itemCount: 10,
            //     itemBuilder: (BuildContext context, int index) => Card(
            //       child: Column(
            //         children: <Widget>[
            //           Image.network(images[index]),
            //           Text("Some text"),
            //         ],
            //       ),
            //     ),
            //     staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
            //     mainAxisSpacing: 4.0,
            //     crossAxisSpacing: 4.0,
            //   ),
            // ),
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
