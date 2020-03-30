import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zamzam/model/Gridmodel.dart';


class Library extends StatefulWidget {
  Library({Key key}) : super(key: key);

  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  List myList;
  ScrollController _scrollController = ScrollController();
  int _currentMax = 10;

  @override
  void initState() {
    super.initState();
    myList = List.generate(10, (i) => "Item : ${i + 1}");
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  _getMoreData() {
    for (int i = _currentMax; i < _currentMax + 10; i++) {
      myList.add("Item : ${i + 1}");
    }

    _currentMax = _currentMax + 10;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: ListView.builder(
      //   controller: _scrollController,
      //   itemExtent: 80,
      //   itemBuilder: (context, i) {
      //     if (i == myList.length) {
      //       return CupertinoActivityIndicator();
      //     }
      //     return ListTile(
      //       title: Text(myList[i]),
      //     );
      //   },
      //   itemCount: myList.length + 1,
      // ),
      body: GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          children: <Widget>[
            InkWell(
                child: GridItem(GridModel("assets/zamzam.png", "Test", null)),
               
               ),
          ]),
    );
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
              CircleAvatar(child: Icon(Icons.stars)),
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
