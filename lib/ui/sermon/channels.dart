import 'package:flutter/material.dart';
import 'package:zamzam/model/Gridmodel.dart';
import 'package:zamzam/services/services.dart';
import 'package:zamzam/ui/project.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Channels extends StatefulWidget {
  Channels({Key key}) : super(key: key);

  _ChannelsState createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels> {
  ApiListener mApiListener;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Channels'),
      ),
      body: _bodyItem(),
      // backgroundColor: Colors.grey[200],
    );
  }

  Widget _bodyItem() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FutureBuilder<dynamic>(
              future: WebServices(this.mApiListener).getCategoryData(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                List<Widget> children;

                if (snapshot.hasData) {
                  children = <Widget>[
                    for (var item in snapshot.data)
                      Column(children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                           backgroundImage:new AssetImage('assets/mufti_menk.jpg'),
                           radius: 30,
                          ),
                          title: Text(item['category']),
                          subtitle: Text('this is subtitle'),
                          trailing: Icon(Icons.more_horiz, color: Colors.grey,),
                          onTap: () {},
                        ),
                        Divider()
                      ])
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
                      child: Text(
                          'something Went Wrong !'), //Error: ${snapshot.error}
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
                ));
              }),
        ],
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  GridModel gridModel;

  GridItem(this.gridModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1 / 2),
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                gridModel.imagePath,
                width: 30,
                height: 30,
                color: gridModel.color,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  gridModel.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridItemTop extends StatelessWidget {
  GridModel gridModel;

  GridItemTop(this.gridModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1 / 2),
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                gridModel.imagePath,
                width: 30,
                height: 30,
                color: gridModel.color,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  gridModel.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
