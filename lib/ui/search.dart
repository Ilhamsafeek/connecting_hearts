import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();

  
}

class _SearchState extends State<Search> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(
         
        ));
  }

  
  Widget _appBar() {
    return new AppBar(
      title: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              height: 35,
              width: MediaQuery.of(context).size.width / 1.35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                 
                 
                ],
              ),
            ),
          )
        ],
      ),
      elevation: 0,
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));

    setState(() {});

    return null;
  }
}
