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
  dynamic _cardValid;
  dynamic _isCardSaved;
  ApiListener mApiListener;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  CardController _cardController = CardController();

  Future<void> _validate() async {
    dynamic valid = await WebServices(this.mApiListener).isCardValid(
        _cardController.cardNumber,
        _cardController.expiryMonth,
        _cardController.expiryYear,
        _cardController.cvv);
    setState(() {
      _cardValid = valid;
    });
    if (_cardValid == true) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Adding your card.."),
      ));
      _saveCard();
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(_cardValid),
      ));
    }
    return _cardValid;
  }

  Future<dynamic> _saveCard() async {
    await WebServices(this.mApiListener)
        .saveCard(_cardController.cardNumber, _cardController.expiryMonth,
            _cardController.expiryYear, _cardController.cvv)
        .then((saved) {
          print("Saved Status $saved");
      setState(() {
        _isCardSaved = saved;
      });

      if (_isCardSaved == true) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Your Card added succesfully."),
        ));
        Navigator.of(context).pop();
      } else if (_isCardSaved == false) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Oops! Something went wrong. please try again"),
        ));
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("This card is added already."),
        ));
      }
    });

    return _isCardSaved;
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
                  onPressed: _validate),
            ),
          ],
        ),
      ),
    );
  }
}
