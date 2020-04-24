import 'package:flutter/material.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:zamzam/ui/project_detail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share/share.dart';

class Project extends StatefulWidget {
  @override
  final dynamic categoryData;

  Project(this.categoryData, {Key key}) : super(key: key);
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
          title: Text(widget.categoryData['category'],
              style: TextStyle(fontFamily: "Exo2", color: Colors.white)),
          actions: <Widget>[
            Image.network(
              widget.categoryData['photo'],
              width: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            )
          ],
          backgroundColor: Color.fromRGBO(104, 45, 127, 1),
        ),
        body: Center(
            child: new RefreshIndicator(
          child: SingleChildScrollView(child: Container(child: buildData())),
          onRefresh: _handleRefresh,
        )));
  }

  Widget buildData() {
    return FutureBuilder<dynamic>(
      future: WebServices(this.mApiListener)
          .getProjectData(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          var data = snapshot.data
              .where((el) =>
                  el['project_category_id'] == this.widget.categoryData['project_category_id'])
              .toList();

          children = <Widget>[
            for (var item in data) projectCard(item),
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

    double completedPercent = 100 *
        double.parse('${data['collected']}') /
        double.parse('${data['amount']}');
    Color completedColor = Colors.blue;
    Color percentColor = Colors.white;
    if (completedPercent >= 100) {
      completedPercent = 100.0;
      completedColor = Colors.orange;
    }

    double percent = completedPercent / 100;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(children: <Widget>[
            ClipRRect(
              // borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              child: Image.network(data['featured_image']),
            ),
            // Container(
            //   height: MediaQuery.of(context).size.width * 0.58,
            //   width: MediaQuery.of(context).size.width,
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: [
            //         const Color(0xCC000000),
            //         const Color(0x00000000),
            //         const Color(0x00000000),
            //         const Color(0xCC000000),
            //       ],
            //     ),
            //   ),
            // ),
            Center(
                child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    '${data['appeal_id']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.5, 0.5),
                  blurRadius: 3.0,
                  color: Colors.black,
                ),
              ],),
                  ),
                  subtitle: Text('Family of ${data['children']} Members',
                      style: TextStyle(color: Colors.white, shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.5, 0.5),
                  blurRadius: 3.0,
                  color: Colors.black,
                ),
              ],)),
                  trailing: Chip(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    backgroundColor: Colors.amber,
                    avatar: Icon(
                      Icons.star_border,
                      color: Colors.white,
                     
                    ),
                    label: Text(
                      "${data['rating']}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(top: 40),
                  title: FlatButton.icon(
                      onPressed: null,
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 14.0,
                      ),
                      label: Text(
                        '${data['city']}, ${data['district']}',
                        style: TextStyle(color: Colors.white,shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.5, 0.5),
                  blurRadius: 3.0,
                  color: Colors.black,
                ),
              ],),
                      )),
                  subtitle: new LinearPercentIndicator(
                    alignment: MainAxisAlignment.start,
                    animation: true,
                    lineHeight: 14.0,
                    animationDuration: 2000,
                    width: 150.0,
                    percent: percent,
                    center: Text(
                      "${double.parse(completedPercent.toStringAsFixed(2))}%",
                      style: new TextStyle(fontSize: 12.0, color: percentColor),
                    ),
                    trailing: Text(
                      'Rs.' + '${formattedAmount.output.withoutFractionDigits}',
                      style: TextStyle(
                          fontFamily: "Exo2",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.5, 0.5),
                  blurRadius: 3.0,
                  color: Colors.black,
                ),
              ],),
                    ),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    backgroundColor: Colors.grey,
                    progressColor: completedColor,
                  ),
                ),
              
              ],
            )),
          ]),
          Container(
            color: Colors.black,
            width: double.infinity,
            height: 0.1,
          ),
          Container(
              child: Row(children: <Widget>[
            Expanded(
              child: FlatButton.icon(
                icon: Icon(
                  Icons.list,
                  color: Colors.green,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProjectDetail(data)),
                  );
                },
                label: Text('View more'),
              ),
            ),
            Expanded(
              child: FlatButton.icon(
                icon: Icon(
                  Icons.share,
                  color: Colors.green,
                ),
                onPressed: () {
                  Share.share('check out my website https://example.com',
                      subject: 'Look what I made!');
                },
                label: Text('Share'),
              ),
            ),
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
