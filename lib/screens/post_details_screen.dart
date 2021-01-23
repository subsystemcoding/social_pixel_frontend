import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:socialpixel/data/models/post.dart';

class PostDetailScreen extends StatefulWidget {
  final File imageFile;
  const PostDetailScreen({Key key, this.imageFile}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool addLocation;
  String caption;

  @override
  void initState() {
    addLocation = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Post"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        actions: [Text("Post")],
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image(
                image: FileImage(this.widget.imageFile),
              ),
              SizedBox(
                height: 12.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.0),
                child: Text(
                  "Caption",
                  style: Theme.of(context).primaryTextTheme.headline4,
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 28.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Write a caption...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      this.caption = value;
                    });
                  },
                ),
              ),
              ListTile(
                leading: Checkbox(
                  value: this.addLocation,
                  onChanged: (value) {
                    setState(() {
                      value = value == false;
                    });
                  },
                ),
                title: Text(
                  "Add Location",
                  style: Theme.of(context).primaryTextTheme.headline4,
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 28.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  onPressed: () {
                    BlocProvider.of<PostBloc>(context).add(
                      SendPost(
                        imageFile: this.widget.imageFile,
                        addLocation: this.addLocation,
                        caption: caption,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
