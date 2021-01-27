import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:image/image.dart' as imageLib;
import 'package:intl/intl.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:exif/exif.dart';

class PostDetailScreen extends StatefulWidget {
  final imageLib.Image image;
  //location of the picture
  final String location;
  //date time when the photo was taken
  final DateTime photoDate;
  const PostDetailScreen({
    Key key,
    this.image,
    this.location,
    this.photoDate,
  }) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  String location;
  String time;
  String caption;

  @override
  void initState() {
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
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image(
                image: MemoryImage(imageLib.encodeJpg(this.widget.image)),
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
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 28.0),
                    child: ElevatedButton(
                      onPressed: () => onPressedAddLocationHandler(context),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Add Location",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
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
                  onPressed: () => onPressedPostHandler(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  void onPressedAddLocationHandler(context) async {
    String gpsPosition = '';
    if (widget.location != '' && widget.photoDate != null) {
      // display the map

    }
    final data = await readExifFromBytes(imageLib.encodeJpg(widget.image));

    // print(data.toString());
    if (data.containsKey('GPS GPSLongitude')) {
      print("GPS exists");
      print(data['GPS GPSLongitude'].toString());
      print(data['GPS GPSLatitude'].toString());
      gpsPosition = data['GPS GPSLatitude'].toString() +
          ', ' +
          data['GPS GPSLongitude'].toString();
    } else {
      print("GPS does not exist");

      Position position = await _determinePosition();
      gpsPosition =
          position.latitude.toString() + ', ' + position.longitude.toString();
      print(position.toJson());
    }

    location = gpsPosition;
    Position position = await _determinePosition();
    gpsPosition =
        position.latitude.toString() + ', ' + position.longitude.toString();

    print(gpsPosition);
    print(data['Image DateTime'].toString());

    print(DateTime.now().toString());
  }

  void onPressedPostHandler(context) {
    BlocProvider.of<PostBloc>(context).add(
      SendPost(
        //imagePath: this.widget.imagePath,
        location: this.location,
        caption: caption,
      ),
    );
  }
}
