import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:zamzam/model/Gridmodel.dart';
import 'package:zamzam/model/ImageSliderModel.dart';
import 'package:zamzam/services/services.dart';
import 'package:zamzam/ui/project_detail.dart';
import 'package:zamzam/ui/screens/charity.dart';
import 'package:zamzam/ui/screens/details/categories.dart';
import 'package:zamzam/ui/screens/jobs.dart';
import 'package:zamzam/ui/screens/updates.dart';
import 'package:zamzam/ui/sermon/sermons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zamzam/ui/zakat_calculator.dart';
import 'dart:async';
import 'package:zamzam/test.dart';

import '../media.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

Future<dynamic> _zamzamUpdates;

class _HomeState extends State<Home> {
  ApiListener mApiListener;
  dynamic projectData;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WebServices(this.mApiListener).getProjectData().then((data) {
      setState(() {
        projectData =
            data.where((el) => el['completed_percentage'] != "100").toList();
      });
    });

    _zamzamUpdates = WebServices(this.mApiListener).getZamzamUpdateData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey[200],
            body: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(child: _zamzamUpdatesSlider())),
                      );
                    },
                    childCount: 1,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Container(child: _dashboardGrid())),
                      );
                    },
                    childCount: 1,
                  ),
                ),
              ],
            )));
  }

  List<ImageSliderModel> _getImageSliderList(data) {
    List<ImageSliderModel> list = new List();
    for (var item in data) {
      list.add(new ImageSliderModel(item['image_url']));
    }

    return list;
  }

  carouselSliderList(List<ImageSliderModel> getImageSliderList) {
    return getImageSliderList.map((i) {
      return Builder(builder: (BuildContext context) {
        return imageSliderItem(i);
      });
    }).toList();
  }

  Widget imageSliderItem(ImageSliderModel i) {
    return Container(
      // padding: EdgeInsets.only(left: 8, right: 8),
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
      child: CachedNetworkImage(
        imageUrl: i.path,
        placeholder: (context, url) => Image.asset('assets/placeholder.png'),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _dashboardGrid() {
    return GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        children: <Widget>[
          InkWell(
              child: Card(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
               Image.asset('assets/help-a-nest.png')
              ])),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new Categories('assets/help-a-nest.png', 'School With a Smile', 'School with a Smile is our flagship project which has so far helped over 60,000 students with a complete pack of school supplies including shoes, school bag, exercise books & stationary being distributed via temples, mosques, churches and other community centres. Beneficiary students are selected through school principals and education authorities with the objective of helping the needy students in order to minimize school drop-outs and to ensure the financial burden of the parents is reduced so the savings can be used for betterment of their quality of life.');
                }));
              }),
          InkWell(
              child: Card(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Image.asset('assets/feed-a-family.png')
              ])),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new Categories('assets/feed-a-family.png', 'Feed a Family', '“Feed a Family” is an annual project carried out by Zam Zam Foundation since 2014 to provide with food provisions to support needy families across Sri Lanka, in the holy month of Ramadan. So far the project has supported more than to 40,000 families in many districts in Sri Lanka by easing their burden during Ramadan. An extra effort is made to share the spirit of charity and goodwill in the month of Ramadhan, with other faith communities as well by giving such Food Provisions totaling 30KG, to needy families in multi-ethnic localities.');
                }));
              }),
          InkWell(
              child: Card(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Image.asset('assets/school-with-a-smile.png')
              ])),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new Categories('assets/school-with-a-smile.png', 'Help a Nest', '“Help a Nest” project primarily focuses on fulfilling housing & shelter needs of communities through both restricted “Zakath” charity donations and other donations by Sri Lankan Muslim community. A significant percentage of the funds are allocated to provide shelter for needy families from other ethnic and religious communities as a conscious effort to build interfaith harmony and to serve humanity.');
                }));
              }),
          InkWell(
              child: Card(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
               Image.asset('assets/healthy-society.png')
             
              ])),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new Categories('assets/healthy-society.png', 'Healthy Society', '“Healthy Society” is an initiative which focuses on building interfaith and inter-community relationships in mixed ethnic neighborhoods and villages by facilitating partnerships within communities to work towards finding solutions for common needs of the village. Projects include building water tanks for safe drinking water, renovation of common facilities in rural hospitals, assisting with infrastructure needs of schools where children from multiple faith and ethnic groups study together, etc. the sustainability of the projects are managed by local committees comprising community and religious leaders from diverse backgrounds');
                }));
              }),
          InkWell(
              child: Card(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Image.asset('assets/sankalpa.png')
               
              ])),
              onTap: () {
                // Navigator.of(context).push(
                //     CupertinoPageRoute<Null>(builder: (BuildContext context) {
                //   return new Test();
                // }));
              }),
          InkWell(
              child: Card(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
               Image.asset('assets/e-charity.png')
              ])),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new Charity();
                }));
              }),
          InkWell(
              child: Card(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
               Image.asset('assets/vip.png')
              ])),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new Updates();
                }));
              }),
          InkWell(
              child: Card(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Image.asset('assets/zamzam-media.png')
                
              ])),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new Media();
                }));
              }),
          InkWell(
              child: Card(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
               Image.asset('assets/job-bank.png',width: 45,)
              ])),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new Jobs();
                }));
              }),
        ]);
  }

  Widget _gridView() {
    return GridView.builder(
      itemCount: 250,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) => CachedNetworkImage(
        imageUrl: 'https://loremflickr.com/100/100/music?lock=$index',
      ),
    );
  }

  Widget _zamzamUpdatesSlider() {
    return FutureBuilder<dynamic>(
        future: _zamzamUpdates,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Widget> children;
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              dynamic data = snapshot.data.toList();
              children = <Widget>[
                CarouselSlider(
                  aspectRatio: 12 / 9,
                  viewportFraction: 1.0,
                  initialPage: 0,
                  autoPlayInterval: Duration(seconds: 4),
                  autoPlayAnimationDuration: Duration(milliseconds: 500),
                  pauseAutoPlayOnTouch: Duration(seconds: 4),
                  enlargeCenterPage: true,
                  autoPlay: true,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                      print(_currentIndex);
                    });
                  },
                  items: carouselSliderList(_getImageSliderList(data)),
                ),
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
                  child:
                      Text('something Went Wrong !'), //Error: ${snapshot.error}
                )
              ];
            }
          } else {
            children = <Widget>[
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset('assets/placeholder.png'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        });
  }

  Widget _buildProjectList() {
    return SliverStaggeredGrid.countBuilder(
        crossAxisCount: 4,
        staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
        itemBuilder: (BuildContext context, int index) {
          var formattedAmount = FlutterMoneyFormatter(
                  amount: double.parse('${projectData[index]['amount']}'))
              .output
              .withoutFractionDigits;
          return Card(
            child: GestureDetector(
              child: Column(
                children: <Widget>[
                  Stack(children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: projectData[index]['featured_image'],
                      placeholder: (context, url) =>
                          Image.asset('assets/placeholder.png'),
                      fit: BoxFit.cover,
                    ),
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
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(children: <Widget>[
                      Text(
                          "${projectData[index]['project_type']} . ${projectData[index]['category']} . ${projectData[index]['sub_category']}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          )),
                      SizedBox(
                        height: 6.0,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text("Rs.$formattedAmount"),
                      ),
                    ]),
                  )
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new ProjectDetail(projectData[index]);
                }));
              },
            ),
          );
        },
        itemCount: projectData.length);
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
                width: 40,
                height: 40,
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
