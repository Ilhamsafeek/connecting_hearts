import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


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
                        onTap: (){
                          _launchURL("mailto:${widget.jobDetails['email']}");
                        },
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
                        onTap: (){
                          _launchURL("tel://${widget.jobDetails['contact']}");
                        },
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
   _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
