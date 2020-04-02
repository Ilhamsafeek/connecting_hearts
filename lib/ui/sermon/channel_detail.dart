import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ChannelDetail extends StatefulWidget {
  @override
  _ChannelDetailState createState() => _ChannelDetailState();
  final dynamic channelData;
  ChannelDetail(this.channelData, {Key key}) : super(key: key);
}

class _ChannelDetailState extends State<ChannelDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        expandedHeight: 200.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            widget.channelData['channel'],
            style: TextStyle(color: Colors.black87),
          ),
          background: Image.asset(
            'assets/mufti_menk.jpg',
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
      )
    ]));
  }

  Widget _detailSection() {
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: Text(
            "Description about this channel",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text('Addedd 3 years ago'),
          leading: CircleAvatar(
            backgroundImage: new AssetImage('assets/mufti_menk.jpg'),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(widget.channelData['description']),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: FlatButton.icon(
                  color: Colors.blue[900],
                  icon: Icon(Icons.wb_sunny, color: Colors.white),
                  onPressed: () {},
                  label: Text(
                    'Subscribe',
                    style: TextStyle(color: Colors.white),
                  ),
                ))
              ],
            ),
          ],
          initiallyExpanded: false,
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(
            radius: 20,
            child: Icon(
              Icons.audiotrack,
              color: Colors.white,
            ),
            backgroundColor: Colors.grey[600],
          ),
          title: Text('Allah is Testing you !'),
          subtitle: Text('12 March, 2020'),
          trailing: FlatButton.icon(
            onPressed: () {},
            icon: Icon(Icons.file_download),
            label: Text('4.5MB'),
          ),
          onTap: () {
            playModalBottomSheet(context);
          },
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(
            radius: 20,
            child: Icon(
              Icons.audiotrack,
              color: Colors.white,
            ),
            backgroundColor: Colors.grey[600],
          ),
          title: Text('Allah is Testing you !'),
          subtitle: Text('12 March, 2020'),
          trailing: FlatButton.icon(
            onPressed: () {},
            icon: Icon(Icons.file_download),
            label: Text('4.5MB'),
          ),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(
            radius: 20,
            child: Icon(
              Icons.audiotrack,
              color: Colors.white,
            ),
            backgroundColor: Colors.grey[600],
          ),
          title: Text('Allah is Testing you !'),
          subtitle: Text('12 March, 2020'),
          trailing: FlatButton.icon(
            onPressed: () {},
            icon: Icon(Icons.file_download),
            label: Text('4.5MB'),
          ),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(
            radius: 20,
            child: Icon(
              Icons.audiotrack,
              color: Colors.white,
            ),
            backgroundColor: Colors.grey[600],
          ),
          title: Text('Allah is Testing you !'),
          subtitle: Text('12 March, 2020'),
          trailing: FlatButton.icon(
            onPressed: () {},
            icon: Icon(Icons.file_download),
            label: Text('4.5MB'),
          ),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(
            radius: 20,
            child: Icon(
              Icons.audiotrack,
              color: Colors.white,
            ),
            backgroundColor: Colors.grey[600],
          ),
          title: Text('Allah is Testing you !'),
          subtitle: Text('12 March, 2020'),
          trailing: FlatButton.icon(
            onPressed: () {},
            icon: Icon(Icons.file_download),
            label: Text('4.5MB'),
          ),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(
            radius: 20,
            child: Icon(
              Icons.audiotrack,
              color: Colors.white,
            ),
            backgroundColor: Colors.grey[600],
          ),
          title: Text('Allah is Testing you !'),
          subtitle: Text('12 March, 2020'),
          trailing: FlatButton.icon(
            onPressed: () {},
            icon: Icon(Icons.file_download),
            label: Text('4.5MB'),
          ),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(
            radius: 20,
            child: Icon(
              Icons.audiotrack,
              color: Colors.white,
            ),
            backgroundColor: Colors.grey[600],
          ),
          title: Text('Allah is Testing you !'),
          subtitle: Text('12 March, 2020'),
          trailing: FlatButton.icon(
            onPressed: () {},
            icon: Icon(Icons.file_download),
            label: Text('4.5MB'),
          ),
          onTap: () {},
        ),
        Divider(),
      ],
    );
  }

  Future<bool> playModalBottomSheet(context) {
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
                        title: Text('Allah is Watching you !'),
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: ListTile(
                        leading: IconButton(
                          icon: CircleAvatar(
                            radius: 20,
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.grey[600],
                          ),
                          onPressed: () {
                            // Navigator.of(context).pop();
                          },
                        ),
                        title: LinearProgressIndicator(
                          backgroundColor: Colors.grey[600],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.volume_up),
                          onPressed: () {
                            // Navigator.of(context).pop();
                          },
                        ),
                      )),
                ],
              ),
            );
          });
        });
  }
}
