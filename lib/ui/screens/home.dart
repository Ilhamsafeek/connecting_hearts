import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zamzam/model/Gridmodel.dart';
import 'package:zamzam/model/ImageSliderModel.dart';
import 'package:zamzam/services/services.dart';
import 'package:zamzam/ui/project_detail.dart';
import 'package:zamzam/ui/screens/charity.dart';
import 'package:zamzam/ui/screens/jobs.dart';
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
  dynamic projectData;
  int _currentIndex = 0;
  final ScrollController controller = ScrollController();

  @override
  void didChangeDependencies() {
    WebServices(this.mApiListener).getProjectData().then((data) {
      setState(() {
        projectData = data;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 244,

              flexibleSpace: Padding(
                padding: EdgeInsets.all(8),
                child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    children: <Widget>[
                      InkWell(
                          child: Card(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                ListTile(
                                  title: Image.asset('assets/charity.png'),
                                ),
                                Text('Charity')
                              ])),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute<Null>(
                                builder: (BuildContext context) {
                              return new Charity();
                            }));
                          }),
                      InkWell(
                          child: Card(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                ListTile(
                                  title: Image.asset('assets/sermon.png'),
                                ),
                                Text('Sermons')
                              ])),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute<Null>(
                                builder: (BuildContext context) {
                              return new Sermons();
                            }));
                          }),
                      InkWell(
                          child: Card(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                ListTile(
                                  title: Image.asset('assets/job-bank.png'),
                                ),
                                Text('Job Bank')
                              ])),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute<Null>(
                                builder: (BuildContext context) {
                              return new Jobs();
                            }));
                          }),
                      InkWell(
                          child: Card(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                ListTile(
                                  title: Image.asset('assets/calculator.png'),
                                ),
                                Center(
                                  child: Text(
                                    'Zakat\nCalculator',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ])),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute<Null>(
                                builder: (BuildContext context) {
                              return new ZakatCalculator();
                            }));
                          }),
                      InkWell(
                          child: Card(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                ListTile(
                                  title: Image.asset('assets/updates.png'),
                                ),
                                Text('Updates')
                              ])),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute<Null>(
                                builder: (BuildContext context) {
                              return new Jobs();
                            }));
                          }),
                      InkWell(
                          child: Card(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                ListTile(
                                  title: Image.asset('assets/elearning.png'),
                                ),
                                Text('eLearning')
                              ])),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute<Null>(
                                builder: (BuildContext context) {
                              return new Jobs();
                            }));
                          }),
                    ]),
              ),

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
                      padding: const EdgeInsets.only(bottom: 5),
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
                        child: GestureDetector(
                          child: Column(
                            children: <Widget>[
                              Stack(children: <Widget>[
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
                            Navigator.of(context).push(CupertinoPageRoute<Null>(
                                builder: (BuildContext context) {
                              return new ProjectDetail(projectData[index]);
                            }));
                          },
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
