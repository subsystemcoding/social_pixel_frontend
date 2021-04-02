import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socialpixel/bloc/channel_bloc/channel_bloc.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:image/image.dart' as imageLib;
import 'package:socialpixel/bloc/tflite_bloc/tflite_bloc.dart';
import 'package:socialpixel/data/Converter.dart';
import 'package:socialpixel/data/models/channel.dart';
import 'package:socialpixel/data/models/location.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:exif/exif.dart';
import 'package:socialpixel/data/repos/post_management.dart';
import 'package:socialpixel/widgets/custom_expansion_tile.dart';
import 'package:socialpixel/widgets/search_bar.dart';

enum LoadLocation {
  Found,
  NotFound,
  Loading,
  NotLoading,
}

class PostDetailScreen extends StatefulWidget {
  final imageLib.Image image;
  final String path;
  //location of the picture
  final Location location;
  final String imagePathFromPostPreview;
  //date time when the photo was taken
  final DateTime photoDate;
  final bool isCamera;

  const PostDetailScreen({
    Key key,
    this.image,
    this.location,
    this.photoDate,
    this.isCamera,
    this.path,
    this.imagePathFromPostPreview,
  }) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Location foundLocation;
  DateTime foundTime;
  File imageFile;
  LoadLocation loaded;
  bool isVisible = true;
  bool isCapture = false;
  imageLib.Image image;
  Location location;
  DateTime date;
  bool gotInfo = false;
  ScrollController _scrollController = ScrollController();
  TextEditingController _captionController = TextEditingController();
  Channel selectedChannel;
  bool isPostSent = false;

