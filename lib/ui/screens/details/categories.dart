import 'package:braintree_payment/braintree_payment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zamzam/payment/main.dart';
import 'package:zamzam/services/braintree.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:zamzam/ui/payment_result.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share/share.dart';
import 'package:zamzam/ui/screens/charity.dart';
import 'package:zamzam/utils/read_more_text.dart';
import 'package:zamzam/utils/dialogs.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();

  final dynamic photo;
  final dynamic category;
  final dynamic description;

  Categories(this.photo, this.category, this.description, {Key key})
      : super(key: key);
}

class _CategoriesState extends State<Categories> {
  @override
  void initState() {
    super.initState();
  }

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
              title: Text(
                '${widget.category}',
                style: TextStyle(
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 3.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              background: Image.asset(
                '${widget.photo}',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text("${widget.description}"),
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Center(
                child: FlatButton.icon(
              color: Colors.orange,
              onPressed: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new Charity();
                }));
              },
              icon: Icon(Icons.lock_outline),
              label: Text(
                'Donate now',
                style: TextStyle(color: Colors.white),
              ),
            )))
      ],
    );
  }
}
