import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zamzam/model/Gridmodel.dart';
import 'package:zamzam/model/IconGridModel.dart';
import 'package:zamzam/model/ImageSliderModel.dart';
import 'package:zamzam/services/services.dart';
import 'package:zamzam/ui/project_detail.dart';
import 'package:zamzam/ui/screens/screen2.dart';
import 'package:zamzam/ui/screens/screen3.dart';
import 'package:zamzam/ui/sermon/channel_detail.dart';
import 'package:zamzam/ui/sermon/sermons.dart';
import 'package:zamzam/ui/single_video.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zamzam/ui/zakat_calculator.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final flutubePlayer = null;
  ApiListener mApiListener;
  bool loaded = false;
  dynamic projectData;
  int _currentIndex = 0;

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
              expandedHeight: 150,
              title: Padding(
                padding: EdgeInsets.only(top: 8),
                child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    children: <Widget>[
                      InkWell(
                          child: GridItem(GridModel("assets/report.png",
                              "Charity", Theme.of(context).primaryColor)),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute<Null>(
                                builder: (BuildContext context) {
                              return new Charity();
                            }));
                          }),
                      InkWell(
                          child: GridItem(GridModel("assets/donations.png",
                              "Sermons", Theme.of(context).primaryColor)),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute<Null>(
                                builder: (BuildContext context) {
                              return new Sermons();
                            }));
                          }),
                      InkWell(
                          child: GridItem(GridModel(
                              "assets/ic_passbook_header.png",
                              "Job Bank",
                              Theme.of(context).primaryColor)),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute<Null>(
                                builder: (BuildContext context) {
                              return new Jobs();
                            }));
                          }),
                      InkWell(
                          child: GridItem(GridModel("assets/calculator.png",
                              "Zakat", Theme.of(context).primaryColor)),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute<Null>(
                                builder: (BuildContext context) {
                              return new ZakatCalculator();
                            }));
                          }),
                    ]),
              ),

              // Row(
              //   children: <Widget>[
              //     Expanded(
              //         flex: 3,
              //         child: FlatButton.icon(
              //             icon: Icon(
              //               Icons.voice_chat,
              //               color: Colors.grey[800],
              //               size: 30,
              //             ),
              //             label: Text(
              //               'Jumma Bayan',
              //             ),
              //             onPressed: () {
              //               // Navigator.of(context, rootNavigator: true).push(
              //               //   new CupertinoPageRoute<bool>(
              //               //     maintainState: true,
              //               //     fullscreenDialog: true,
              //               //     builder: (context) => Channels('Jumma Bayan'))
              //               // );
              //               Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => Channels('Jumma Bayan')),
              //               );
              //             })),
              //     Expanded(
              //         flex: 4,
              //         child: FlatButton.icon(
              //             icon: Icon(
              //               Icons.offline_bolt,
              //               color: Colors.teal,
              //               size: 30,
              //             ),
              //             label: Text('Special Bayan'),
              //             onPressed: () {
              //               Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => Channels('Special Bayan')),
              //               );
              //             })),
              //   ],
              // ),

              backgroundColor: Colors.white,
              floating: true,
              // pinned: false,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1, bottom: 5),
                      child: Container(
                        color: Colors.white,
                        child: CarouselSlider(
                          aspectRatio: 2,
                          viewportFraction: 1.0,
                          initialPage: 0,
                          autoPlayInterval: Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 500),
                          pauseAutoPlayOnTouch: Duration(seconds: 5),
                          enlargeCenterPage: true,
                          autoPlay: true,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                              print(_currentIndex);
                            });
                          },
                          items: CarouselSliderList(_getImageSliderList()),
                        ),
                      ),
                    ),
                  );
                },
                childCount: 1,
              ),
            ),
            projectData != null
                ? SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 4,
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.fit(2),
                    itemBuilder: (BuildContext context, int index) {
                      var formattedAmount = FlutterMoneyFormatter(
                              amount: double.parse(
                                  '${projectData[index]['amount']}'))
                          .output
                          .withoutFractionDigits;
                      return Card(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              child: Stack(children: <Widget>[
                                Image.network(
                                    projectData[index]['featured_image']),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Column(children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.stars,
                                            color: Colors.amber,
                                            size: 20,
                                          ),
                                          Text(
                                            projectData[index]['rating'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: Offset(0.0, 0.0),
                                                  blurRadius: 3.0,
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ]))
                              ]),
                              onTap: () {
                                Navigator.of(context).push(
                                    CupertinoPageRoute<Null>(
                                        builder: (BuildContext context) {
                                  return new ProjectDetail(projectData[index]);
                                }));
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Column(children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.network(
                                      "${projectData[index]['photo']}",
                                      height: 20,
                                    ),
                                   
                                  ],
                                )
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Column(children: <Widget>[
                                
                                Text(
                                  "${projectData[index]['project_type']} . ${projectData[index]['category']} . ${projectData[index]['sub_category']}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("Rs.$formattedAmount")
                              ]),
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: projectData.length)
                : SliverFillRemaining(
                    child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.black))
                      ],
                    ),
                  ))
          ],
        ));
  }

  List<ImageSliderModel> _getImageSliderList() {
    List<ImageSliderModel> list = new List();

    list.add(new ImageSliderModel("assets/real.png"));
    list.add(new ImageSliderModel("assets/child.png"));
    list.add(new ImageSliderModel("assets/real.png"));
    list.add(new ImageSliderModel("assets/child.png"));

    return list;
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
                        // Navigator.push(
                        //   context,
                        //   PageRouteBuilder(
                        //     pageBuilder: (context, anim1, anim2) =>
                        //         ChannelDetail(item),
                        //     transitionsBuilder: (context, anim1, anim2,
                        //             child) =>
                        //         FadeTransition(opacity: anim1, child: child),
                        //     transitionDuration: Duration(milliseconds: 100),
                        //   ),
                        // );
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

  CarouselSliderList(List<ImageSliderModel> getImageSliderList) {
    return getImageSliderList.map((i) {
      return Builder(builder: (BuildContext context) {
        return imageSliderItem(i);
      });
    }).toList();
  }

  Widget imageSliderItem(ImageSliderModel i) {
    return Container(
        // padding: EdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ClipRRect(
          // borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            i.path,
            fit: BoxFit.cover,
          ),
        ));
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));

    setState(() {});

    return null;
  }
}

class GridItem extends StatelessWidget {
  GridModel gridModel;

  GridItem(this.gridModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1 / 2),
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                gridModel.imagePath,
                width: 30,
                height: 30,
                color: gridModel.color,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  gridModel.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
