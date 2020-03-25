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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'Make your donations easy by adding payment method now',
            style: TextStyle(color: Colors.black45, fontSize: 14),
            textAlign: TextAlign.center,
          )),
          Divider(
            height: 0,
          ),
          _getAllCards(),
          // ListTile(
          //   leading: Icon(
          //     FontAwesomeIcons.ccVisa,
          //     color: Colors.indigo[900],
          //   ),
          //   title: Text('****1112'),
          // ),
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
    return 
    
    FutureBuilder<dynamic>(
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
                onTap: () {},
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

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));

    setState(() {});

    return null;
  }
}
