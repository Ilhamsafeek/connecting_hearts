import 'package:flutter/material.dart';
import 'package:zamzam/services/services.dart';

class MyContribution extends StatefulWidget {
  @override
  _MyContributionState createState() => _MyContributionState();

  // final dynamic projectData;
  // Payment(this.projectData, {Key key}) : super(key: key);
}

class _MyContributionState extends State<MyContribution> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text('My Contribution')),
       body: Container(
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ListTile(
              title: Image.asset(
                "assets/add_payment_method.png",
                width: 120,
                height: 120,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.receipt , color: Colors.grey,),
            title: Text("Your donation worth Rs. 2600"),
          )
        ]
        )
    ));
  }

}
