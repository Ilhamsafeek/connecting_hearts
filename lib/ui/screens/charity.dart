import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:zamzam/model/Gridmodel.dart';
import 'package:zamzam/model/ImageSliderModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/services/services.dart';
import 'package:zamzam/ui/project.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class Charity extends StatefulWidget {
  Charity({Key key}) : super(key: key);

  _CharityState createState() => _CharityState();
}

class _CharityState extends State<Charity> {
  ApiListener mApiListener;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Charity')),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  alignment: Alignment.center,
                  child: _bodyItem(),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
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
          FutureBuilder<dynamic>(
            future: WebServices(this.mApiListener).getCategoryData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;

              if (snapshot.hasData) {
                children = <Widget>[
                  GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      children: <Widget>[
                        for (var item in snapshot.data)
                          InkWell(
                              child: GridItem(GridModel(
                                  item['photo'], "${item['category']}", null)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Project(item)),
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
                      crossAxisCount: 3,
                      children: List<GridItem>.generate(12, (int index) {
                        return GridItem(
                            GridModel("assets/ch_logo.png", "test", null));
                      }),
                    ),
                  ),
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
            },
          ),

          // Padding(
          //   padding: const EdgeInsets.only(top: 1, bottom: 5),
          //   child: Container(
          //     color: Colors.white,
          //     child: CarouselSlider(
          //       aspectRatio: 2,
          //       viewportFraction: 1.0,
          //       initialPage: 0,
          //       autoPlayInterval: Duration(seconds: 2),
          //       autoPlayAnimationDuration: Duration(milliseconds: 800),
          //       pauseAutoPlayOnTouch: Duration(seconds: 2),
          //       enlargeCenterPage: true,
          //       autoPlay: true,
          //       onPageChanged: (index) {
          //         setState(() {
          //           _currentIndex = index;
          //           print(_currentIndex);
          //         });
          //       },
          //       items: CarouselSliderList(_getImageSliderList()),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
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

  Future<void> saveToRecentOpens(String searchText) async {
    if (searchText == null) return; //Should not be null
    final pref = await SharedPreferences.getInstance();

    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches =
        pref.getStringList("recentOpenedCharity")?.toSet() ?? {};

    //Place it at first in the set
    allSearches = {searchText, ...allSearches};
    pref.setStringList("recentOpenedCharity", allSearches.toList());
  }

  Future<List<String>> getRecentOpensLike(String query) async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList("recentOpenedCharity");
    return allSearches.where((search) => search.startsWith(query)).toList();
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
              CachedNetworkImage(
                imageUrl: gridModel.imagePath,
                placeholder: (context, url) =>
                    Image.asset('assets/placeholder.png', width: 40,),
                width: 40,
                height: 40,
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
