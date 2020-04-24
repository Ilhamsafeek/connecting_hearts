import 'package:flutter/material.dart';


class SuccessPage extends StatefulWidget {
  @override
  _SuccessPageState createState() => _SuccessPageState();

  final dynamic paymentData;
  SuccessPage(this.paymentData, {Key key}) : super(key: key);
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: Text('')),
        body: Center(
          child: Container(
            child: Column(children: <Widget>[
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
              // Padding(
              //   padding: const EdgeInsets.all(16),
              //   child: Text('Receipt for your donation'),
              // ),
              Divider(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                    'Your Donation for ${widget.paymentData['project_id']} is approved. Now you can monitor the project updates.'),
              ),
              Divider(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlineButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Done"),
                        textColor: Colors.black,
                        
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ));
  }
}
