import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:zamzam/ui/camera.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:zamzam/utils/read_more_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:zamzam/ui/screens/chat_detail.dart';
import 'package:zamzam/utils/dialogs.dart';

class ContributedProject extends StatefulWidget {
  @override
  _ContributedProjectState createState() => _ContributedProjectState();

  final dynamic projectData;

  ContributedProject(this.projectData, {Key key}) : super(key: key);
}

class _ContributedProjectState extends State<ContributedProject> {
  Future _projectImages;
  @override
  void initState() {
    _projectImages = WebServices(this.mApiListener)
        .getImageFromFolder(widget.projectData['project_supportives']);
    super.initState();
  }

  String selectedMethod;
  dynamic paymentAmount;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${widget.projectData['appeal_id']}',
                style: TextStyle(
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0, 0),
                      blurRadius: 3.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              background: CachedNetworkImage(
                imageUrl: widget.projectData['featured_image'],
              
                fit: BoxFit.cover,
              ),
            ),
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
        ]));
  }

  Widget _detailSection() {
    var paymentTypeExtension = "";
    var months = '${widget.projectData['months']}';
    if (widget.projectData['type'] == 'recursive') {
      paymentTypeExtension = 'in $months months';
    } else {}

    FlutterMoneyFormatter formattedAmount = FlutterMoneyFormatter(
        amount: double.parse('${widget.projectData['amount']}'));
    FlutterMoneyFormatter formattedPaid = FlutterMoneyFormatter(
        amount: double.parse('${widget.projectData['paid_amount']}'));

    double completedPercent = 100 *
        double.parse('${widget.projectData['collected']}') /
        double.parse('${widget.projectData['amount']}');
    Color completedColor = Colors.blue;
    Color percentColor = Colors.white;
    if (completedPercent >= 100) {
      completedPercent = 100.0;
      completedColor = Colors.orange;
    }

    double percent = completedPercent / 100;

    Widget _trailing = Text("Success");
    Icon _statusIcon = Icon(
      Icons.check_circle,
      color: Colors.green,
    );

    dynamic _text = "You have donated. Now you can monitor the project status.";
    if (widget.projectData['status'] == 'pending' &&
        widget.projectData['method'] == 'bank') {
      if (widget.projectData['slip_url'] == "") {
        _trailing = RaisedButton(
          color: Colors.red,
          onPressed: () async {
            WidgetsFlutterBinding.ensureInitialized();
            final cameras = await availableCameras();
            final firstCamera = cameras.first;
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => TakePictureScreen(
                    "${widget.projectData['payment_id']}",
                    firstCamera,
                  ),
                ));
          },
          child: Text(
            'Submit Deposit Slip',
            style: TextStyle(color: Colors.white),
          ),
        );

        _statusIcon = Icon(
          Icons.info_outline,
          color: Colors.orange,
        );
        _text =
            "You have donated. Please submit your bank slip to be effective";
      } else {
        _trailing = Column(children: <Widget>[
          //  CircleAvatar(child: Icon(Icons.insert_emoticon)),
          FlatButton.icon(
            icon: Icon(Icons.edit),
            onPressed: () async {
              // WidgetsFlutterBinding.ensureInitialized();
              // final cameras = await availableCameras();
              // final firstCamera = cameras.first;
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (BuildContext context) => TakePictureScreen(
              //         "${widget.projectData['payment_id']}",
              //         firstCamera,
              //       ),
              //     ));
            },
            label: Text('Edit Slip'),
          ),
        ]);
        _statusIcon = Icon(
          Icons.schedule,
          color: Colors.blue,
        );
        _text =
            "You have submitted slip for your donation. your deposit slip is under review.";
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(
            24,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: RichText(
                      text: new TextSpan(
                        style: new TextStyle(
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          new TextSpan(
                              text: 'Posted: ',
                              style:
                                  new TextStyle(fontWeight: FontWeight.w600)),
                          new TextSpan(text: '${widget.projectData['date']}'),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "Star Rating:",
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.stars,
                    color: Colors.orange,
                    size: 18,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "${widget.projectData['rating']}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              Divider(),
              Column(
                children: <Widget>[
                  Text(
                    'Categories',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 35,
                      child: new ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Chip(
                              label: Text(
                                  '${widget.projectData['project_type']}')),
                          Chip(
                              label: Text('${widget.projectData['category']}')),
                          Chip(
                              label: Text(
                                  '${widget.projectData['sub_category']}')),
                        ],
                      ))
                ],
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                "description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Divider(height: 0),
              ListTile(
                title: ReadMoreText("${widget.projectData['details']}"),
              ),
              FlatButton.icon(
                onPressed: () async {
                  print("User data========>>>${widget.projectData['manager_id']}");
                  dynamic chatId='0';
                  dynamic topic =
                      '${widget.projectData['appeal_id']} - ${widget.projectData['sub_category']}';
                  showWaitingProgress(context);
                  await WebServices(mApiListener).getChatTopics().then((value) {
                    if (value != null) {
                      dynamic result;
                      if (value.length != 0) {
                        result =value.where((el) => el['topic'] == topic).toList();
                        if (result.length != 0) {
                          print('${result[0]['chat_id']}');
                          chatId=result[0]['chat_id'];
                        }
                      }
                    }
                  });
                   Navigator.pop(context);
                  Navigator.of(context).push(
                      CupertinoPageRoute<Null>(builder: (BuildContext context) {
                    return new ChatDetail(
                        topic,
                        chatId,widget.projectData['manager_id']);
                  }));
                },
                icon: Icon(
                  Icons.message,
                  color: Colors.white,
                ),
                label: Text(
                  'Contact project manager',
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Theme.of(context).primaryColor)),
                color: Theme.of(context).primaryColor,
              ),
           
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                "My contribution",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Divider(height: 0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RichText(
                          text: new TextSpan(
                            style: new TextStyle(
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              new TextSpan(
                                  text: 'Contributed date: ',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold)),
                              new TextSpan(
                                  text: widget.projectData['date_time']),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.reply,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Transfer Method:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        widget.projectData['method'] == 'card'
                            ? FlatButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.credit_card),
                                label: Text('${widget.projectData['method']}'))
                            : FlatButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.local_atm),
                                label: Text('${widget.projectData['method']}')),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.attach_money,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Amount:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Rs.${formattedPaid.output.withoutFractionDigits}',
                            style: TextStyle(color: Colors.red, fontSize: 15.0))
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.timelapse,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Donation Status:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        _trailing,
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            infoModalBottomSheet(context, _statusIcon, _text);
                          },
                          child: _statusIcon,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.receipt,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          child: Text(
                            'View Donation Receipt',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          onTap: () {
                            _launchURL(widget.projectData['receipt_url']);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Card(
          color: Colors.cyan[50],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                "Project Updates",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Divider(height: 0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: new TextSpan(
                        style: new TextStyle(
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          new TextSpan(
                              text: 'Rs.',
                              style:
                                  new TextStyle(fontWeight: FontWeight.w600)),
                          new TextSpan(
                              text:
                                  '${formattedAmount.output.withoutFractionDigits}',
                              style: TextStyle(fontSize: 32)),
                        ],
                      ),
                    ),
                    new LinearPercentIndicator(
                      alignment: MainAxisAlignment.center,
                      animation: true,
                      lineHeight: 14.0,
                      animationDuration: 2000,
                      width: 140.0,
                      percent: percent,
                      center: Text(
                        "${double.parse(completedPercent.toStringAsFixed(2))}%",
                        style:
                            new TextStyle(fontSize: 12.0, color: percentColor),
                      ),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      backgroundColor: Colors.grey,
                      progressColor: completedColor,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.donut_small),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Project Execution stage: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${widget.projectData['completed_percentage']} %",
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.fileImage),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Project Images: ',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(height: 0),
              FutureBuilder<dynamic>(
                future: _projectImages,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  List<Widget> children;

                  if (snapshot.hasData) {
                    dynamic data = snapshot.data;
                    children = <Widget>[
                      for (var item in data)
                        CachedNetworkImage(
                          imageUrl: item,
                          placeholder: (context, url) =>
                              Image.asset('assets/placeholder.png'),
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
                        child: Text(
                            'something Went Wrong !'), //Error: ${snapshot.error}
                      )
                    ];
                  } else {
                    children = <Widget>[
                      Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Container(
                              child: Column(
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 16 / 10,
                                child: Container(color: Colors.black),
                              ),
                            ],
                          )))
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
              ),
           
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> infoModalBottomSheet(context, icon, text) {
    return showModalBottomSheet(
        enableDrag: true,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: ListTile(
                        title: Text('What does it means?'),
                        trailing: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )),
                  Divider(
                    height: 0,
                  ),
                  ListTile(
                    leading: icon,
                    title: Text(text),
                  ),
                ],
              ),
            );
          });
        });
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("You will be notified when we prepared your receipt."),
      ));
    }
  }
}
