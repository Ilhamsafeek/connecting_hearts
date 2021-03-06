import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paytm_ui/model/Gridmodel.dart';
import 'package:flutter_paytm_ui/model/ImageSliderModel.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Paytm extends StatefulWidget {
  @override
  _PaytmState createState() => _PaytmState();
}

class _PaytmState extends State<Paytm> {
  int _currentIndex = 0;
  int _currentIndexUp = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: _bodyItem(),
        drawer: _drawer(),
        backgroundColor: Colors.grey[200],
        bottomNavigationBar: _bottemTab());
  }


  Widget _drawer(){
   return new Drawer(
  // Add a ListView to the drawer. This ensures the user can scroll
  // through the options in the drawer if there isn't enough vertical
  // space to fit everything.
  child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        child:UserAccountsDrawerHeader(
          decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0),
    ),
  accountName: Text("Ilham Safeek"),
  accountEmail: Text("ilhamsafeek@yahoo.com"),
  currentAccountPicture: CircleAvatar(
    backgroundColor:Colors.white,
    child: Text(
      "I",
      style: TextStyle(fontSize: 40.0),
    ),
  ),
),
        decoration: BoxDecoration(
          image: DecorationImage(
                  image: AssetImage("assets/profilebackground.png"),
                     fit: BoxFit.cover)
              ),
        
      ),
      ListTile(
        leading: Icon(Icons.person),
        title: Text('Profile'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        leading: Icon(Icons.favorite),
        title: Text('Whish List'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
           ListTile(
        leading: Icon(Icons.settings),
        title: Text('Settings'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        leading: Icon(Icons.settings, color: Colors.white,),
        title: Text('Logout'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
    ],
  ),
);

  }

  Widget _appBar() {
    return new AppBar(
      title: Row(
        children: <Widget>[
          
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              height: 40,
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 1.35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(Icons.search,color: Colors.blue,),
                  ),


                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Image.asset(
                      "assets/uanotif_nomessage.png",
                      color: Colors.blue,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      elevation: 0,
    );
  }

  Widget _bottemTab() {
    return new BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: [
          new BottomNavigationBarItem(
              icon: Image.asset(
                "assets/home.png",
                width: 24.0,
                height: 24.0,
              ),
              title: Text(
                'Home',
              )),
          new BottomNavigationBarItem(
              icon: Image.asset(
                "assets/delivery.png",
                width: 24.0,
                height: 24.0,
              ),
              title: Text(
                'Inbox',
              )),
          new BottomNavigationBarItem(
              icon: Image.asset(
                "assets/contact.png",
                width: 24.0,
                height: 24.0,
              ),
              title: Text(
                'Contact',
              )),    
          new BottomNavigationBarItem(
              icon: Image.asset(
                "assets/videos.png",
                width: 24.0,
                height: 24.0,
              ),
              title: Text(
                'Video',
              )),
          
          new BottomNavigationBarItem(
              icon: Image.asset(
                "assets/download.png",
                width: 24.0,
                height: 24.0,
              ),
              title: Text(
                'downloads',
              )),
         
        ]);
  }

  Widget _bodyItem() {
    return SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          Container(
              width: double.maxFinite,
              color: Colors.blue[800],
              child: Container(
                child: CarouselSlider(reverse: false,
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
                  items: List<GridView>.generate(
                      (2), (int index) {
                    return GridView.count(
                      crossAxisCount: 4,
                      children: List<GridItemTop>.generate((4), (int index) {
                        return GridItemTop(
                            _getGridList()[index + (_currentIndexUp * 4)]);
                      }),
                    );
                  }),
                ),
              )

//            GridView.builder(
//              gridDelegate:
//                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
//              scrollDirection: Axis.horizontal,
//              itemCount: _getGridList().length,
//              itemBuilder: (context, index) {
//                return GridList(_getGridList()[index]);
//              },
//            ),
          ),


          Container( color: Colors.blue[800],
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
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.flash_on, color: Colors.orange,),
                  Text('School with a Smile 2020 happens today !'),
                  Image.asset(
                    "assets/right-arrow.png",
                    height: 13,
                    width: 13,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            children: List<GridItem>.generate(12, (int index) {
              return GridItem(_getGridItemList()[index]);
            }),
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

  List<GridModel> _getGridItemList() {
    List<GridModel> list = new List<GridModel>();
    list.add(new GridModel("assets/zamzam.png", "ZZF\nprojects", null));
    list.add(new GridModel("assets/help.png", "Help\na Needy", null));
    list.add(new GridModel("assets/sadaka.png", "Sadaka", null));
    list.add(new GridModel("assets/sanitation.png", "Sanitation", null));
    list.add(new GridModel("assets/health.png", "Health", null));
    list.add(new GridModel("assets/empowerment.png", "Empowerment", null));
    list.add(new GridModel("assets/marriage.png", "Marriage", null));
    list.add(new GridModel("assets/shelter.png", "Shelter", null));
    list.add(new GridModel("assets/education.png", "Education", null));
    list.add(new GridModel("assets/relife.png", "Relief", null));
    list.add(new GridModel("assets/success-stories.png", "Success\nStories", null));
    list.add(
        new GridModel("assets/events.png", "Events", null));
    return list;
  }

  List<GridModel> _getGridList() {
    List<GridModel> list = new List<GridModel>();
    list.add(new GridModel("assets/add_money_passbook.png", "New Donation", Colors.white));
    list.add(new GridModel("assets/book.png", "My Appeals", Colors.white));
    list.add(new GridModel("assets/receipt.png", "My Receipt", Colors.white));
    list.add(new GridModel("assets/calculator.png", "Calculate Zakath", Colors.white));

    list.add(new GridModel("assets/report.png", "Reports", Colors.white));
    list.add(new GridModel("assets/donations.png", "My donations", Colors.white));
    list.add(new GridModel("assets/ic_passbook_header.png", "Subscriptions", Colors.white));
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
              color: dotColor(index)
          ));
    }
  }


  Widget imageSliderItem(ImageSliderModel i) {
    return Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            i.path,
            fit: BoxFit.cover,
          ),
        ));
  }

  Color dotColor(int index) {
    return _currentIndexUp == index
        ? Colors.white
        : Colors.grey;
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
                  style: TextStyle(fontSize: 12, color: Colors.white,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



