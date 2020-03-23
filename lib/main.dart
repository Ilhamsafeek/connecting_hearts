import 'package:flutter/material.dart';
import 'package:zamzam/Tabs.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:zamzam/ui/payment.dart';
import 'package:zamzam/ui/paytm.dart';
import 'package:zamzam/ui/project.dart';
import 'package:zamzam/ui/splashscreen.dart';
import 'package:zamzam/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zamzam/ui/onboarding_page.dart';
int initScreen;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen $initScreen');
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: new ThemeData(primaryColor: Color.fromRGBO(104, 45, 127, 1),
      ),
      initialRoute: initScreen == 0 || initScreen == null ? "onboard" : "/",
      routes: <String, WidgetBuilder>{
        "onboard": (BuildContext context) => OnBoardingPage(),
        SPLASH_SCREEN: (BuildContext context) => SplashScreen(),
        PAY_TM: (BuildContext context) =>Paytm(),
        SIGN_IN: (BuildContext context) =>Signin(),
        HOME_PAGE: (BuildContext context) =>MyTabs(),
        
      },
    );
  }
}
