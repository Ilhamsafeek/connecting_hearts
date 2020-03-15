import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/services/services.dart';

class Project extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<Project> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Projects",
              style: TextStyle(fontFamily: "Exo2", color: Colors.white)),
          backgroundColor: Color.fromRGBO(104, 45, 127, 1),
        ),
        body:new RefreshIndicator(
        
        child: SingleChildScrollView(
        
         child:Container(
        
        
          child: buildData()
          
        
        )
    ),
    onRefresh: _handleRefresh,

        ));
  
  }

  Widget buildData(){
     return FutureBuilder<dynamic>(
            future: WebServices(this.mApiListener)
                .getData(), // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;

              if (snapshot.hasData) {
                children = <Widget>[
                 
                  for (var item in snapshot.data)
                    
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.album),
                            title: Text('${item['category']}: ${item['district']}'),
                            subtitle: Text('Family of ${item['children']} Members'),
                          ),
                          ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: const Text('view details'),
                                onPressed: () {/* ... */},
                              ),
                              FlatButton(
                                child: Text('${item['amount']}'),
                                onPressed: () {/* ... */},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                
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
                    child: Text('Error: ${snapshot.error}'),
                  )
                ];
              } else {
                children = <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator( valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
                    width: 60,
                    height: 60,
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

 Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));

    setState(() {
    
    });

    return null;
  }

}
