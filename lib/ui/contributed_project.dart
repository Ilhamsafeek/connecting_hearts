// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:zamzam/ui/camera.dart';
import 'package:zamzam/ui/payment_result.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share/share.dart';
import 'package:zamzam/utils/read_more_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContributedProject extends StatefulWidget {
  @override
  _ContributedProjectState createState() => _ContributedProjectState();

  final dynamic projectData;

  ContributedProject(this.projectData, {Key key}) : super(key: key);
}

class _ContributedProjectState extends State<ContributedProject> {
  @override
  void initState() {
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

  final List<String> images = [
    "https://uae.microless.com/cdn/no_image.jpg",
    "https://images-na.ssl-images-amazon.com/images/I/81aF3Ob-2KL._UX679_.jpg",
    "https://www.boostmobile.com/content/dam/boostmobile/en/products/phones/apple/iphone-7/silver/device-front.png.transform/pdpCarousel/image.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgUgs8_kmuhScsx-J01d8fA1mhlCR5-1jyvMYxqCB8h3LCqcgl9Q",
    "https://ae01.alicdn.com/kf/HTB11tA5aiAKL1JjSZFoq6ygCFXaw/Unlocked-Samsung-GALAXY-S2-I9100-Mobile-Phone-Android-Wi-Fi-GPS-8-0MP-camera-Core-4.jpg_640x640.jpg",
    "https://media.ed.edmunds-media.com/gmc/sierra-3500hd/2018/td/2018_gmc_sierra-3500hd_f34_td_411183_1600.jpg",
    "https://hips.hearstapps.com/amv-prod-cad-assets.s3.amazonaws.com/images/16q1/665019/2016-chevrolet-silverado-2500hd-high-country-diesel-test-review-car-and-driver-photo-665520-s-original.jpg",
    "https://www.galeanasvandykedodge.net/assets/stock/ColorMatched_01/White/640/cc_2018DOV170002_01_640/cc_2018DOV170002_01_640_PSC.jpg",
    "https://media.onthemarket.com/properties/6191869/797156548/composite.jpg",
    "https://media.onthemarket.com/properties/6191840/797152761/composite.jpg",
  ];
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
              title: Text('${widget.projectData['appeal_id']}'),
              background: Image.network(
                widget.projectData['featured_image'],
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
    if (widget.projectData['status'] == 'pending') {
      if (widget.projectData['slip_url'] == "") {
        _trailing = RaisedButton(
          color: Colors.red,
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
                  Row(
                    children: <Widget>[
                      Text(
                        'Categories: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Chip(
                            label:
                                Text('${widget.projectData['project_type']}')),
                      ),
                      Expanded(
                        child: Chip(
                            label: Text('${widget.projectData['category']}')),
                      ),
                      Expanded(
                        child: Chip(
                            label:
                                Text('${widget.projectData['sub_category']}')),
                      ),
                    ],
                  ),
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
              )
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
                        Text(
                          'View Donation Receipt',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
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
                          Icons.description,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Project Documents: ',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                        Icon(FontAwesomeIcons.filePdf),
                        Icon(FontAwesomeIcons.fileWord),
                        Icon(FontAwesomeIcons.fileImage)
                      ],
                    ),
                  ],
                ),
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
}
