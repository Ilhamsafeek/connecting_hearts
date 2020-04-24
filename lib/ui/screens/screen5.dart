import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zamzam/model/Gridmodel.dart';
import 'package:zamzam/ui/zakat_calculator.dart';

class Chat extends StatefulWidget {
  Chat({Key key}) : super(key: key);

  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
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
      body: 

       Center(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/chat.png',
                height: 250,
                color: Colors.grey[200],
              ),
              Text('There are no conversations to display.', style: TextStyle(color: Colors.grey))
              
            ],
          ),
        ),
      
    );
  }
}
