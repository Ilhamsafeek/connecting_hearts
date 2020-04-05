import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zamzam/model/Gridmodel.dart';
import 'package:zamzam/model/ImageSliderModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/services/services.dart';
import 'package:zamzam/ui/project.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

class Charity extends StatefulWidget {
  Charity({Key key}) : super(key: key);

  _CharityState createState() => _CharityState();
}

class _CharityState extends State<Charity> {
  ApiListener mApiListener;

  int _currentIndex = 0;
  int _currentIndexUp = 0;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[_bodyItem()],
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  Widget _bodyItem() {
    return SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          Container(
              width: double.maxFinite,
              color: Color.fromRGBO(104, 45, 127, 1),
              child: Container(
                child: CarouselSlider(
                  reverse: false,
                  aspectRatio: 5,
                  viewportFraction: 1.0,
                  initialPage: 0,
                  enlargeCenterPage: true,
                  autoPlay: false,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndexUp = index;
                      print(_currentIndexUp);
                    });
                  },
                  items: List<GridView>.generate((2), (int index) {
                    return GridView.count(
                      crossAxisCount: 4,
                      children: List<GridItemTop>.generate((4), (int index) {
                        return GridItemTop(
                            _getGridList()[index + (_currentIndexUp * 4)]);
                      }),
                    );
                  }),
                ),
              )),
          Container(
            color: Color.fromRGBO(104, 45, 127, 1),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (int index) {
                return dots(_currentIndexUp, index);
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.flash_on,
                    color: Colors.orange,
                  ),
                  Text('School with a Smile 2020 happens today !'),
                ],
              ),
            ),
          ),
          FutureBuilder<dynamic>(
            future: WebServices(this.mApiListener)
                .getCategoryData(), // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;

              if (snapshot.hasData) {
                children = <Widget>[
                  GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      children: <Widget>[
                        for (var item in snapshot.data)
                          InkWell(
                              child: GridItem(GridModel("assets/zamzam.png",
                                  "${item['category']}", null)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Project(item['category'])),
                                );
                              }),
                      ]),
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
                    child: Text(
                        'something Went Wrong !'), //Error: ${snapshot.error}
                  )
                ];
              } else {
                children = <Widget>[
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      children: List<GridItem>.generate(12, (int index) {
                        return GridItem(
                            GridModel("assets/zamzam.png", "test", null));
                      }),
                    ),
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
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 1, bottom: 5),
            child: Container(
              color: Colors.white,
              child: CarouselSlider(
                aspectRatio: 2,
                viewportFraction: 1.0,
                initialPage: 0,
                autoPlayInterval: Duration(seconds: 2),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                pauseAutoPlayOnTouch: Duration(seconds: 2),
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
        ],
      ),
    );
  }

  List<GridModel> _getGridList() {
    List<GridModel> list = new List<GridModel>();
    list.add(new GridModel(
        "assets/add_money_passbook.png", "New Donation", Colors.white));
    list.add(new GridModel("assets/book.png", "My Appeals", Colors.white));
    list.add(new GridModel("assets/receipt.png", "My Receipt", Colors.white));
    list.add(new GridModel(
        "assets/calculator.png", "Calculate Zakath", Colors.white));

    list.add(new GridModel("assets/report.png", "Reports", Colors.white));
    list.add(
        new GridModel("assets/donations.png", "My donations", Colors.white));
    list.add(new GridModel(
        "assets/ic_passbook_header.png", "Subscriptions", Colors.white));
    list.add(new GridModel("assets/language.png", "Language", Colors.white));

    return list;
  }

  List<ImageSliderModel> _getImageSliderList() {
    List<ImageSliderModel> list = new List();

    list.add(new ImageSliderModel("assets/real.png"));
    list.add(new ImageSliderModel("assets/real.png"));
    list.add(new ImageSliderModel("assets/real.png"));
    list.add(new ImageSliderModel("assets/real.png"));

    return list;
  }

  CarouselSliderList(List<ImageSliderModel> getImageSliderList) {
    return getImageSliderList.map((i) {
      return Builder(builder: (BuildContext context) {
        return imageSliderItem(i);
      });
    }).toList();
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  Widget dots(int current, index) {
    if (current != index) {
      return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor(index),
          ));
    } else {
      return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              color: dotColor(index)));
    }
  }

  Widget imageSliderItem(ImageSliderModel i) {
    return Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            i.path,
            fit: BoxFit.cover,
          ),
        ));
  }

  Color dotColor(int index) {
    return _currentIndexUp == index ? Colors.white : Colors.grey;
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
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridItemTop extends StatelessWidget {
  GridModel gridModel;

  GridItemTop(this.gridModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1 / 2),
      child: Container(
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
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
