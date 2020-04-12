import 'package:flutter/material.dart';
import 'package:zamzam/services/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zamzam/ui/single_video.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zamzam/ui/job/job_detail.dart';
import 'package:zamzam/ui/project_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSearchChanged = Future<List<String>> Function(String);

class DataSearch extends SearchDelegate<String> {
  ApiListener mApiListener;

  final OnSearchChanged onSearchChanged;
  List<String> _oldFilters = const [];

  DataSearch({String searchFieldLabel, this.onSearchChanged})
      : super(searchFieldLabel: searchFieldLabel);

  Future<void> saveToRecentSearches(String searchText) async {
    if (searchText == null) return; //Should not be null
    final pref = await SharedPreferences.getInstance();

    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches =
        pref.getStringList("recentSearches")?.toSet() ?? {};

    //Place it at first in the set
    allSearches = {searchText, ...allSearches};
    pref.setStringList("recentSearches", allSearches.toList());
  }

  Future<List<String>> getRecentSearchesLike(String query) async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList("recentSearches");
    return allSearches.where((search) => search.startsWith(query)).toList();
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left side of app bar
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, this.query);
        });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.mic),
        tooltip: 'Voice input',
        onPressed: () {
          // this.query = 'TBW: Get input from voice';
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    saveToRecentSearches(this.query);
    // show some result based on the selection
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //Charity
              GestureDetector(
                onTap: () async {
                  //Define your action when clicking on result item.
                  //Here, it simply closes the page

                  this.close(context, this.query);
                },
                child: FutureBuilder<dynamic>(
                  future: WebServices(this.mApiListener)
                      .getProjectData(), // a previously-obtained Future<String> or null
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    List<Widget> children;

                    if (snapshot.hasData) {
                      var data = snapshot.data.where((el) {
                        return el['category']
                                .toLowerCase()
                                .contains(this.query.toLowerCase())
                            ? true
                            : false || el['appeal_id'].toLowerCase().contains(this.query.toLowerCase())
                                ? true
                                : false ||
                                        el['address']
                                            .toLowerCase()
                                            .contains(this.query.toLowerCase())
                                    ? true
                                    : false ||
                                            el['city'].toLowerCase().contains(
                                                this.query.toLowerCase())
                                        ? true
                                        : false ||
                                                el['district'].toLowerCase().contains(
                                                    this.query.toLowerCase())
                                            ? true
                                            : false || el['mahalla'].toLowerCase().contains(this.query.toLowerCase())
                                                ? true
                                                : false || el['details'].toLowerCase().contains(this.query.toLowerCase())
                                                    ? true
                                                    : false ||
                                                            el['type']
                                                                .toLowerCase()
                                                                .contains(this.query.toLowerCase())
                                                        ? true
                                                        : false;
                      }).toList();
                      children = <Widget>[
                        data.length != 0
                            ? Text('Charity',
                                style: TextStyle(fontWeight: FontWeight.bold))
                            : Text(''),
                        for (var item in data)
                          Container(
                              child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(item['category']),
                                subtitle: Text("Posted: ${item['date']}", style: TextStyle(fontSize:12),),
                                trailing: Chip(
                                    avatar: Icon(
                                      Icons.star_border,
                                      color: Colors.orange,
                                    ),
                                    label: Text(' ${item['rating']}')),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProjectDetail(item)),
                                  );
                                },
                              ),
                              Divider(height: 1)
                            ],
                          ))
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
                              'could not search from charity !'), //Error: ${snapshot.error}
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
                      ),
                    );
                  },
                ),
              ),
              //Sermon
              GestureDetector(
                onTap: () {
                  //Define your action when clicking on result item.
                  //Here, it simply closes the page
                  this.close(context, this.query);
                },
                child: FutureBuilder<dynamic>(
                  future: WebServices(this.mApiListener)
                      .getSermonData(), // a previously-obtained Future<String> or null
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    List<Widget> children;

                    if (snapshot.hasData) {
                      var data = snapshot.data.where((el) {
                        return el['channel']
                                .toLowerCase()
                                .contains(this.query.toLowerCase())
                            ? true
                            : false ||
                                    el['title']
                                        .toLowerCase()
                                        .contains(this.query.toLowerCase())
                                ? true
                                : false;
                      }).toList();
                      children = <Widget>[
                        data.length != 0
                            ? Text('Sermons',
                                style: TextStyle(fontWeight: FontWeight.bold))
                            : Text(''),
                        for (var item in data)
                          Container(
                              child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: AspectRatio(
                                  child: Image(
                                    width: 30,
                                    image: NetworkImage(
                                        YoutubePlayer.getThumbnail(
                                            videoId:
                                                YoutubePlayer.convertUrlToId(
                                                    item['url']))),
                                    centerSlice: Rect.largest,
                                  ),
                                  aspectRatio: 16 / 10,
                                ),
                                title: Text(item['title']),
                                subtitle: Text(item['date']),
                                // trailing: FlatButton.icon(
                                //   onPressed: () {},
                                //   icon: Icon(Icons.file_download),
                                //   label: Text('4.5MB'),
                                // ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Play(item)),
                                  );
                                },
                              ),
                              Divider(height: 1)
                            ],
                          ))
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
                              'Could not search from sermons !'), //Error: ${snapshot.error}
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
                      ),
                    );
                  },
                ),
              ),
              // Jobs
              GestureDetector(
                onTap: () {
                  //Define your action when clicking on result item.
                  //Here, it simply closes the page
                  this.close(context, this.query);
                },
                child: FutureBuilder<dynamic>(
                  future: WebServices(this.mApiListener)
                      .getJobData(), // a previously-obtained Future<String> or null
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    List<Widget> children;

                    if (snapshot.hasData) {
                      var data = snapshot.data.where((el) {
                        return el['title']
                                .toLowerCase()
                                .contains(this.query.toLowerCase())
                            ? true
                            : false ||
                                    el['type']
                                        .toLowerCase()
                                        .contains(this.query.toLowerCase())
                                ? true
                                : false ||
                                        el['location']
                                            .toLowerCase()
                                            .contains(this.query.toLowerCase())
                                    ? true
                                    : false ||
                                            el['min_experience']
                                                .toLowerCase()
                                                .contains(
                                                    this.query.toLowerCase())
                                        ? true
                                        : false ||
                                                el['description']
                                                    .toLowerCase()
                                                    .contains(this
                                                        .query
                                                        .toLowerCase())
                                            ? true
                                            : false ||
                                                    el['organization']
                                                        .toLowerCase()
                                                        .contains(
                                                            this.query.toLowerCase())
                                                ? true
                                                : false;
                      }).toList();
                      children = <Widget>[
                        data.length != 0
                            ? Text('Jobs',
                                style: TextStyle(fontWeight: FontWeight.bold))
                            : Text(''),
                        for (var item in data) _buildJobListTile(context, item)
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
                              'Could not search from jobs !'), //Error: ${snapshot.error}
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
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: onSearchChanged != null ? onSearchChanged(query) : null,
      builder: (context, snapshot) {
        if (snapshot.hasData) _oldFilters = snapshot.data;
        return ListView.builder(
          itemCount: _oldFilters.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.restore),
              title: Text("${_oldFilters[index]}"),
              onTap: () {
                showResults(context);
                this.query = _oldFilters[index];
                // close(context, _oldFilters[index]);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildJobListTile(context, item) {
    if (item['type'] == 'appeal') {
      return ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text(item['title']),
        subtitle: Text('Experience: ${item['min_experience']}'),
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
}

// }
