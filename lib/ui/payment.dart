import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:zamzam/services/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zamzam/payment/main.dart';
import 'package:zamzam/Tabs.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();

  // final dynamic projectData;
  // Payment(this.projectData, {Key key}) : super(key: key);
}

var cardResult;

class _PaymentPageState extends State<Payment> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;
final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text('Payment')),
      body: Container(
        child: Column(children: <Widget>[
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
            'Make your donations simply by adding payment method now',
            style: TextStyle(color: Colors.black45, fontSize: 14),
            textAlign: TextAlign.center,
          )),
          Divider(
            height: 0,
          ),
          _getAllCards(),
         
          ListTile(
            title: Text(
              'Add Debit or Credit card',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StripePayment()),
              );
            },
          ),
        ]),
      ),
    );
  }

  Widget _getAllCards() {
 
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
              ListTile(
                leading: Icon(
                  FontAwesomeIcons.ccVisa,
                  color: Colors.indigo[700],
                ),
                title: Text("****${item['last4']}"),
                onTap: () {
                  cardModalBottomSheet(context, item);
                },
              )
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

  bool isDeletePresed = false;

  Future<bool> cardModalBottomSheet(context, data) {
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
                        enabled: true,
                        title: Text('Card Details'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              isDeletePresed = true;
                            });
                          },
                        ),
                      )),
                  Divider(
                    height: 0,
                  ),
                  ListTile(
                    leading: Text(
                      'Card number',
                      style: TextStyle(color: Colors.black45),
                    ),
                    title: Text("**** **** **** ${data['last4']}"),
                  ),
                  ListTile(
                    leading: Text(
                      'Expiry date',
                      style: TextStyle(color: Colors.black45),
                    ),
                    title: Text("${data['exp_month']}/${data['exp_year']}"),
                  ),
                  Divider(
                    height: 0,
                  ),
                  if (isDeletePresed)
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(children: <Widget>[
                        ListTile(
                            title: Text(
                                'Do you really want to delete the payment method?')),
                        Padding(padding: EdgeInsets.all(15)),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                child: Text('No'),
                                onPressed: () {
                                  setState(() {
                                    isDeletePresed = false;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                                child: RaisedButton(
                              onPressed: () async {
                                 Navigator.of(context).pop();
                                 _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text("Deleting.."),
                                    ));
                                await WebServices(this.mApiListener)
                                    .deleteCard(data['id'])
                                    .then((value) {
                                  if (value == true) {
                                   _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text("Succesfully deleted."),
                                    ));
                                   
                                    setState(() {
                                      isDeletePresed = false;
                                    });
                                  }else{
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text("Something went wrong!"),
                                    ));
                                  }
                                });
                              },
                              child: Text("Yes"),
                              color: Colors.black,
                              textColor: Colors.white,
                            )),
                          ],
                        )
                      ]),
                    )
                ],
              ),
            );
          });
        });
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));

    setState(() {});

    return null;
  }
}
