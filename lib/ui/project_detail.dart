import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zamzam/ui/payment.dart';

class ProjectDetail extends StatefulWidget {
  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();

  final dynamic projectData;
  ProjectDetail(this.projectData, {Key key}) : super(key: key);
}

class _ProjectDetailPageState extends State<ProjectDetail> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('${widget.projectData['category']}'),
              background: Image.asset(
                "assets/child.png",
                fit: BoxFit.cover,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Share this appeal',
                onPressed: () {/* ... */},
              ),
            ],
          ),
        
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                
                alignment: Alignment.center,              
                child: _detailSection(),
              );
            },
            childCount: 1,
          ),
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.teal[100 * (index % 9)],
                child: Text('grid item $index'),
              );
            },
            childCount: 30,
          ),
      
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 2.0,
          ),
        ),
       
          // SliverFillRemaining(
          //   child: new Center(
          //     child: Column(children: <Widget>[
                
          //       _detailSection(),
          //       Container(
          //         color: Colors.black,
          //         width: double.infinity,
          //         height: 0.1,
          //       ),
          //       _buildBottomBar(),
          //     ]),
          //   ),
          //   hasScrollBody: true,
          // )
       
       
        ]));
  }

  Widget _detailSection() {
    FlutterMoneyFormatter formattedAmount = FlutterMoneyFormatter(
        amount: double.parse('${widget.projectData['amount']}'));
    FlutterMoneyFormatter formattedCollected = FlutterMoneyFormatter(
        amount: double.parse('${widget.projectData['collected']}'));
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                "${widget.projectData['date']}",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              )),
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 18,
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                "${formattedCollected.output.withoutFractionDigits}",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Icon(
                Icons.star_border,
                color: Colors.red,
                size: 18,
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                "${widget.projectData['rating']}",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Chip(label: Text('${widget.projectData['category']}')),
                     RaisedButton(
                onPressed: () {
                  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Payment(widget.projectData)),
              );
                },
                padding: EdgeInsets.all(
                  16,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(
                  8,
                ))),
                color: Color.fromRGBO(54, 74, 105, 1),
                child: Text(
                  "Donate now",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
           

                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: Text('${widget.projectData['mahalla']}, ${widget.projectData['city']}, ${widget.projectData['district']}', style: TextStyle(color:Colors.blue),),
            ),
          Text(
            "${widget.projectData['details']}",
            style: TextStyle(color: Colors.black, fontSize: 14, wordSpacing: 5),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: Text(
              "\Rs." + "${formattedAmount.output.withoutFractionDigits}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
         
        
        ],
      ),
    ));
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(
                12,
              ),
              child: Icon(
                Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child:
               RaisedButton(
                onPressed: () {
                  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Payment(widget.projectData)),
              );
                },
                padding: EdgeInsets.all(
                  16,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(
                  8,
                ))),
                color: Color.fromRGBO(54, 74, 105, 1),
                child: Text(
                  "Donate now",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
           
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));

    setState(() {});

    return null;
  }

}
