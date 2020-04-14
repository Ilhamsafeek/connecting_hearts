import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:zamzam/ui/payment_result.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share/share.dart';
import 'package:zamzam/utils/read_more_text.dart';

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

  String selectedMethod;
  dynamic paymentAmount;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _amount = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();

  selectsku(method) {
    print(method);
    setState(() {
      selectedMethod = method;
    });
  }

  ApiListener mApiListener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('${widget.projectData['appeal_id']}'),
              background: Image.asset(
                "assets/child.png",
                fit: BoxFit.cover,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Share this appeal',
                onPressed: () {
                  Share.share('check out my website https://example.com',
                      subject: 'Please look at this appeal!');
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  alignment: Alignment.center,
                  child: _detailSection(),
                );
              },
              childCount: 1,
            ),
          ),
        ]));
  }

  Widget _detailSection() {
    print('=========================>>>>>>>${widget.projectData}');
    var paymentTypeExtension = "";
    var months = '${widget.projectData['months']}';
    if (widget.projectData['type'] == 'recursive') {
      paymentTypeExtension = 'in $months months';
    } else {}

    FlutterMoneyFormatter formattedAmount = FlutterMoneyFormatter(
        amount: double.parse('${widget.projectData['amount']}'));
    FlutterMoneyFormatter formattedCollected = FlutterMoneyFormatter(
        amount: double.parse('${widget.projectData['collected']}'));

    double completedPercent = 100 *
        double.parse('${widget.projectData['collected']}') /
        double.parse('${widget.projectData['amount']}');
    Color completedColor = Colors.blue;
    Color percentColor = Colors.white;
    if (completedPercent >= 100) {
      completedPercent = 100.0;
      completedColor = Colors.orange;
    }

    double percent = completedPercent / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(
            24,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: RichText(
                      text: new TextSpan(
                        style: new TextStyle(
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          new TextSpan(
                              text: 'Posted: ',
                              style:
                                  new TextStyle(fontWeight: FontWeight.w600)),
                          new TextSpan(text: '${widget.projectData['date']}'),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "Star Rating:",
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.stars,
                    color: Colors.orange,
                    size: 18,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "${widget.projectData['rating']}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              Divider(),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Categories: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Chip(
                            label:
                                Text('${widget.projectData['project_type']}')),
                      ),
                      Expanded(
                        child: Chip(
                            label: Text('${widget.projectData['category']}')),
                      ),
                      Expanded(
                        child: Chip(
                            label:
                                Text('${widget.projectData['sub_category']}')),
                      ),
                    ],
                  ),
                ],
              ),
              // Column(
              //   children: <Widget>[
              //     Row(
              //       children: <Widget>[
              //         Text('Address: ',
              //             style: new TextStyle(fontWeight: FontWeight.bold)),
              //         Expanded(
              //             child: Text(
              //                 '${widget.projectData['mahalla']}, ${widget.projectData['city']}, ${widget.projectData['district']}')),
              //       ],
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Divider(height: 0),
              ListTile(
                title: ReadMoreText("${widget.projectData['details']}"),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
          ),
          child: Column(
            children: <Widget>[
              RichText(
                text: new TextSpan(
                  style: new TextStyle(
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    new TextSpan(
                        text: 'Rs.',
                        style: new TextStyle(fontWeight: FontWeight.w600)),
                    new TextSpan(
                        text: '${formattedAmount.output.withoutFractionDigits}',
                        style: TextStyle(fontSize: 32)),
                  ],
                ),
              ),
              new LinearPercentIndicator(
                alignment: MainAxisAlignment.center,
                animation: true,
                lineHeight: 14.0,
                animationDuration: 2000,
                width: 140.0,
                percent: percent,
                center: Text(
                  "${double.parse(completedPercent.toStringAsFixed(2))}%",
                  style: new TextStyle(fontSize: 12.0, color: percentColor),
                ),
                linearStrokeCap: LinearStrokeCap.roundAll,
                backgroundColor: Colors.grey,
                progressColor: completedColor,
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: RichText(
                  text: new TextSpan(
                    style: new TextStyle(
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      new TextSpan(
                          text: 'This appeal requires: ',
                          style: new TextStyle(fontWeight: FontWeight.w600)),
                      new TextSpan(
                          text:
                              '${widget.projectData['type']} payment $paymentTypeExtension'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Center(
                child: FlatButton.icon(
              color: Colors.orange,
              onPressed: () {
                payModalBottomSheet(context);
              },
              icon: Icon(Icons.lock_outline),
              label: Text(
                'Donate now',
                style: TextStyle(color: Colors.white),
              ),
            )))
      ],
    );
  }

  Future<bool> payModalBottomSheet(context) {
    return showModalBottomSheet(
        enableDrag: false,
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  ListTile(
                    title: Text('Choose a payment method'),
                    trailing: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Divider(
                    height: 0,
                  ),
                  paymentMethods(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 11,
                        child: RadioListTile(
                          selected: true,
                          activeColor: Colors.black,
                          value: 'bank',
                          groupValue: selectedMethod,
                          onChanged: selectsku,
                          title: ListTile(
                            leading: Icon(
                              FontAwesomeIcons.solidMoneyBillAlt,
                            ),
                            title: Text('Direct deposit'),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          icon: Icon(Icons.info_outline),
                          onPressed: () {
                            infoModalBottomSheet(context);
                          },
                        ),
                      )
                    ],
                  ),
                  Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        ListTile(
                            title: TextFormField(
                              controller: _amount,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please input amount";
                                }
                              },
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Amount',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              // onChanged: (value) {
                              //   this.paymentAmount = value;
                              // },
                            ),
                            onTap: () => {}),
                        ListTile(
                            title: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: RaisedButton(
                                    onPressed: () {
                                      _formKey.currentState.validate()
                                          ? _navigateToPayment()
                                          : null;
                                    },
                                    child: Text("Proceed Donation"),
                                    color: Colors.amber,
                                  )),
                                ],
                              ),
                            ),
                            onTap: () => {}),
                      ]))
                ],
              ),
            );
          });
        });
  }

  showPaymentProgress(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 5),
              child: Text("Recording donation..")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget paymentMethods() {
    return FutureBuilder<dynamic>(
      future: WebServices(this.mApiListener).getCustomerDataByMobile(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          var data;
          if (snapshot.data.length != 0) {
            data = snapshot.data[0]['sources']['data'];
          }
          children = <Widget>[
            for (var item in data)
              RadioListTile(
                activeColor: Colors.black,
                value: '${item['id']}',
                groupValue: selectedMethod,
                onChanged: selectsku,
                title: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.ccVisa,
                    color: Colors.indigo[700],
                  ),
                  title: Text('****${item['last4']}'),
                ),
              )
            // ),
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
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: SizedBox(child: CircularProgressIndicator()),
            ),
          ];
        }
        return Center(
          child: Column(children: children),
        );
      },
    );
  }

  Future<bool> infoModalBottomSheet(context) {
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
                        title: Text('How Direct diposit works?'),
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
                    leading: Icon(Icons.featured_play_list),
                    title: Text('Cast your donation'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                    ),
                    title: Text('Click and submit deposit slip'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.rate_review,
                      color: Colors.blue[800],
                    ),
                    title: Text('Our team will review and update'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: Colors.orange,
                    ),
                    title: Text('Finally you will get notified with status'),
                  ),
                ],
              ),
            );
          });
        });
  }

  _navigateToPayment() {
    if (this.selectedMethod != 'bank') {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentResult(
                selectedMethod, widget.projectData, _amount, 'card')),
      );
    } else {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentResult(
                selectedMethod, widget.projectData, _amount, 'bank')),
      );
    }
  }
}
