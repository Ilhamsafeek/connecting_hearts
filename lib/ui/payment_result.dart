import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:zamzam/services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zamzam/ui/camera.dart';
import 'package:camera/camera.dart';

class PaymentResult extends StatefulWidget {
  @override
  _PaymentResultState createState() => _PaymentResultState();

  final String cardId;
  final dynamic projectData;
  final dynamic paymentAmount;
  final dynamic method;
  PaymentResult(this.cardId, this.projectData, this.paymentAmount, this.method,
      {Key key})
      : super(key: key);
}

class _PaymentResultState extends State<PaymentResult> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;
  bool _processing = false;
  Widget _paid = Text('');
  Widget _title = Text('Checkout');
  @override
  Widget build(BuildContext context) {
    _paid = FlatButton.icon(
      onPressed: () {
        setState(() {
          _processing = true;
          _paid = doCharging(widget.cardId);
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

  Widget doCharging(String card) {
    if (widget.method == 'card') {
      return FutureBuilder<dynamic>(
        future: WebServices(this.mApiListener).chargeByCustomerAndCardID(
            card, widget.paymentAmount, widget.projectData['appeal_id']),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            var data = snapshot.data;
            WebServices(this.mApiListener)
                .createPayment(widget.paymentAmount, widget.projectData,
                    widget.method, 'approved')
                .then((value) {
              print(value);
              if (value != null) {}
            });
            children = <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 120,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(data['status'], style: TextStyle(fontSize: 19.0)),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Receipt for your donation'),
              ),
              Divider(
                height: 0,
              ),
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text("${data['created']}",
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold)),
                  )),
              Divider(
                height: 0,
              ),
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListTile(
                    title: FlatButton.icon(
                      icon: Icon(
                        Icons.receipt,
                      ),
                      onPressed: () {
                        _launchURL(data['receipt_url']);
                      },
                      label: Text(
                        'view stripe receipt',
                        style: TextStyle(fontSize: 15.0, color: Colors.blue),
                      ),
                    ),
                  )),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Done"),
                color: Colors.orange[400],
                textColor: Colors.white,
              ),
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
                child:
                    Text('something Went Wrong !'), //Error: ${snapshot.error}
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
    } else {
      return FutureBuilder<dynamic>(
        future: WebServices(this.mApiListener).createPayment(
            widget.paymentAmount, widget.projectData, widget.method, 'pending'),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            var data = snapshot.data;

            if (data == 200) {
              print(data.runtimeType);
              children = <Widget>[
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 120,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text("Thank you for your donation",
                      style: TextStyle(fontSize: 19.0)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Receipt for your donation'),
                ),
                Divider(
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                      'Your donated amount will be updated once you submit deposit slip'),
                ),
                Divider(
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
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
                      Expanded(
                          child: RaisedButton(
                        color: Colors.red,
                        onPressed: () async {
                          WidgetsFlutterBinding.ensureInitialized();
                          final cameras = await availableCameras();
                          final firstCamera = cameras.first;

                          Navigator.of(context).push(CupertinoPageRoute<Null>(
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
                )
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

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
