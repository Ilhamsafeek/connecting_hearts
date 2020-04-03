import 'package:flutter/material.dart';
import 'package:zamzam/ui/job/job_detail.dart';
import 'package:zamzam/ui/job/appeal_job.dart';
import 'package:zamzam/ui/job/post_vacancy.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zamzam/services/services.dart';
import 'package:zamzam/ui/sermon/channel_detail.dart';
import 'package:zamzam/constant/Constant.dart';

class Subscriptioins extends StatefulWidget {
  Subscriptioins({Key key}) : super(key: key);

  _SubscriptioinsState createState() => _SubscriptioinsState();
}

class _SubscriptioinsState extends State<Subscriptioins> {
  @override
  ApiListener mApiListener;

  Widget build(BuildContext context) {
    return Scaffold(
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
            Image.network(
                'https://cdn.dribbble.com/users/30476/screenshots/6138614/interview.png'),
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
                      MaterialPageRoute(builder: (context) => PostVacancy()),
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
                  icon: Icon(Icons.wb_sunny, color: Colors.white),
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
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
            ? IconButton(
                icon: Icon(Icons.more_horiz),
                color: Colors.grey,
                onPressed: () {},
              )
            : null,
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, anim1, anim2) => JobDetail(),
              transitionsBuilder: (context, anim1, anim2, child) =>
                  FadeTransition(opacity: anim1, child: child),
              transitionDuration: Duration(milliseconds: 100),
            ),
          );
        },
      );
    } else {
      return ListTile(
        leading: Image.network(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNx5dVdpXBY0lA7AvUQy-0EbopGojGfhsHJEo_AOpr1154CvUAFtA&s=0',
          height: 60,
          width: 60,
        ),
        title: Text(item['title']),
        subtitle: Text('Experience: ${item['min_experience']}'),
        trailing: category == 'my'
            ? IconButton(
                icon: Icon(Icons.more_horiz),
                color: Colors.grey,
                onPressed: () {},
              )
            : Icon(
                Icons.favorite_border,
                color: Colors.grey,
              ),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, anim1, anim2) => JobDetail(),
              transitionsBuilder: (context, anim1, anim2, child) =>
                  FadeTransition(opacity: anim1, child: child),
              transitionDuration: Duration(milliseconds: 100),
            ),
          );
        },
      );
    }
  }

  Future<bool> appealModalBottomSheet(context) {
    return showModalBottomSheet(
        enableDrag: false,
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Appeal a Job',
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
                  ListTile(
                      leading: Icon(Icons.card_travel),
                      title: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Job Title',
                        ),
                        onChanged: (value) {},
                      ),
                      onTap: () => {}),
                  ListTile(
                      leading: Icon(Icons.access_time),
                      title: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Experience',
                        ),
                        onChanged: (value) {},
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
                              onPressed: () {},
                              child: Text("Post Appeal"),
                              color: Colors.blue[800],
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
        });
  }
}
