import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:zamzam/services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zamzam/ui/camera.dart';
import 'package:camera/camera.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();

  final String cardId;
  final dynamic projectData;
  final dynamic paymentAmount;
  final dynamic method;
  Checkout(this.cardId, this.projectData, this.paymentAmount, this.method,
      {Key key})
      : super(key: key);
}

class _CheckoutState extends State<Checkout> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;
  bool _processing = false;
  Widget _paid = Text('');
  Widget _title = Text('Checkout');
  Widget _result = Text('');
  @override
  Widget build(BuildContext context) {
    _paid = FlatButton.icon(
      onPressed: () {
        setState(() {
          // _processing = true;

          Navigator.pop(context);
          _showDialog();
          _result = doCharging();
           
        });
      },
      icon: Icon(Icons.check_circle_outline, color: Colors.white),
      label: Text(
        'Proceed donation',
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.teal,
    );

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            title: _title,
            leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: LoadingOverlay(
          child: Center(
            child: Container(
                child: Column(
              children: <Widget>[Text(widget.method), _paid],
            )),
          ),
          isLoading: _processing,
          color: Colors.white,
          progressIndicator: SpinKitThreeBounce(
            color: Colors.red[700],
            size: 30.0,
          ),
        ));
  }

  Widget doCharging() {
    return FutureBuilder<dynamic>(
        future: WebServices(this.mApiListener).createPayment(
            widget.paymentAmount, widget.projectData, widget.method, 'pending'),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            var data = snapshot.data;

            if (data == 200) {
              
              children = <Widget>[
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 120,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text("Thank you for your donation",textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 19.0)),
                ),
              
                Divider(
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                      'Your donated amount will be updated once you submit deposit slip',textAlign: TextAlign.center,),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                    title: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("May be later"),
                              textColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => {}),
                ListTile(
                    title: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: RaisedButton(
                            color: Colors.red,
                            onPressed: () async {
                             

                              WidgetsFlutterBinding.ensureInitialized();
                              final cameras = await availableCameras();
                              final firstCamera = cameras.first;

                              Navigator.of(context).push(
                                  CupertinoPageRoute<Null>(
                                      builder: (BuildContext context) {
                                return new TakePictureScreen(
                                  "${widget.projectData['payment_id']}",
                                  firstCamera,
                                );
                              }));
                            },
                            child: Text(
                              'Submit Deposit Slip',
                              style: TextStyle(color: Colors.white),
                            ),
                          ))
                        ],
                      ),
                    ),
                    onTap: () => {}),
              ];
            
            } else {
              children = <Widget>[
                Text('Could not make donation. Please try again')
              ];
            }
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child:
                    Text('something Went Wrong !'), //Error: ${snapshot.error}
              )
            ];
          } else {
            children = <Widget>[
               Padding(
                padding: EdgeInsets.only(top: 16),
                child: SizedBox(child:  CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor))),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Processing payment..'),
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

  Future _showDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: _result,
        );
      },
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
