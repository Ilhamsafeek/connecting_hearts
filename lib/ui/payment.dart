import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/services/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zamzam/payment/main.dart';


class Payment extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();

  // final dynamic projectData;
  // Payment(this.projectData, {Key key}) : super(key: key);
}

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
        body: SingleChildScrollView(
          child: Container(
            child: Column(children: <Widget>[
              ListTile(
                leading: Icon(FontAwesomeIcons.ccVisa, color: Colors.indigo[900],),
                title: Text('****1112'),
              ),
              ListTile(
                title: Text(
                  'Add Debit or Credit card',
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StripePayment()),
                  );
                },
              ),
            ]),
          ),
        ));
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));

    setState(() {});

    return null;
  }
}
