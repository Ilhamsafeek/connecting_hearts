import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class ProjectDetail extends StatefulWidget {
  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();

  final dynamic projectData;
  ProjectDetail(this.projectData, {Key key}) : super(key: key);
}

class _ProjectDetailPageState extends State<ProjectDetail> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('${widget.projectData['category']}'),
              background:
                  // Image.network(
                  //   'assets/real.png',
                  //   fit: BoxFit.cover,
                  // ),
                  Image.asset(
                "assets/child.png",
                fit: BoxFit.cover,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Share this appeal',
                onPressed: () {/* ... */},
              ),
            ],
          ),
          SliverFillRemaining(
            child: new Center(
              child: Column(children: <Widget>[
                ListTile(
                  title: Text('${widget.projectData['details']}'),
                ),
                Container(
                  color: Colors.black,
                  width: double.infinity,
                  height: 0.1,
                ),
              ]),
            ),
          )
        ]));
  }

  Card projectCard(dynamic data) {
    FlutterMoneyFormatter formattedAmount =
        FlutterMoneyFormatter(amount: double.parse('${data['amount']}'));

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.album),
            title: Text('${data['category']}'),
            subtitle: Text('Family of ${data['children']} Members'),
            trailing: FlatButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.star_border,
                  color: Colors.orange,
                ),
                label: Text('${data['rating']}',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ),
          ListTile(
            leading: FlatButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.location_on,
                  size: 14.0,
                ),
                label: Text(
                  '${data['city']},${data['district']}',
                  style: TextStyle(color: Colors.blue),
                )),
          ),
          ListTile(
            trailing: FlatButton.icon(
                onPressed: null,
                icon: Text('Rs.'),
                label: Text('${formattedAmount.output.nonSymbol}',
                    style: TextStyle(
                        fontFamily: "Exo2",
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0))),
          ),
          Container(
            color: Colors.black,
            width: double.infinity,
            height: 0.1,
          ),
          Container(
              child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: const <Widget>[
                InkWell(
                  child: Text("view more"),
                  onTap: null,
                )
              ]))
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
