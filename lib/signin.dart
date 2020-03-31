import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter_verification_code_input/flutter_verification_code_input.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:zamzam/services/webservices.dart';
import 'package:zamzam/services/apilistener.dart';
import 'package:country_pickers/country_pickers.dart';

class Signin extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<Signin> {
  final TextEditingController amountController = TextEditingController();

  ApiListener mApiListener;
  String phoneNo;
  String countryCode = '+94';
  String smsCode;
  String verificationId;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrive = (String verId) {
      this.verificationId = verId;
      smsCodeDialog(context);
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('signed in');
        CURRENT_USER= "${this.countryCode}${this.phoneNo}";
      });
    };
    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential credential) {
      print('verified');
      CURRENT_USER= "${this.countryCode}${this.phoneNo}";
      FirebaseAuth.instance.signInWithCredential(credential).then((user) {
        Navigator.of(context).pushReplacementNamed(HOME_PAGE);
      }).catchError((e) {
        print(e);
      });
    };
    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('From here: ${exception.message}');
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${exception.message}"),
      ));
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "${this.countryCode}${this.phoneNo}",
      codeAutoRetrievalTimeout: autoRetrive,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: veriFailed,
    );
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext contect) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Mobile verification",
                  style: TextStyle(fontFamily: "Exo2", color: Colors.white)),
              
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text("Enter the 6 digit code sent to ${this.phoneNo}",
                        style: TextStyle(
                            fontFamily: "Exo2",
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.bold)),
                    new VerificationCodeInput(
                      keyboardType: TextInputType.number,
                      length: 6,
                      onCompleted: (String value) {
                        this.smsCode = value;
                      },
                    ),
                    Spacer(),
                    Container(
                      child: Ink(
                        decoration: ShapeDecoration(
                          color: Colors.black,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          color: Colors.white,
                          onPressed: () {
                            FirebaseAuth.instance.currentUser().then((user) {
                              if (user != null) {
                                Navigator.of(context)
                                    .pushReplacementNamed(HOME_PAGE);
                              } else {
                                Navigator.of(context).pop();
                                signIn();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  signIn() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await FirebaseAuth.instance.signOut().then((action) {
      FirebaseAuth.instance.signInWithCredential(credential).then((user) {
        WebServices(this.mApiListener)
            .createAccount('${this.countryCode}${this.phoneNo}');
        Navigator.of(context).pushReplacementNamed(HOME_PAGE);
      }).catchError((e) {
        print(e);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Mobile verification",
              style: TextStyle(fontFamily: "Exo2", color: Colors.white)),
          
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text('Please enter your mobile number',
                      style: TextStyle(fontSize: 18, fontFamily: "Exo2")),
                  SizedBox(height: 15.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: CountryPickerDropdown(
                          initialValue: 'lk',
                          itemBuilder: _buildDropdownItem,
                          onValuePicked: (Country country) {
                            print("${country.phoneCode}");
                            this.countryCode = "+${country.phoneCode}";
                          },
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            focusColor: Colors.black,
                            hintText: "777140803",
                          ),
                          style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                          onChanged: (value) {
                            print(value);
                            this.phoneNo = value;
                          },
                        ),
                      ),
                    ],
                  ),
                 
                  SizedBox(height: 15.0),
                  RaisedButton(
                    onPressed: verifyPhone,
                    child: Text('verify'),
                    textColor: Colors.white,
                    elevation: 7.0,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 3.0,
            ),
            Text("+${country.phoneCode}",
                style: TextStyle(fontSize: 18, fontFamily: "Exo2")),
          ],
        ),
      );
}
