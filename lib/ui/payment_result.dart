import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/services/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zamzam/payment/main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PaymentResult extends StatefulWidget {
  @override
  _PaymentResultState createState() => _PaymentResultState();

  final String cardId;
  PaymentResult(this.cardId, {Key key}) : super(key: key);
}

class _PaymentResultState extends State<PaymentResult> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        // appBar: AppBar(title: Text('Payment')),
        body: Center(
          child: Container(child: doCharging(widget.cardId)),
        ));
  }

  // Widget doPaymentInitiation() {
  //   return FutureBuilder<dynamic>(
  //     //function should be changed
  //     future: WebServices(this.mApiListener).createCustomer(),
  //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  //       List<Widget> children;

  //       if (snapshot.hasData) {
  //         var data = snapshot.data;

  //         children = <Widget>[doCharging(data['id'])];
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
  //           const Padding(
  //             padding: EdgeInsets.only(top: 16),
  //             child: SizedBox(child: CircularProgressIndicator()),
  //           ),
  //           const Padding(
  //             padding: EdgeInsets.only(top: 16),
  //             child: Text('Please wait until we process payment..'),
  //           )
  //         ];
  //       }
  //       return Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: children,
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget doCharging(String card) {
    return FutureBuilder<dynamic>(
      future: WebServices(this.mApiListener).chargeByCustomerAndCardID(card),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          var data = snapshot.data;
        
          children = <Widget>[
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 120,
            ),
            Text(data['status']),
            Icon(
              Icons.receipt,
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
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Please wait until we process payment..'),
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
}
