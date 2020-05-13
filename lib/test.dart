import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  File imageFile;

  @override
  void initState() {
    if (Platform.isAndroid) {
      PermissionHandler().requestPermissions([
        PermissionGroup.storage,
        PermissionGroup.camera,
      ]);
    }
    if (Platform.isIOS) {
      PermissionHandler().requestPermissions([
        PermissionGroup.photos,
        PermissionGroup.camera,
      ]);
    }

    super.initState();
  }

  Future _getImage(int type) async {
    print("Called Image Picker");
    var image = await ImagePicker.pickImage(
      source: type == 1 ? ImageSource.camera : ImageSource.gallery,
    );
    
    setState(() {
      print("$image.path");
      imageFile = image;
    });
    // await retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.type == RetrieveType.image) {
          imageFile = response.file;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Editor"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            imageFile != null
                ? Image.file(
                    imageFile,
                    height: MediaQuery.of(context).size.height / 2,
                  )
                : Text("Image editor"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context).push(
          //         CupertinoPageRoute<Null>(builder: (BuildContext context) {
          //       return new MyHomePage();
          //     }));
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Add Slip"),
                content: Row(
                  children: <Widget>[
                    Expanded(
                      child: new FlatButton(
                        child: new Text("Camera"),
                        onPressed: () {
                          _getImage(1);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: new FlatButton(
                        child: new Text("Gallery"),
                        onPressed: () {
                          _getImage(2);
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
        tooltip: 'Pick Image',
        child: Icon(Icons.camera),
      ),
    );
  }
}
