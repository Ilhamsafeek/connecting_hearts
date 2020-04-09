import 'package:flutter/material.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:zamzam/test.dart';
import 'package:zamzam/ui/job/edit_appeal.dart';
import 'package:zamzam/ui/payment_result.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share/share.dart';

import 'edit_vacancy.dart';

class JobDetail extends StatefulWidget {
  @override
  _JobDetailState createState() => _JobDetailState();
  final dynamic jobDetails;
  JobDetail(this.jobDetails, {Key key}) : super(key: key);
}

class _JobDetailState extends State<JobDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        actions: <Widget>[
          Chip(label: Text(widget.jobDetails['type'])),
          IconButton(
            onPressed: () {
            widget.jobDetails['type'] == 'vacancy'?  Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, anim1, anim2) =>
                      EditVacancy(widget.jobDetails),
                  transitionsBuilder: (context, anim1, anim2, child) =>
                      FadeTransition(opacity: anim1, child: child),
                  transitionDuration: Duration(milliseconds: 100),
                ),
              )
            : Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, anim1, anim2) =>
                      EditAppeal(widget.jobDetails),
                  transitionsBuilder: (context, anim1, anim2, child) =>
                      FadeTransition(opacity: anim1, child: child),
                  transitionDuration: Duration(milliseconds: 100),
                ),
              );
            },
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: <Widget>[
                Container(
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: ListTile(
                            title: Text(widget.jobDetails['title'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                      ),
                      (widget.jobDetails['type'] == 'vacancy')
                          ? ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  '${widget.jobDetails['organization'][0]}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              title: Text(
                                  '${widget.jobDetails['organization']}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17)),
                              subtitle: Text(
                                "${widget.jobDetails['location']}",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    wordSpacing: 5),
                              ),
                            )
                          : ListTile(
                              title: Text(
                                  'Experience: ${widget.jobDetails['min_experience']}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      wordSpacing: 5)),
                            )
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.access_time),
                        title: Text(
                          "${widget.jobDetails['date_time']}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              wordSpacing: 5),
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "description",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Divider(height: 0),
                      ListTile(
                        title: Text(
                          "${widget.jobDetails['description']}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              wordSpacing: 5),
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.mail),
                        title: Text(
                          "${widget.jobDetails['email']}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              wordSpacing: 5),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.call),
                        title: Text(
                          "${widget.jobDetails['contact']}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              wordSpacing: 5),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
