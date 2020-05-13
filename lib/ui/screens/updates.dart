import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:zamzam/model/Gridmodel.dart';
import 'package:zamzam/model/ImageSliderModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/services/services.dart';
import 'package:zamzam/ui/project.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class Updates extends StatefulWidget {
  Updates({Key key}) : super(key: key);

  _UpdatesState createState() => _UpdatesState();
}

Future<dynamic> _zamzamUpdates;

class _UpdatesState extends State<Updates> {
  ApiListener mApiListener;

  @override
  void initState() {
    super.initState();
    _zamzamUpdates = WebServices(this.mApiListener).getZamzamUpdateData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Zamzam Updates')),
      body: new RefreshIndicator(
        child: SingleChildScrollView(child: Container(child: buildData())),
        onRefresh: _handleRefresh,
      ),
    );
  }

  Widget buildData() {
    return FutureBuilder<dynamic>(
      future: _zamzamUpdates,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          var data = snapshot.data;

          children = <Widget>[
            for (var item in data) updatesCard(item),
          ];
        } else if (snapshot.hasError) {
          children = <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('something Went Wrong !'), //Error: ${snapshot.error}
            )
          ];
        } else {
          children = <Widget>[
            SizedBox(
              child: SpinKitPulse(
                color: Colors.grey,
                size: 120.0,
              ),
              width: 50,
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(''),
            )
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }

  Card updatesCard(dynamic data) {
    return Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Stack(children: <Widget>[
        ClipRRect(
          // borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
          child: CachedNetworkImage(
            imageUrl: data['image_url'],
            placeholder: (context, url) =>
                Image.asset('assets/placeholder.png'),
          ),
        ),
      ])
    ]));
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));

    setState(() {});

    return null;
  }
}
