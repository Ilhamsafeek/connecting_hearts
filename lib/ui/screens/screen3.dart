import 'package:flutter/material.dart';
import 'package:zamzam/ui/job_detail.dart';

class Subscriptioins extends StatefulWidget {
  Subscriptioins({Key key}) : super(key: key);

  _SubscriptioinsState createState() => _SubscriptioinsState();
}

class _SubscriptioinsState extends State<Subscriptioins> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        ExpansionTile(
          title: Text("Post New vacancy"),
          subtitle: Text('or Request for Job'),
          leading: Icon(Icons.add_circle),
          children: <Widget>[
            Image.network(
                'https://cdn.dribbble.com/users/30476/screenshots/6138614/interview.png'),
            Text('You have no posted jobs'),
            Divider(),
            Row(
              children: <Widget>[
                Expanded(
                    child: FlatButton.icon(
                  icon: Icon(
                    Icons.flash_on,
                  ),
                  onPressed: () {},
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
                    appealModalBottomSheet(context);
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
          leading: Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNx5dVdpXBY0lA7AvUQy-0EbopGojGfhsHJEo_AOpr1154CvUAFtA&s=0'),
          title: Text(
            'Graduate Trainee Marketing',
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text('Hemas Holdings PLC, Colombo'),
          trailing: Icon(Icons.favorite_border),
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
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text(
            'Graduate Trainee Marketing',
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text('Experience: 2 years'),
          // trailing: Icon(Icons.favorite_border),
        ),
        Divider(),
        ListTile(
          leading: Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNx5dVdpXBY0lA7AvUQy-0EbopGojGfhsHJEo_AOpr1154CvUAFtA&s=0'),
          title: Text(
            'Graduate Trainee Marketing',
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text('Hemas Holdings PLC, Colombo'),
          trailing: Icon(Icons.favorite_border),
        ),
        Divider(),
        ListTile(
          leading: Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNx5dVdpXBY0lA7AvUQy-0EbopGojGfhsHJEo_AOpr1154CvUAFtA&s=0'),
          title: Text(
            'Graduate Trainee Marketing',
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text('Hemas Holdings PLC, Colombo'),
          trailing: Icon(Icons.favorite_border),
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text(
            'Graduate Trainee Marketing',
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text('Experience: 2 years'),
          // trailing: Icon(Icons.favorite_border),
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text(
            'Graduate Trainee Marketing',
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text('Experience: 2 years'),
          // trailing: Icon(Icons.favorite_border),
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text(
            'Graduate Trainee Marketing',
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text('Experience: 2 years'),
          // trailing: Icon(Icons.favorite_border),
        ),
        Divider(),
        ListTile(
          leading: Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNx5dVdpXBY0lA7AvUQy-0EbopGojGfhsHJEo_AOpr1154CvUAFtA&s=0'),
          title: Text(
            'Graduate Trainee Marketing',
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text('Hemas Holdings PLC, Colombo'),
          trailing: Icon(Icons.favorite_border),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNx5dVdpXBY0lA7AvUQy-0EbopGojGfhsHJEo_AOpr1154CvUAFtA&s=0'),
          title: Text(
            'Graduate Trainee Marketing',
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text('Hemas Holdings PLC, Colombo'),
          trailing: Icon(Icons.favorite_border),
        ),
      ],
    )));
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
