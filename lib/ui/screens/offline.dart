import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Offline extends StatefulWidget {
  Offline({Key key}) : super(key: key);

  _OfflineState createState() => _OfflineState();
}

class _OfflineState extends State<Offline> {
 
  @override
  void initState() {
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 

       Center(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.vpn_lock, size: 100, color: Colors.teal,),
              Text('You are offline !', style: TextStyle(color: Colors.grey, fontSize: 30)),
              Text('Please connect to internet and try again.', style: TextStyle(color: Colors.grey))
              
            ],
          ),
        ),
      
    );
  }
}
