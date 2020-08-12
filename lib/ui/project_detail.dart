import 'package:braintree_payment/braintree_payment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zamzam/payment/main.dart';
import 'package:zamzam/services/braintree.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:zamzam/ui/payment_result.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share/share.dart';
import 'package:zamzam/utils/read_more_text.dart';
import 'package:zamzam/utils/dialogs.dart';

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

  String selectedMethod = "bank";
  dynamic paymentAmount;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _amount = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();

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
              title: Text(
                '${widget.projectData['appeal_id']}',
                style: TextStyle(
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 3.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              background: CachedNetworkImage(
                imageUrl: widget.projectData['featured_image'],
                placeholder: (context, url) =>
                    Image.asset('assets/placeholder.png'),
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
                  Text(
                    'Categories',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 35,
                      child: new ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Chip(
                              label: Text(
                                  '${widget.projectData['project_type']}')),
                          Chip(
                              label: Text('${widget.projectData['category']}')),
                          Chip(
                              label: Text(
                                  '${widget.projectData['sub_category']}')),
                        ],
                      ))
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
              ),
              Text(
                "Bank details",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              ListTile(
                isThreeLine: true,
                //  leading: Text("Bank: ${widget.projectData['branch']}"),
                title: Text(
                    "Bank: ${widget.projectData['bank_name']}\nBranch: ${widget.projectData['branch']}"),
                subtitle: Text(
                    "Account number: ${widget.projectData['account_number']}\n\nSwift code: ${widget.projectData['swift_code']}"),
              ),
             
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
                  // paymentMethods(),

                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 11,
                        child: RadioListTile(
                          activeColor: Colors.black,
                          value: 'bank',
                          groupValue: selectedMethod,
                          onChanged: (T) {
                            print(T);
                            setState(() {
                              selectedMethod = T;
                            });
                          },
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
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 11,
                        child: RadioListTile(
                          activeColor: Colors.black,
                          value: 'card',
                          groupValue: selectedMethod,
                          onChanged: (T) {
                            print(T);
                            setState(() {
                              selectedMethod = T;
                            });
                          },
                          title: ListTile(
                            leading: Icon(
                              Icons.credit_card,
                              color: Colors.indigo[700],
                              size: 30,
                            ),
                            title: Text('Other Payment Methods'),
                          ),
                        ),
                      ),
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
                              onChanged: (value) {
                                print("====================${_amount.text}");
                              },
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
                                    child: Text("Checkout"),
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

  // Widget paymentMethods() {
  //   return FutureBuilder<dynamic>(
  //     future: WebServices(this.mApiListener).getCustomerDataByMobile(),
  //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  //       List<Widget> children;
  //       if (snapshot.hasData) {
  //         var data;
  //         if (snapshot.data.length != 0) {
  //           data = snapshot.data[0]['sources']['data'];
  //           children = <Widget>[
  //             for (var item in data)
  //               RadioListTile(
  //                 activeColor: Colors.black,
  //                 value: '${item['id']}',
  //                 groupValue: selectedMethod,
  //                 onChanged: selectMethod,
  //                 title: ListTile(
  //                   leading: Icon(
  //                     FontAwesomeIcons.ccVisa,
  //                     color: Colors.indigo[900],
  //                   ),
  //                   title: Text('****${item['last4']}'),
  //                 ),
  //               )
  //             // ),
  //           ];
  //         } else {
  //           children = <Widget>[
  //             ListTile(
  //               title: Text(
  //                 'Add Debit or Credit card',
  //                 style: TextStyle(color: Colors.blue),
  //               ),
  //               onTap: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(builder: (context) => StripePayment()),
  //                 );
  //               },
  //             ),
  //           ];
  //         }
  //       } else if (snapshot.hasError) {
  //         children = <Widget>[
  //           Icon(
  //             Icons.error_outline,
  //             color: Colors.red,
  //             size: 60,
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(top: 16),
  //             child: Text('something Went Wrong !'), //Error: ${snapshot.error}
  //           )
  //         ];
  //       } else {
  //         children = <Widget>[
  //           Padding(
  //             padding: EdgeInsets.only(top: 16),
  //             child: SizedBox(
  //                 child: CircularProgressIndicator(
  //                     valueColor: new AlwaysStoppedAnimation<Color>(
  //                         Theme.of(context).primaryColor))),
  //           ),
  //         ];
  //       }
  //       return Center(
  //         child: Column(children: children),
  //       );
  //     },
  //   );
  // }

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

  _navigateToPayment() async {
    if (this.selectedMethod == 'bank') {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Checkout(
                selectedMethod, widget.projectData, _amount.text, 'bank')),
      );
    } else {
      Navigator.pop(context);
      showWaitingProgress(context);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => Checkout(
      //           selectedMethod, widget.projectData, _amount.text, 'bank')),
      // );
      String clientNonce =
          // "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiJlNTc1Mjc3MzZiODkyZGZhYWFjOTIxZTlmYmYzNDNkMzc2ODU5NTIxYTFlZmY2MDhhODBlN2Q5OTE5NWI3YTJjfGNyZWF0ZWRfYXQ9MjAxOS0wNS0yMFQwNzoxNDoxNi4zMTg0ODg2MDArMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJncmFwaFFMIjp7InVybCI6Imh0dHBzOi8vcGF5bWVudHMuc2FuZGJveC5icmFpbnRyZWUtYXBpLmNvbS9ncmFwaHFsIiwiZGF0ZSI6IjIwMTgtMDUtMDgifSwiY2hhbGxlbmdlcyI6W10sImVudmlyb25tZW50Ijoic2FuZGJveCIsImNsaWVudEFwaVVybCI6Imh0dHBzOi8vYXBpLnNhbmRib3guYnJhaW50cmVlZ2F0ZXdheS5jb206NDQzL21lcmNoYW50cy8zNDhwazljZ2YzYmd5dzJiL2NsaWVudF9hcGkiLCJhc3NldHNVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbSIsImF1dGhVcmwiOiJodHRwczovL2F1dGgudmVubW8uc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbSIsImFuYWx5dGljcyI6eyJ1cmwiOiJodHRwczovL29yaWdpbi1hbmFseXRpY3Mtc2FuZC5zYW5kYm94LmJyYWludHJlZS1hcGkuY29tLzM0OHBrOWNnZjNiZ3l3MmIifSwidGhyZWVEU2VjdXJlRW5hYmxlZCI6dHJ1ZSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjp0cnVlLCJtZXJjaGFudEFjY291bnRJZCI6ImFjbWV3aWRnZXRzbHRkc2FuZGJveCIsImN1cnJlbmN5SXNvQ29kZSI6IlVTRCJ9LCJtZXJjaGFudElkIjoiMzQ4cGs5Y2dmM2JneXcyYiIsInZlbm1vIjoib2ZmIn0=";
          "sandbox_rz775339_x226f9698ybxg938"; // Tokenized key

      BraintreePayment braintreePayment = new BraintreePayment();
      var companyData = await WebServices(this.mApiListener).getCompanyData();
      Navigator.pop(context);
      var data = await braintreePayment.showDropIn(
          nonce: companyData['tokenized_key'], amount: _amount.text);

      print("Response of the payment $data");
      showWaitingProgress(context);
      if (data['status'] == 'success') {
        var saleResponse = await Braintree(mApiListener).sale(_amount.text,
            data['paymentNonce'], widget.projectData, 'card', 'pending');

        print(saleResponse);

        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.green[600],
          content: Text("$saleResponse"),
        ));
      }
      Navigator.pop(context);
    }
  }
}
