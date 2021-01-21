import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PostPreviewScreen extends StatelessWidget {
  final String imagePath;
  const PostPreviewScreen({Key key, this.imagePath}) : super(key: key);

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
              File(this.imagePath),
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

  Widget buildIcon(context, {String text, IconData iconData}) {
    return Padding(
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
    );
  }
}
