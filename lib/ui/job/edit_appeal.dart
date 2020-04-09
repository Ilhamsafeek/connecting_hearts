import 'package:flutter/material.dart';
import 'package:zamzam/services/services.dart';

class EditAppeal extends StatefulWidget {
  @override
  _EditAppealState createState() => _EditAppealState();
  final dynamic appealData;
  EditAppeal(this.appealData,{Key key}) : super(key: key);
}

class _EditAppealState extends State<EditAppeal> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
  final _title = TextEditingController(text: widget.appealData['title']);
  final _experience = TextEditingController(text: widget.appealData['min_experience']);
  final _description = TextEditingController(text: widget.appealData['description']);
  final _email = TextEditingController(text: widget.appealData['email']);
  final _contact = TextEditingController(text: widget.appealData['contact']);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            title: Text('Edit Job Appeal'),
            leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: SingleChildScrollView(
            child: Container(
          child: new Wrap(
            children: <Widget>[
             
              Form(
                  key: _formKey,
                  child: Column(
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Title cannot be empty";
                            }
                          },
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
                           validator: (value) {
                            if (value.isEmpty) {
                              return "Experience cannot be empty";
                            }
                          },
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
                          maxLines: 4,
                          controller: _description,
                           validator: (value) {
                            if (value.isEmpty) {
                              return "Description cannot be empty";
                            }
                          },
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
                           validator: (value) {
                            if (value.isEmpty) {
                              return "Email cannot be empty";
                            }
                          },
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
                           validator: (value) {
                            if (value.isEmpty) {
                              return "Contact cannot be empty";
                            }
                          },
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
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: RaisedButton(
                                  onPressed: () {
                                    _formKey.currentState.validate()
                                        ? WebServices(this.mApiListener)
                                            .editJob(
                                                widget.appealData['id'],
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
                                                          "Appeal Updated Succesfully !"),
                                                      onVisible: () {
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
                                            )
                                        : _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                            content:
                                                Text("Please check the inputs"),
                                          ));
                                 
                                  },
                                  child: Text("Edit Appeal"),
                                  color: Colors.blue[800],
                                  textColor: Colors.white,
                                )),
                              ],
                            ),
                          ),
                          onTap: () => {}),
                    ],
                  ))
            ],
          ),
        )));
  }
}
