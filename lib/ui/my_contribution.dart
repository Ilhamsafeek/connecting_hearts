import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zamzam/camera.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:zamzam/ui/camera.dart';

import 'package:camera/camera.dart';
import 'package:zamzam/ui/contributed_project.dart';

class MyContribution extends StatefulWidget {
  @override
  _MyContributionState createState() => _MyContributionState();

  // final dynamic projectData;
  // Payment(this.projectData, {Key key}) : super(key: key);
}

class _MyContributionState extends State<MyContribution> {
  ApiListener mApiListener;
  dynamic totalContribution = 0;
  Future<dynamic> _paymentData;

  @override
  void initState() {
    super.initState();
    WebServices(mApiListener).getPaymentData().then((value) {
      print(value);
      setState(() {
        dynamic total = 0;
        for (var item in value) {
          total = total + double.parse(item['paid_amount']);
        }
        totalContribution = total;
      });
    });
    _paymentData = WebServices(mApiListener).getPaymentData();
  }

  @override
  Widget build(BuildContext context) {
    FlutterMoneyFormatter formattedAmount =
        FlutterMoneyFormatter(amount: double.parse('$totalContribution'));
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              // automaticallyImplyLeading: false,

              expandedHeight: 200,
              // backgroundColor: Colors.indigo[900],
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: ListTile(
                  title: Text(
                    "Total contribution",
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  subtitle: RichText(
                    text: new TextSpan(
                      style: new TextStyle(
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(
                            text: 'Rs.',
                            style: new TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.w600)),
                        new TextSpan(
                            text:
                                '${formattedAmount.output.withoutFractionDigits}',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 25,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    child: Container(
                      child: Column(children: <Widget>[
                        FutureBuilder(
                          future: _paymentData,
                          builder: (context, snapshot) {
                            List<Widget> children;
                            if (snapshot.hasData) {
                              var data;
                              if (snapshot.data.length != 0) {
                                data = snapshot.data;
                                dynamic total = 0;
                                for (var item in data) {
                                  total =
                                      total + double.parse(item['paid_amount']);
                                }

                                children = <Widget>[
                                  for (var item in data) contributionCard(item)
                                ];
                                this.totalContribution = total;
                              } else {
                                children = <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: ListTile(
                                      title: Image.asset(
                                        "assets/my_contribution.png",
                                        width: 120,
                                        height: 120,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                      title: Text(
                                    'Make your donations simply and get access to project tracking.',
                                    style: TextStyle(
                                        color: Colors.black45, fontSize: 14),
                                    textAlign: TextAlign.center,
                                  )),
                                ];
                              }
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
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: SizedBox(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context)
                                                      .primaryColor))),
                                ),
                              ];
                            }
                            return Center(
                              child: Column(children: children),
                            );
                          },
                        ),
                      ]),
                    ),
                  );
                },
                childCount: 1,
              ),
            ),
          ],
        ));
  }

  Widget contributionCard(item) {
    FlutterMoneyFormatter formattedAmount =
        FlutterMoneyFormatter(amount: double.parse('${item['paid_amount']}'));
    Widget _trailing;
    Icon _statusIcon = Icon(
      Icons.check_circle,
      color: Colors.green,
    );

    dynamic _text = "You have donated. Now you can monitor the project status.";
    if (item['status'] == 'pending' && item['method'] == 'bank') {
      if (item['slip_url'] == "") {
        _trailing = RaisedButton(
          color: Colors.red,
          onPressed: () async {
            WidgetsFlutterBinding.ensureInitialized();
            final cameras = await availableCameras();
            final firstCamera = cameras.first;

            Navigator.of(context)
                .push(CupertinoPageRoute<Null>(builder: (BuildContext context) {
              return new TakePictureScreen(
                "${item['payment_id']}",
                firstCamera,
              );
            }));
          },
          child: Text(
            'Submit Deposit Slip',
            style: TextStyle(color: Colors.white),
          ),
        );

        _statusIcon = Icon(
          Icons.info_outline,
          color: Colors.orange,
        );
        _text =
            "You have donated. Please submit your bank slip to be effective";
      } else {
        _trailing = Column(children: <Widget>[
          //  CircleAvatar(child: Icon(Icons.insert_emoticon)),
          FlatButton.icon(
            icon: Icon(Icons.edit),
            onPressed: () async {
              WidgetsFlutterBinding.ensureInitialized();
              final cameras = await availableCameras();
              final firstCamera = cameras.first;

              Navigator.of(context).push(
                  CupertinoPageRoute<Null>(builder: (BuildContext context) {
                return new TakePictureScreen(
                  "${item['payment_id']}",
                  firstCamera,
                );
              }));
            },
            label: Text('Edit Slip'),
          ),
        ]);
        _statusIcon = Icon(
          Icons.schedule,
          color: Colors.blue,
        );
        _text =
            "You have submitted slip for your donation. your deposit slip is under review.";
      }
    }
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('${item['project_id']}'),
            subtitle: Text(
              '${item['date_time']}',
              style: TextStyle(fontSize: 12),
            ),
            trailing: FlatButton.icon(
                onPressed: () {
                  infoModalBottomSheet(context, _statusIcon, _text);
                },
                icon: _statusIcon,
                label: Chip(
                    backgroundColor: Colors.blueGrey[50],
                    label: Text(
                        'Rs.${formattedAmount.output.withoutFractionDigits}',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0)))),
          ),
          Divider(height: 0),
          ListTile(
              leading: FlatButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContributedProject(item)),
                    );
                  },
                  icon: Icon(Icons.list),
                  label: Text('More details')),
              trailing: _trailing)
        ],
      ),
    );
  }

  Future<bool> infoModalBottomSheet(context, icon, text) {
    return showModalBottomSheet(
        enableDrag: true,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: ListTile(
                        title: Text('What does it means?'),
                        trailing: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )),
                  Divider(
                    height: 0,
                  ),
                  ListTile(
                    leading: icon,
                    title: Text(text),
                  ),
                ],
              ),
            );
          });
        });
  }
}
