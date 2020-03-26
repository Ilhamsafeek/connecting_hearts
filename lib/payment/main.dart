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
  bool _isCardSaved =false;
  bool _cardMessageReceived = false;
  ApiListener mApiListener;

  CardController _cardController = CardController();

  bool _requestToken = false;

  Future<void> _validate() async {
    setState(() {
      _requestToken = true;
    });

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
      
    } else {
      setState(() {
        _requestToken = false;
      });
    }
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
                  // if (_cardMessageReceived) {
                  //   _validate().then((value) {
                  //     Text(_cardMessage);
                  //   });
                  // } else {
                  //   CircularProgressIndicator();
                  // }
                _validate();
               
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          
        },
        tooltip: 'validate',
        child: Icon(Icons.credit_card),
      ),
    );
  }

  
}
