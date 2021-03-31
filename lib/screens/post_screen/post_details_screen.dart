import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:image/image.dart' as imageLib;
import 'package:socialpixel/data/Converter.dart';
import 'package:socialpixel/data/models/location.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:exif/exif.dart';
import 'package:socialpixel/data/repos/post_management.dart';

enum LoadLocation {
  Found,
  NotFound,
  Loading,
  NotLoading,
}

class PostDetailScreen extends StatefulWidget {
  final imageLib.Image image;
  //location of the picture
  final Location location;
  //date time when the photo was taken
  final DateTime photoDate;
  final bool isCamera;

  const PostDetailScreen({
    Key key,
    this.image,
    this.location,
    this.photoDate,
    this.isCamera,
  }) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Completer<GoogleMapController> _controller = Completer();
  String caption;
  Location foundLocation;
  DateTime foundTime;
  LoadLocation loaded;

  @override
  void initState() {
    super.initState();
    loaded = LoadLocation.NotLoading;
    caption = '';
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
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is PostSent) {
            if (state.value == PostSending.Successful) {
              _showDialog(
                context,
                title: "Successful",
                text: "Post Successfully Submitted",
              );
            } else if (state.value == PostSending.Unsuccessful) {
              _showDialog(
                context,
                title: "Unsuccessful",
                text: "Post was not submitted. Please try again",
              );
            } else if (state.value == PostSending.NoInternet) {
              _showDialog(
                context,
                title: "No Internet",
                text:
                    "No connection to internet. Post will be submitted when online",
              );
            }
          }
        },
        child: ListView(
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
                _buildAlignedText(context, "Caption"),
                SizedBox(height: 12.0),
                //text box
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
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
                SizedBox(height: 12.0),
                _buildLocation(context),
                SizedBox(
                  height: 12.0,
                ),
                _buildAddLocationButton(context),
                SizedBox(
                  height: 12.0,
                ),
                _buildButton("Post", () {
                  onPressedPostHandler(context);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(context, {String title, String text}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              GestureDetector(
                child: Text("Okay"),
                onTap: () {
                  Navigator.of(context).pushNamed('/home');
                },
              ),
            ],
          );
        });
  }

  Widget _buildAddLocationButton(BuildContext context) {
    switch (this.loaded) {
      case LoadLocation.NotLoading:
        return _buildButton("Add Location", () {
          onPressedAddLocationHandler(context);
        });
      case LoadLocation.Loading:
        return _buildButton(
          "Location Loading",
          () {},
          primaryColor: Theme.of(context).accentColor.withOpacity(0.5),
        );
      case LoadLocation.Found:
        return _buildButton("Cancel Location", () {
          onPressedCancelLocationHandler(context);
        });
      case LoadLocation.NotFound:
        return _buildButton(
          "No Location Found",
          () {},
          primaryColor: Theme.of(context).accentColor.withOpacity(0.5),
        );
      default:
        return Container();
    }
  }

  Widget _buildLocation(BuildContext context) {
    switch (this.loaded) {
      case LoadLocation.Loading:
        return Container(
          height: 300,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      case LoadLocation.Found:
        return _buildLocationWidget(context);
      default:
        return Container();
    }
  }

  Widget _buildLocationWidget(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              this.foundLocation.latitude,
              this.foundLocation.longitude,
            ),
            zoom: 17,
          ),
          markers: {
            Marker(
              markerId: MarkerId('0'),
              position: LatLng(
                this.foundLocation.latitude,
                this.foundLocation.longitude,
              ),
            ),
          },
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }

  Widget _buildAlignedText(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        text,
        style: Theme.of(context).primaryTextTheme.headline4,
      ),
    );
  }

  Widget _buildButton(String text, Function onPressed, {Color primaryColor}) {
    primaryColor = primaryColor ?? Theme.of(context).accentColor;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        onPressed: onPressed,
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
    setState(() {
      loaded = LoadLocation.Loading;
    });
    if (this.widget.photoDate != null) {
      if (this.widget.location != null) {
        //display the map`
        //display date
        this.foundLocation = this.widget.location;
        this.foundTime = this.widget.photoDate;

        setState(() {
          loaded = LoadLocation.Found;
        });
      } else {
        if (this.widget.isCamera) {
          //get coordinates
          Position position = await _determinePosition();
          this.foundLocation = Location(
            latitude: position.latitude,
            longitude: position.longitude,
          );
          //display the map
          //display date
          this.foundTime = this.widget.photoDate;
          setState(() {
            loaded = LoadLocation.Found;
          });
        } else {
          //show no location
          setState(() {
            loaded = LoadLocation.NotFound;
          });
        }
      }
    } else {
      //there is no photo date
      //add location if there is camera
      //add no location if there is no camera
      if (this.widget.isCamera) {
        //get location
        Position position = await _determinePosition();
        this.foundLocation = Location(
          latitude: position.latitude,
          longitude: position.longitude,
        );
        this.foundTime = DateTime.now();
        //display location
        //display currentDate
        setState(() {
          loaded = LoadLocation.Found;
        });
      } else {
        //show no location
        setState(() {
          loaded = LoadLocation.NotFound;
        });
      }
    }
  }

  void onPressedPostHandler(context) {
    BlocProvider.of<PostBloc>(context).add(
      SendPost(
        image: this.widget.image,
        location: this.foundLocation,
        photoDate: this.foundTime,
        caption: caption,
      ),
    );
  }

  void onPressedCancelLocationHandler(BuildContext context) {
    setState(() {
      loaded = LoadLocation.NotLoading;
    });
  }
}
