import 'package:flutter/material.dart';

import 'package:zamzam/services/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zamzam/payment/main.dart';
import 'package:braintree_payment/braintree_payment.dart';

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
          ListTile(
            title: Text(
              'Add Paypal',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () async {
              String clientNonce =
                  "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiJlNTc1Mjc3MzZiODkyZGZhYWFjOTIxZTlmYmYzNDNkMzc2ODU5NTIxYTFlZmY2MDhhODBlN2Q5OTE5NWI3YTJjfGNyZWF0ZWRfYXQ9MjAxOS0wNS0yMFQwNzoxNDoxNi4zMTg0ODg2MDArMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJncmFwaFFMIjp7InVybCI6Imh0dHBzOi8vcGF5bWVudHMuc2FuZGJveC5icmFpbnRyZWUtYXBpLmNvbS9ncmFwaHFsIiwiZGF0ZSI6IjIwMTgtMDUtMDgifSwiY2hhbGxlbmdlcyI6W10sImVudmlyb25tZW50Ijoic2FuZGJveCIsImNsaWVudEFwaVVybCI6Imh0dHBzOi8vYXBpLnNhbmRib3guYnJhaW50cmVlZ2F0ZXdheS5jb206NDQzL21lcmNoYW50cy8zNDhwazljZ2YzYmd5dzJiL2NsaWVudF9hcGkiLCJhc3NldHNVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbSIsImF1dGhVcmwiOiJodHRwczovL2F1dGgudmVubW8uc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbSIsImFuYWx5dGljcyI6eyJ1cmwiOiJodHRwczovL29yaWdpbi1hbmFseXRpY3Mtc2FuZC5zYW5kYm94LmJyYWludHJlZS1hcGkuY29tLzM0OHBrOWNnZjNiZ3l3MmIifSwidGhyZWVEU2VjdXJlRW5hYmxlZCI6dHJ1ZSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjp0cnVlLCJtZXJjaGFudEFjY291bnRJZCI6ImFjbWV3aWRnZXRzbHRkc2FuZGJveCIsImN1cnJlbmN5SXNvQ29kZSI6IlVTRCJ9LCJtZXJjaGFudElkIjoiMzQ4cGs5Y2dmM2JneXcyYiIsInZlbm1vIjoib2ZmIn0=";

              BraintreePayment braintreePayment = new BraintreePayment();
              var data = await braintreePayment.showDropIn(
                  nonce: clientNonce, amount: "2.0", enableGooglePay: true);
              print("Response of the payment $data");
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
        }else{
           children = <Widget>[];
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
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text("Succesfully deleted."),
                                    ));

                                    setState(() {
                                      isDeletePresed = false;
                                    });
                                  } else {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
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
}