  @override
  void initState() {
    super.initState();
    //getting an image directly mean
    //the image is from the post preview
    // else its from the camera
    if (widget.image != null) {
      isVisible = true;
      isCapture = false;
    } else if (widget.path != null) {
      isVisible = false;
      isCapture = true;
      getInfo();
      BlocProvider.of<TfliteBloc>(this.context)
          .add(CheckImageForPerson(this.imageFile));
    }
    loaded = LoadLocation.NotLoading;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            TextButton(
              child: Text("Post",
                  style: Theme.of(context).primaryTextTheme.headline3),
              onPressed: () {
                onPressedPostHandler(context);
              },
            )
          ],
        ),
        body: BlocListener<TfliteBloc, TfliteState>(
          listener: (context, state) {
            if (state is ImageChecking) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: Center(
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 12.0),
                            Text(
                              "Validating Image for humans",
                              style: Theme.of(context).textTheme.headline6,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is ImageChecked) {
              if (state.image != null) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return _buildDialog(state.image, this.context);
                  },
                );
              }
            }
          },
          child: BlocListener<PostBloc, PostState>(
            listener: (context, state) {
              if (state is PostSent) {
                Navigator.of(context).pop();
                _showDialog(context,
                    title: "Successful",
                    content: Text("Post Successfully Submitted"),
                    action: TextButton(
                      child: Text("Okay"),
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          "/home",
                          (Route<dynamic> route) => false,
                        );
                      },
                    ));
              } else if (state is PostSentError) {
                isPostSent = false;
                Navigator.of(context).pop();
                _showDialog(context,
                    title: "Unsuccessful",
                    content: Text("Post was not submitted. Please try again"),
                    action: TextButton(
                      child: Text("Okay"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ));
              } else if (state is PostSending) {
                _showDialog(
                  context,
                  title: "Sending Post",
                  content: Container(
                    height: 130,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  action: Container(
                    height: 0,
                    width: 0,
                  ),
                );
              }
            },
            child: ListView(
              controller: _scrollController,
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
                    CheckboxExpansionTile(
                      title: "Public Post",
                      isExpandedInitially: true,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 12.0),
                            _buildAlignedText(context, "Caption"),
                            SizedBox(height: 4.0),
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
                                controller: _captionController,
                                decoration: InputDecoration(
                                  hintText: 'Write a caption...',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.0),
                            SearchChannelWidget(
                              scrollController: _scrollController,
                              onChannelSelected: (channel) {
                                selectedChannel = channel;
                              },
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
                          ],
                        ),
                      ],
                    ),
                    //text box

                    // _buildButton("Post", () {
                    //   onPressedPostHandler(context);
                    // }),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void _showDialog(context, {String title, Widget content, Widget action}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text(title),
              content: content,
              actions: [
                action,
              ],
            ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            text,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.start,
          ),
        ),
      ],
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
    //Sending a post
    if (!isPostSent) {
      isPostSent = true;
      BlocProvider.of<PostBloc>(context).add(
        SendPost(
          Post(
            caption: _captionController.text,
            channel: selectedChannel,
            location: foundLocation,
          ),
          widget.imagePathFromPostPreview,
        ),
      );
    }
  }

  void onPressedCancelLocationHandler(BuildContext context) {
    setState(() {
      loaded = LoadLocation.NotLoading;
    });
  }

  void getInfo() async {
    final data = await readExifFromBytes(imageLib.encodeJpg(this.image));
    if (data.containsKey('Image DateTime')) {
      this.date = Converter.exifToDate(data);
    }
    if (data.containsKey('GPS GPSLatitude')) {
      this.location = Converter.exifToLocation(data);
    }

    setState(() {
      gotInfo = true;
    });
  }

  Widget _buildDialog(imageLib.Image image, BuildContext context) {
    Uint8List imageBytes = imageLib.encodeJpg(image);
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0),
        title: Text("Found Person"),
        content: Container(
          height: 310,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.memory(
                imageBytes,
                height: 220,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                  "It is not allowed to post a picture of any person in this app. Please take another picture.")
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              "Ok",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class SearchChannelWidget extends StatefulWidget {
  final ScrollController scrollController;
  final Function onChannelSelected;
  SearchChannelWidget({Key key, this.scrollController, this.onChannelSelected})
      : super(key: key);

  @override
  _SearchChannelWidgetState createState() => _SearchChannelWidgetState();
}

class _SearchChannelWidgetState extends State<SearchChannelWidget> {
  Channel selectedChannel;
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return _buildChannel();
  }

  Widget _buildChannel() {
    widget.onChannelSelected(selectedChannel);
    return selectedChannel == null
        ? _buildSearchChannel()
        : ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(selectedChannel.avatarImageLink),
              radius: 18,
            ),
            title: Text(selectedChannel.name,
                style: Theme.of(context).textTheme.headline6),
            trailing: TextButton(
              child: Icon(
                Icons.cancel,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                setState(() {
                  selectedChannel = null;
                });
              },
            ),
          );
  }

  Widget _buildSearchChannel() {
    List<Widget> children = [];
    return BlocBuilder<ChannelBloc, ChannelState>(
      builder: (context, state) {
        if (state is ChannelListLoaded) {
          if (state.channels.isEmpty) {
            children = [
              ListTile(
                title: Text(
                  "No channel found",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ];
          } else {
            children = List<Widget>.from(
              state.channels.map(
                (channel) => Container(
                  margin: EdgeInsets.all(1),
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        selectedChannel = channel;
                      });
                    },
                    tileColor: Colors.grey[100],
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(channel.avatarImageLink),
                      radius: 18,
                    ),
                    title: Text(
                      channel.name,
                      style: Theme.of(context).textTheme.headline6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            );
          }
        } else if (state is ChannelError) {
          children = [
            ListTile(
              tileColor: Colors.grey[100],
              title: Text(
                "No channel found",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ];
        }
        Future.delayed(Duration(milliseconds: 50), () {
          widget.scrollController.animateTo(
              widget.scrollController.position.maxScrollExtent + 30,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut);
        });
        return Column(
          children: [
            SearchBar(
              hintString: "Post to a channel",
              onChanged: () {
                if (_searchController.text.isNotEmpty) {
                  BlocProvider.of<ChannelBloc>(context)
                      .add(SearchChannel(_searchController.text));
                }
              },
              controller: _searchController,
            ),
            Container(
              constraints: BoxConstraints(maxHeight: 180, minHeight: 0),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: ListView(
                shrinkWrap: true,
                children: _searchController.text.isNotEmpty ? children : [],
              ),
            ),
          ],
        );
      },
    );
  }
}
