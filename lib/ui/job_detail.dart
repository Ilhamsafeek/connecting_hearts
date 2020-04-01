import 'package:flutter/material.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:zamzam/ui/payment_result.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share/share.dart';

class JobDetail extends StatefulWidget {
  @override
  _JobDetailState createState() => _JobDetailState();

  JobDetail({Key key}) : super(key: key);
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
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNx5dVdpXBY0lA7AvUQy-0EbopGojGfhsHJEo_AOpr1154CvUAFtA&s=0',
                fit: BoxFit.cover,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Share this appeal',
                onPressed: () {
                  Share.share('check out my website https://example.com',
                      subject: 'Look what I made!');
                },
              ),
            ],
          ),
        ]));
  }
}
