import 'package:flutter/material.dart';
import 'package:zamzam/Tabs.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:zamzam/ui/payment.dart';
import 'package:zamzam/ui/paytm.dart';
import 'package:zamzam/ui/project.dart';
import 'package:zamzam/ui/splashscreen.dart';
import 'package:zamzam/signin.dart';

void main() => runApp(new MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: new ThemeData(primaryColor: Color.fromRGBO(104, 45, 127, 1),
      ),
      routes: <String, WidgetBuilder>{
        SPLASH_SCREEN: (BuildContext context) => SplashScreen(),
        PAY_TM: (BuildContext context) =>Paytm(),
        SIGN_IN: (BuildContext context) =>Signin(),
        HOME_PAGE: (BuildContext context) =>MyTabs(),
        
      },
    );
  }
}
