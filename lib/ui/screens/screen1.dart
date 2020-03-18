import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zamzam/model/Gridmodel.dart';
import 'package:zamzam/model/ImageSliderModel.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:zamzam/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:zamzam/ui/project.dart';
import 'package:zamzam/videoInfo.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final flutubePlayer = null;
  ApiListener mApiListener;

 
 @override
  void initState() {
    
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
   
   return VideoFeed();
  }
}

