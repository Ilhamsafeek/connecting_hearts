import 'package:flutter/material.dart';
// import 'package:youtube_clone/videoInfo.dart';

class Subscriptioins extends StatefulWidget {
  Subscriptioins({Key key}) : super(key: key);

  _SubscriptioinsState createState() => _SubscriptioinsState();
}

class _SubscriptioinsState extends State<Subscriptioins> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: 
        Column(
          children: <Widget>[
         ExpansionTile(
        title: Text("Post New vacancy"),
        subtitle: Text('or Request for Job'),
      leading: Icon(Icons.view_carousel),
      children: <Widget>[
        Text('This is pizza'),
        Image.network('https://cdn4.vectorstock.com/i/1000x1000/15/48/pizza-slice-vector-3601548.jpg')
      ],
      initiallyExpanded: false,
      ),
         
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),

         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),

         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),

         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),
         Text('test'),

          ],
        )
        
       
      )
      
      
    );
  }
}
