import 'package:flutter/material.dart';
import 'package:zamzam/payment/card_layout.dart';
import 'package:zamzam/services/services.dart';

class StripePayment extends StatefulWidget {
  StripePayment({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _StripePaymentState createState() => _StripePaymentState();
}

class _StripePaymentState extends State<StripePayment> {
  bool _cardValid;
    ApiListener mApiListener;

  CardController _cardController = CardController();

  bool _requestToken = false;
  String _token;

  Future<void> _validate() async {
    setState(() {
      _requestToken = true;
    });
   
   
  }

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add card"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            CardWidget(
              cardController: _cardController,
            ),
            Center(
              child: RaisedButton(
                color: Colors.black,
                child: Text('Save Card'),
                elevation: 7.0,
                textColor: Colors.white,
                onPressed: () {
                  print(WebServices(this.mApiListener).createStripeToken().toString());
                },
              ),
            ),
            Center(
              child: !(_cardValid ?? true)
                  ? Text("Card is not valid!")
                  : _requestToken
                      ? CircularProgressIndicator()
                      : Text(_token != null ? _token : ""),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _validate,
        tooltip: 'validate',
        child: Icon(Icons.credit_card),
      ),
    );
  }
}
