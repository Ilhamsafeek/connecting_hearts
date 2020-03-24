import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zamzam/ui/payment_result.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

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

  String selectedMethod;
  selectsku(method) {
    print(method);
    setState(() {
      selectedMethod = method;
    });
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
              title: Text('${widget.projectData['appeal_id']}'),
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
                  child: _buildBottomBar(),
                );
              },
              childCount: 1,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
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
    var paymentTypeExtension= "";
    var months = '${widget.projectData['months']}';
    if(widget.projectData['type']=='recursive'){
      paymentTypeExtension = 'in $months months';
    }else{

    }
    
    FlutterMoneyFormatter formattedAmount = FlutterMoneyFormatter(
        amount: double.parse('${widget.projectData['amount']}'));
    FlutterMoneyFormatter formattedCollected = FlutterMoneyFormatter(
        amount: double.parse('${widget.projectData['collected']}'));
  
    double completedPercent = 100 *
        double.parse('${widget.projectData['collected']}') /
        double.parse('${widget.projectData['amount']}');
    Color completedColor = Colors.orange;
    Color percentColor = Colors.black;
    if (completedPercent >= 100) {
      completedPercent = 100.0;
      completedColor = Colors.green[900];
      percentColor = Colors.white;
    }

    double percent = completedPercent / 100;
  
  
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
            child: Text(
              '${widget.projectData['mahalla']}, ${widget.projectData['city']}, ${widget.projectData['district']}',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          Text(
            "${widget.projectData['details']}",
            style: TextStyle(color: Colors.black, fontSize: 14, wordSpacing: 5),
          ),
          ListTile(
            title: new LinearPercentIndicator(
              animation: true,
              lineHeight: 14.0,
              animationDuration: 2000,
              width: 140.0,
              percent: percent,
              center: Text(
                "${double.parse(completedPercent.toStringAsFixed(2))}%",
                style: new TextStyle(fontSize: 12.0, color: percentColor),
              ),
              trailing: Text(
                'Rs.' + '${formattedAmount.output.withoutFractionDigits}',
                style: TextStyle(
                    fontFamily: "Exo2",
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
              linearStrokeCap: LinearStrokeCap.roundAll,
              backgroundColor: Colors.grey,
              progressColor: completedColor,
            ),
          ),
        
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: Text(
              "This appeal requires: " +
                  "${widget.projectData['type']} payment $paymentTypeExtension",
              style: TextStyle(
                fontSize: 16,
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
              child: RaisedButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     PageRouteBuilder(
                  //       pageBuilder: (context, anim1, anim2) => Payment(),
                  //       transitionsBuilder: (context, anim1, anim2, child) =>
                  //           FadeTransition(opacity: anim1, child: child),
                  //       transitionDuration: Duration(milliseconds: 100),
                  //     ));
                  payModalBottomSheet(context);
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

  Future<bool> payModalBottomSheet(context) {
    return showModalBottomSheet(
        enableDrag: true,
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                ListTile(title: Text('Choose a payment method')),
                RadioListTile(
                  activeColor: Colors.black,
                  value: 'sku_Gt6Fd6L4tzklsI',
                  groupValue: selectedMethod,
                  onChanged: selectsku,
                  title: ListTile(
                    leading: Icon(FontAwesomeIcons.ccVisa),
                    title: Text('****1112'),
                  ),
                ),
                ListTile(
                    title: TextFormField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Amount',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                    onTap: () => {}),
                ListTile(
                    title: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentResult()),
                              );
                            },
                            child: Text("Send"),
                            color: Colors.green[800],
                            textColor: Colors.white,
                          )),
                        ],
                      ),
                    ),
                    onTap: () => {}),
              ],
            ),
          );
        });
  }
}
