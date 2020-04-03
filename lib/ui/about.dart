import 'package:flutter/material.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:zamzam/ui/camera.dart';
import 'package:camera/camera.dart';
import 'package:zamzam/ui/project_detail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();

  // final dynamic projectData;
  // Payment(this.projectData, {Key key}) : super(key: key);
}

class _AboutState extends State<About> {
  ApiListener mApiListener;
  dynamic totalContribution = 0;

  @override
  void initState() {
    super.initState();
    WebServices(mApiListener).getPaymentData().then((value) {
      print(value);
      setState(() {
        dynamic total = 0;
        for (var item in value) {
          total = total + double.parse(item['amount']);
        }
        totalContribution = total;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child:Image.asset('assets/logo.png', height: 80)
                    )
                  ],
                ),
              )
            ],
          ),
         
        ));
  }


}
