import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_cropper/image_cropper.dart';

class PostPreviewScreen extends StatefulWidget {
  final String path;
  const PostPreviewScreen({Key key, this.path}) : super(key: key);

  @override
  _PostPreviewScreenState createState() => _PostPreviewScreenState();
}

class _PostPreviewScreenState extends State<PostPreviewScreen> {
  File imageFile;

  @override
  void initState() {
    imageFile = File(widget.path);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Post')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Image.file(
              imageFile,
              fit: BoxFit.scaleDown,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                scrollDirection: Axis.horizontal,
                children: [
                  buildIcon(
                    context,
                    text: 'Crop',
                    iconData: Icons.crop,
                    onTap: () {
                      _cropImage();
                    },
                  ),
                  buildIcon(
                    context,
                    text: 'Filter',
                    iconData: Icons.filter,
                  ),
                  buildIcon(
                    context,
                    text: 'Home',
                    iconData: Icons.home,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIcon(context,
      {String text, IconData iconData, Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: Theme.of(context).primaryTextTheme.bodyText1,
            ),
            SizedBox(
              height: 4.0,
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border.all(
                    width: 2,
                    color: Theme.of(context).accentColor,
                  ),
                  borderRadius: BorderRadius.circular(25.0)),
              child: Icon(
                iconData,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).accentColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      setState(() {
        imageFile = croppedFile;
      });
    }
  }
}
