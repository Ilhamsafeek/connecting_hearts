import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardWidget extends StatefulWidget {
  CardWidget({this.cardController});

  final CardController cardController;

  _CardWidget createState() {
    return _CardWidget();
  }
}

class _CardWidget extends State<CardWidget> {
  int _month;
  int _year;

  IconData _card = FontAwesomeIcons.creditCard;

  TextEditingController _cvvController = TextEditingController();

  _setNumber(String number) {
    widget.cardController.setNumber(number);
    setState(() {
      _card = _identifyCard(number);
    });
  }

  _identifyCard(String number) {
    if (number.startsWith("34") || number.startsWith("37")) {
      return FontAwesomeIcons.ccAmex;
    } else if (number.startsWith("30") ||
        number.startsWith("36") ||
        number.startsWith("38")) {
      return FontAwesomeIcons.ccDinersClub;
    } else if (number.startsWith("6")) {
      return FontAwesomeIcons.ccDiscover;
    } else if (number.startsWith("3528") || number.startsWith("3589")) {
      return FontAwesomeIcons.ccJcb;
    } else if (number.startsWith("51") ||
        number.startsWith("52") ||
        number.startsWith("53") ||
        number.startsWith("54") ||
        number.startsWith("55")) {
      return FontAwesomeIcons.ccMastercard;
    } else if (number.startsWith("5") || number.startsWith("6")) {
      return FontAwesomeIcons.ccMastercard;
    } else if (number.startsWith("4")) {
      return FontAwesomeIcons.ccVisa;
    } else {
      return FontAwesomeIcons.solidCreditCard;
    }
  }

  _setCVV(String cvv) {
    widget.cardController.setCVV(cvv);
  }

  _setMonth(int month) {
    widget.cardController.setMonth(month);
  }

  _setYear(int year) {
    widget.cardController.setYear(year);
  }

  @override
  void initState() {
    super.initState();
  }

  var _cardController = new MaskedTextController(mask: '0000 0000 0000 0000');
  var _cardDateController = new MaskedTextController(mask: '00 / 00');

  var labelStyle = TextStyle(color: Colors.black54, fontSize: 18);
  var textStyle =
      TextStyle(color: Colors.black, fontSize: 18,);
  var enabledBorder =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.black45));
  var focusedBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 1.5));

  @override
  Widget build(BuildContext context) {
    var months = <KeyValue>[
      KeyValue("01", 1),
      KeyValue("02", 2),
      KeyValue("03", 3),
      KeyValue("04", 4),
      KeyValue("05", 5),
      KeyValue("06", 6),
      KeyValue("07", 7),
      KeyValue("08", 8),
      KeyValue("09", 9),
      KeyValue("10", 10),
      KeyValue("11", 11),
      KeyValue("12", 12),
    ];
    var currentYear = DateTime.now().year;
    var years = <int>[];
    for (int yy = currentYear; yy <= currentYear + 20; yy++) {
      years.add(yy);
    }

    return Theme(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.grey[100]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _cardController,
                onChanged: (val) {
                  _setNumber(val);
                },
                keyboardType: TextInputType.phone,
                style: textStyle,
                inputFormatters: [LengthLimitingTextInputFormatter(19)],
                decoration: InputDecoration(
                    labelText: "Card Number",
                    suffixIcon: Icon(
                      _card,
                      color: Colors.black45,
                    ),
                    labelStyle: labelStyle,
                    enabledBorder: enabledBorder,
                    focusedBorder: focusedBorder),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Valid\nThru".toUpperCase(),
                    style: TextStyle(fontSize: 11, color: Colors.black45),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      onChanged: (val) {
                        _setMonth(int.parse(val.split(" / ")[0]));
                        _setYear(int.parse(val.split(" / ")[1]));
                      },
                      style: textStyle,
                      controller: _cardDateController,
                      inputFormatters: [LengthLimitingTextInputFormatter(7)],
                       keyboardType: TextInputType.numberWithOptions(
                          signed: false, decimal: false),
                      decoration: InputDecoration(
                          labelText: "MM/YY",
                          labelStyle: labelStyle,
                          enabledBorder: enabledBorder,
                          focusedBorder: focusedBorder),
                    ),
                  )),
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      onChanged: (val) {
                        _setCVV(val);
                      },
                      style: textStyle,
                      controller: _cvvController,
                      inputFormatters: [LengthLimitingTextInputFormatter(3)],
                      obscureText: true,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: false, decimal: false),
                      decoration: InputDecoration(
                          labelText: "CVC",
                          suffixIcon: Icon(
                            FontAwesomeIcons.creditCard,
                            color: Colors.black45,
                          ),
                          labelStyle: labelStyle,
                          enabledBorder: enabledBorder,
                          focusedBorder: focusedBorder),
                    ),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
      data: ThemeData(brightness: Brightness.dark),
    );
  }
}

class KeyValue {
  final String key;
  final int value;

  KeyValue(this.key, this.value);
}

class CardController {
  String cardNumber;
  int expiryMonth;
  int expiryYear;
  String cvv;

  setNumber(String val) {
    this.cardNumber = val;
  }

  setCVV(String val) {
    this.cvv = val;
  }

  setMonth(int val) {
    this.expiryMonth = val;
  }

  setYear(int val) {
    this.expiryYear = val;
  }

  CardController(
      {this.cardNumber, this.expiryMonth, this.expiryYear, this.cvv});
}
