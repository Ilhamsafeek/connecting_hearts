import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_media/webview_flutter.dart';


class Webview extends StatefulWidget {
  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  File imageFile;

  @override
  void initState() {
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: const WebView(
        initialUrl: 'https://chadmin.online/dashboard/index/mobile',
        javascriptMode: JavascriptMode.unrestricted,
       
      ),
    
    ); 
    
  }
}
