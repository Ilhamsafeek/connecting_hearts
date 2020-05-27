import 'package:flutter/material.dart';
import 'package:zamzam/Tabs.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:zamzam/services/services.dart';
import 'package:zamzam/services/webservices.dart';
import 'package:zamzam/ui/splashscreen.dart';
import 'package:zamzam/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zamzam/ui/onboarding_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  ApiListener mApiListener;

  await currentUser().then((value) {
    if (value != null) {
      CURRENT_USER = value.phoneNumber;
    }
  });
  await WebServices(mApiListener).getUserData().then((value) {
    if (value != null) {
      USER_ROLE = value['role'];
      currentUserData = value;
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: new ThemeData(primaryColor: Color.fromRGBO(104, 45, 127, 1)),
      initialRoute: initScreen == 0 || initScreen == null ? "onboard" : "/",
      routes: <String, WidgetBuilder>{
        "onboard": (BuildContext context) => OnBoardingPage(),
        SPLASH_SCREEN: (BuildContext context) => SplashScreen(),
        SIGN_IN: (BuildContext context) => Signin(),
        HOME_PAGE: (BuildContext context) => MyTabs(),
      },
    );
  }
}

Future<FirebaseUser> currentUser() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  return user;
}
