import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class Project extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<Project> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Projects",
              style: TextStyle(fontFamily: "Exo2", color: Colors.white)),
          backgroundColor: Color.fromRGBO(104, 45, 127, 1),
        ),
        body: new RefreshIndicator(
          child: SingleChildScrollView(child: Container(child: buildData())),
          onRefresh: _handleRefresh,
        ));
  }

  Widget buildData() {
    return FutureBuilder<dynamic>(
      future: WebServices(this.mApiListener)
          .getData(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          children = <Widget>[
            for (var item in snapshot.data) projectCard(item),
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
              child: Text('Error: ${snapshot.error}'),
            )
          ];
        } else {
          children = <Widget>[
            SizedBox(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(''),
            )
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

  Card projectCard(dynamic data) {
   
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.album),
            title: Text('${data['category']}'),
            subtitle: Text('Family of ${data['children']} Members'),
            trailing: Icon(
              Icons.star_border,
              color: Colors.orange,
            ),
          ),
          ListTile(
            leading: Text('${data['district']}'),
            trailing: Text(
              '${data['amount']}',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          ListTile(
            title: Text('view more'),
          ),
        ],
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));

    setState(() {});

    return null;
  }
}
