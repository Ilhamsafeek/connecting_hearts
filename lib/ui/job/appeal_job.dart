import 'package:flutter/material.dart';
import 'package:zamzam/constant/Constant.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:zamzam/ui/payment_result.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share/share.dart';
import 'package:zamzam/services/services.dart';

class AppealJob extends StatefulWidget {
  @override
  _AppealJobState createState() => _AppealJobState();

  AppealJob({Key key}) : super(key: key);
}

class _AppealJobState extends State<AppealJob> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;
  final _title = TextEditingController(text: "");
  final _experience = TextEditingController(text: "");
  final _description = TextEditingController(text: "");
  final _email = TextEditingController(text: "");
  final _contact = TextEditingController(text: "$CURRENT_USER");
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: Text('Appeal a job')),
        body: SingleChildScrollView(
            child: Container(
          child: new Wrap(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Appeal a job to display in the board',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                height: 0,
              ),
              ListTile(
                leading: Icon(Icons.card_travel),
                title: TextFormField(
                  controller: _title,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Job Title',
                  ),
                  onChanged: (value) {},
                ),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: TextFormField(
                  controller: _experience,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Experience',
                  ),
                  onChanged: (value) {},
                ),
                trailing: Text('Years'),
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: TextFormField(
                  controller: _description,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Description',
                  ),
                  onChanged: (value) {},
                ),
              ),
              ListTile(
                leading: Icon(Icons.mail),
                title: TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                  onChanged: (value) {},
                ),
              ),
              ListTile(
                leading: Icon(Icons.call),
                title: TextFormField(
                  controller: _contact,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Contact',
                  ),
                  onChanged: (value) {},
                ),
              ),
              ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: RaisedButton(
                          onPressed: () {
                            print(_description.value);
                            WebServices(this.mApiListener)
                                .postJob(
                                    'appeal',
                                    _title.text,
                                    '',
                                    _experience.text,
                                    _description.text,
                                    _contact.text,
                                    _email.text,
                                    '',
                                    '')
                                .then(
                                  (value) => {
                                    if (value == 200)
                                      {
                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                              
                                          content: Text(
                                              "Appeal Posted Succesfully !"),
                                              onVisible: (){
                                                Navigator.pop(context);
                                              },
                                        ))
                                      }
                                    else
                                      {
                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Oops! something went wrong. please try again"),
                                        ))
                                      }
                                  },
                                );
                          },
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
        )));
  }
}
