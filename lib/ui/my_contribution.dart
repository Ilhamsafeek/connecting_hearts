import 'package:flutter/material.dart';
import 'package:zamzam/services/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:zamzam/ui/camera.dart';
import 'package:camera/camera.dart';
class MyContribution extends StatefulWidget {
  @override
  _MyContributionState createState() => _MyContributionState();

  // final dynamic projectData;
  // Payment(this.projectData, {Key key}) : super(key: key);
}

class _MyContributionState extends State<MyContribution> {
  ApiListener mApiListener;
  dynamic totalContribution = 0;

  @override
  void initState() {
    super.initState();
    WebServices(mApiListener).getPaymentData().then((value) {
      print(value);
      setState(() {
        dynamic total = 0;
        for (var item in value) {
          total = total + double.parse(item['amount']);
        }
        totalContribution = total;
      });
    });
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
                title: Container(
                  child: Expanded(
                    child: ListTile(
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
                          future: WebServices(mApiListener).getPaymentData(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            List<Widget> children;
                            if (snapshot.hasData) {
                              var data;
                              if (snapshot.data.length != 0) {
                                data = snapshot.data;
                                dynamic total = 0;
                                for (var item in data) {
                                  total = total + double.parse(item['amount']);
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
                                        "assets/add_payment_method.png",
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
                                const Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: SizedBox(
                                      child: CircularProgressIndicator()),
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
        FlutterMoneyFormatter(amount: double.parse('${item['amount']}'));
    Widget _trailing;
    Icon _status_icon = Icon(
      Icons.check_circle,
      color: Colors.green,
    );
    if (item['status'] == 'pending') {
      _trailing = RaisedButton(
        color: Colors.red,
         onPressed: () async {
                  // Ensure that plugin services are initialized so that `availableCameras()`
                  // can be called before `runApp()`
                  WidgetsFlutterBinding.ensureInitialized();
                  // Obtain a list of the available cameras on the device.
                  final cameras = await availableCameras();
                  // Get a specific camera from the list of available cameras.
                  final firstCamera = cameras.first;
                  Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => TakePictureScreen(
                      camera: firstCamera,
                    ),));
                 
                }
              ,
        child: Text(
          'Submit Deposit Slip',
          style: TextStyle(color: Colors.white),
        ),
      );
      _status_icon = Icon(
        Icons.info_outline,
        color: Colors.orange,
      );
    }
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            // onTap: () {},
            title: Text('Project ID: ${item['project_id']}'),
            subtitle: Text('${item['date_time']}'),
            trailing: FlatButton.icon(
                onPressed: null,
                icon: _status_icon,
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
              title: Text(
                'Receipt Number: ${item['receipt_no']}',
                style: TextStyle(fontSize: 12),
              ),
              trailing: _trailing)
        ],
      ),
    );
  }
}
