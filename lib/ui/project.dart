import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:zamzam/ui/project_detail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          centerTitle: true,
          title: Text("Projects",
              style: TextStyle(fontFamily: "Exo2", color: Colors.white)),
          backgroundColor: Color.fromRGBO(104, 45, 127, 1),
        ),
        body: Center(
        child: new RefreshIndicator(
          child: SingleChildScrollView(child: Container(child: buildData())),
          onRefresh: _handleRefresh,
        )
        )
        );
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
              child: Text('something Went Wrong !'), //Error: ${snapshot.error}
            )
          ];
        } else {
          children = <Widget>[
            SizedBox(
              child: SpinKitPulse(
            color: Colors.grey,
            size: 120.0,
          ),
              width: 50,
              height: 50,
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0))),
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: FlatButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.location_on,
                  size: 14.0,
                ),
                label: Text(
                  '${data['city']}, ${data['district']}',
                  style: TextStyle(color: Colors.blue),
                )),
          ),
          ListTile(
            trailing: Column(children: <Widget>[
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontFamily: "Exo2",
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                  children: [
                    WidgetSpan(
                      child: Text('Rs.'),
                    ),
                    TextSpan(text: '${formattedAmount.output.withoutFractionDigits}'),
                  ],
                  
                ),
              ),
            
             Icon(Icons.straighten)
            ]),
          ),
          Container(
            color: Colors.black,
            width: double.infinity,
            height: 0.1,
          ),
          Container(
              child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                InkWell(
                    child: Text("view more"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProjectDetail(data)),
                      );
                    }),
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
