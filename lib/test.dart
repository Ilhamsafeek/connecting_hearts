import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_modern/image_picker_modern.dart';
import 'package:zamzam/ui/screens/test_screen.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  File imageFile;

  Future _getImage(int type) async {
    print("Called Image Picker");
    await ImagePicker.pickImage(
      source: type == 1 ? ImageSource.camera : ImageSource.gallery,
    ).then((image) {
      setState(() {
        print("========================>>>>>>>>>>>Set State");
        imageFile = image;
      });
    });
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
          
            Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new MyHomePage();
                }));
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return AlertDialog(
          //       title: new Text("Picker"),
          //       content: new Text("Select image picker type."),
          //       actions: <Widget>[
          //         new FlatButton(
          //           child: new Text("Camera"),
          //           onPressed: () {
          //             _getImage(1);
          //             Navigator.pop(context);
          //           },
          //         ),
          //         new FlatButton(
          //           child: new Text("Gallery"),
          //           onPressed: () {
          //             _getImage(2);
          //             Navigator.pop(context);
          //           },
          //         ),
          //       ],
          //     );
          //   },
          // );
        
        },
        tooltip: 'Pick Image',
        child: Icon(Icons.camera),
      ),
    );
  }
}
