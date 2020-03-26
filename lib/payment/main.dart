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
  bool _isCardSaved = false;
  bool _cardMessageReceived = false;
  ApiListener mApiListener;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  CardController _cardController = CardController();

  Future<bool> _validate() async {
    bool valid = await WebServices(this.mApiListener).isCardValid();
    setState(() {
      _cardValid = valid;
    });

    if (valid) {
      _isCardSaved = await WebServices(this.mApiListener).saveCard(
          _cardController.cardNumber,
          _cardController.expiryMonth,
          _cardController.expiryYear,
          _cardController.cvv);
      return _isCardSaved;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  _validate().then((value) {
                    if (value != null) {
                      if (value) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Card added succesfully."),
                        ));
                        Navigator.of(context).pop();
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content:
                              Text("Something went wrong. please try again"),
                        ));
                      }
                    } else {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("Adding card.."),
                      ));
                    }
                  });

                  Center(
                    child: (_isCardSaved ?? true)
                        ? CircularProgressIndicator()
                        : Text('Card Saved Successfully !'),
                  );
                },
              ),
            ),

            // Center(
            //   child: !(_cardValid ?? true)
            //       ? Text("Card is not valid!")
            //       : _requestToken
            //           ? CircularProgressIndicator()
            //           : Text(_token != null ? _token : ""),
            // )
          ],
        ),
      ),
    );
  }
}
