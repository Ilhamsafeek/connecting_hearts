import 'package:flutter/material.dart';
import 'package:zamzam/ui/job/edit_appeal.dart';
import 'package:zamzam/ui/job/edit_vacancy.dart';
import 'package:zamzam/ui/job/job_detail.dart';
import 'package:zamzam/ui/job/appeal_job.dart';
import 'package:zamzam/ui/job/post_vacancy.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zamzam/services/services.dart';
import 'package:zamzam/constant/Constant.dart';

class Jobs extends StatefulWidget {
  Jobs({Key key}) : super(key: key);

  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  @override
  ApiListener mApiListener;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(

            // child: AnimationLimiter(
            child: Column(
                children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 375),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: 50.0,
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children: <Widget>[
            ExpansionTile(
              title: Text("Post New vacancy"),
              subtitle: Text('or Request for Job'),
              leading: Icon(Icons.add_circle),
              children: <Widget>[
                // Image.network(
                //     'https://cdn.dribbble.com/users/30476/screenshots/6138614/interview.png'),
                ExpansionTile(
                  title: Text('My Appeals and vacancies'),
                  children: <Widget>[
                    FutureBuilder<dynamic>(
                        future: WebServices(this.mApiListener).getJobData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          List<Widget> children;

                          if (snapshot.hasData) {
                            var data = snapshot.data
                                .where((el) => el['posted_by'] == CURRENT_USER)
                                .toList();
                            print(data);
                            children = <Widget>[
                              for (var item in data)
                                Container(
                                    child: Column(children: <Widget>[
                                  _buildJobListTile(item, 'my'),
                                  Divider()
                                ]))
                            ];

                            return Center(
                              child: Column(
                                children: children,
                              ),
                            );
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
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: FlatButton.icon(
                      icon: Icon(
                        Icons.flash_on,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostVacancy()),
                        );
                      },
                      label: Text(
                        'Post a Vacancy',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
                    Expanded(
                        child: FlatButton.icon(
                      color: Colors.blue[900],
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AppealJob()),
                        );
                      },
                      label: Text(
                        'Appeal a Job',
                        style: TextStyle(color: Colors.white),
                      ),
                    ))
                  ],
                ),
              ],
              initiallyExpanded: false,
            ),
            ListTile(
              title: Text(
                'All vacancies and appeals',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              height: 0,
            ),
            FutureBuilder<dynamic>(
                future: WebServices(this.mApiListener).getJobData(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  List<Widget> children;

                  if (snapshot.hasData) {
                    children = <Widget>[
                      for (var item in snapshot.data)
                        Container(
                            child: Column(children: <Widget>[
                          _buildJobListTile(item, 'all'),
                          Divider()
                        ]))
                    ];

                    return Center(
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 375),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: children,
                        ),
                      ),
                    );
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
        ))));
  }

  Widget _buildJobListTile(item, category) {
    if (item['type'] == 'appeal') {
      return ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text(item['title']),
        subtitle: Text('Experience: ${item['min_experience']}'),
        trailing: category == 'my'
            ? PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == "edit") {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, anim1, anim2) =>
                            EditAppeal(item),
                        transitionsBuilder: (context, anim1, anim2, child) =>
                            FadeTransition(opacity: anim1, child: child),
                        transitionDuration: Duration(milliseconds: 100),
                      ),
                    );
                  } else {
                    _deleteModalBottomSheet(context, item['id']);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text("Edit"),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text("Delete"),
                  ),
                ],
              )
            : null,
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, anim1, anim2) => JobDetail(item),
              transitionsBuilder: (context, anim1, anim2, child) =>
                  FadeTransition(opacity: anim1, child: child),
              transitionDuration: Duration(milliseconds: 100),
            ),
          );
        },
      );
    } else {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal,
          child: Text(
            '${item['organization'][0]}',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        title: Text(item['title']),
        subtitle: Text('${item['organization']}'),
        trailing: category == 'my'
            ? PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, anim1, anim2) =>
                            EditVacancy(item),
                        transitionsBuilder: (context, anim1, anim2, child) =>
                            FadeTransition(opacity: anim1, child: child),
                        transitionDuration: Duration(milliseconds: 100),
                      ),
                    );
                  } else {
                    _deleteModalBottomSheet(context, item['id']);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text("Edit"),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text("Delete"),
                  ),
                ],
              )
            : Icon(
                Icons.turned_in_not,
                color: Colors.grey,
              ),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, anim1, anim2) => JobDetail(item),
              transitionsBuilder: (context, anim1, anim2, child) =>
                  FadeTransition(opacity: anim1, child: child),
              transitionDuration: Duration(milliseconds: 100),
            ),
          );
        },
      );
    }
  }

  Future<bool> _deleteModalBottomSheet(context, id) {
    return showModalBottomSheet(
        enableDrag: false,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Do you really want to delete?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Divider(
                    height: 0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              child: Text('No'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                              child: RaisedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Deleting.."),
                              ));
                              WebServices(mApiListener)
                                  .deleteJob(id)
                                  .then((value) => {
                                        if (value == 200)
                                          {
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text("Deleted Successfully."),
                                            ))
                                          }
                                        else
                                          {
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text("Something went wrong!"),
                                            ))
                                          }
                                      });
                            },
                            child: Text("Yes"),
                            color: Colors.black,
                            textColor: Colors.white,
                          )),
                        ],
                      )
                    ]),
                  )
                ],
              ),
            );
          });
        });
  }
}
