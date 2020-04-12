import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter_verification_code_input/flutter_verification_code_input.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:zamzam/services/webservices.dart';
import 'package:zamzam/services/apilistener.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  final _formKey = GlobalKey<FormState>();
  Widget _signoutProgress;

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrive = (String verId) {
      this.verificationId = verId;
      smsCodeDialog(context);
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('signed in');
        CURRENT_USER = "${this.countryCode}${this.phoneNo}";
      });
    };
    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential credential) {
      print('verified');
      CURRENT_USER = "${this.countryCode}${this.phoneNo}";
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
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Details()),
                                  );
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
              ));
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
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text("Signin",
      //       style: TextStyle(fontFamily: "Exo2", color: Colors.white)),
      // ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/test.gif"),
              fit: BoxFit.cover,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    radius: 35,
                    child: Image.asset(
                      "assets/ch_logo.png",
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'You Make a difference, We Make it Easy',
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0),
                        )),
                    child: Column(children: <Widget>[
                      
                      Text('Please enter your mobile number',
                          style: TextStyle(fontSize: 18, fontFamily: "Exo2")),
                          SizedBox(height: 2.0, child: _signoutProgress),
                      SizedBox(height: 15.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: CountryPickerDropdown(
                              initialValue: 'LK',
                              itemBuilder: _buildDropdownItem,
                              itemFilter: (Country country) {
                                return ['AR', 'DE', 'GB', 'CN', 'LK']
                                    .contains(country.isoCode);
                              },
                              onValuePicked: (Country country) {
                                print("${country.phoneCode}");
                                this.countryCode = "+${country.phoneCode}";
                              },
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter phone number.';
                                }
                              },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                focusColor: Colors.black,
                                hintText: "777140803",
                              ),
                              style:
                                  TextStyle(fontSize: 18, fontFamily: "Exo2"),
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
                        onPressed: () {
                          setState(() {
                            _signoutProgress = LinearProgressIndicator(
                              backgroundColor: Colors.grey,
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.black),
                            );
                          });
                          if (_formKey.currentState.validate()) {
                            verifyPhone();
                          } else {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Please check the input"),
                            ));
                            setState(() {
                              _signoutProgress = null;
                            });
                          }
                        },
                        child: Text('Signin my Account'),
                        textColor: Colors.white,
                        color: Colors.green[800],
                      )
                    ]))
              ],
            ),
          )),
    );
  }

  Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 3.0,
            ),
            Text("+${country.phoneCode}(${country.isoCode})"),
          ],
        ),
      );
}

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();

}

class _DetailsState extends State<Details> {
  ApiListener mApiListener;
  dynamic totalContribution = 0;
  final _emailController = TextEditingController(text: "");
  final _firstNameController = TextEditingController(text: "");
  final _lastNameController = TextEditingController(text: "");

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
              child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        Column(
                          children: <Widget>[
                            SpinKitThreeBounce(
                                  color: Colors.grey,
                                  size: 50.0,
                                ),
                             SizedBox(height: 20.0),
                            Text('One more step to go',
                                style: TextStyle(
                                    fontSize: 18, fontFamily: "Exo2")),
                            SizedBox(height: 20.0),
                            Row(children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _firstNameController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'please enter first name.';
                                    }
                                    if (value.length < 5) {
                                      return 'choose a firast name with atleast 5 chars.';
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    // border: OutlineInputBorder(),
                                    labelText: 'First Name',
                                    hintText: '',
                                  ),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _lastNameController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'please enter last name.';
                                    }
                                    if (value.length < 5) {
                                      return 'choose a last name with atleast 5 chars.';
                                    }
                                  },
                                  // controller: _usernameController,
                                  decoration: InputDecoration(
                                    // border: OutlineInputBorder(),
                                    labelText: 'Last Name',
                                    hintText: '',
                                  ),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ]),
                            TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter email.';
                                }
                                if (value.length < 5) {
                                  return 'enter a valid email address';
                                }
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return 'email format is not valid';
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                // border: OutlineInputBorder(),
                                labelText: 'Email',
                                hintText: '',
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 15.0),
                            RaisedButton(
                              onPressed: () {
                                _formKey.currentState.validate()
                                    ? WebServices(this.mApiListener)
                                        .updateUser(
                                        "",
                                        _emailController.text,
                                        _firstNameController.text,
                                        _lastNameController.text,
                                      )
                                        .then((value) {
                                        if (value == 200) {
                                          Navigator.pop(context);
                                          Navigator.of(context)
                                              .pushReplacementNamed(HOME_PAGE);
                                        } else {
                                          _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Something went wrong. Please try again."),
                                          ));
                                        }
                                      })
                                    : _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                        content:
                                            Text("Please check the inputs"),
                                      ));
                              },
                              child: Text('Submit'),
                              textColor: Colors.white,
                              elevation: 7.0,
                              color: Colors.black,
                            )
                         
                          ],
                        )
                      ])))),
        ));
  }
}
