import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:socialpixel/bloc/geo_bloc/geo_bloc.dart';
import 'package:socialpixel/bloc/map_bloc/map_bloc.dart';
import 'package:socialpixel/bloc/profile_bloc/profile_bloc.dart';
import 'package:socialpixel/data/models/mapPost.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/models/profile.dart';
import 'package:socialpixel/widgets/app_bar.dart';
import 'package:socialpixel/widgets/map_drawer.dart';
import 'package:socialpixel/widgets/verified_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //mapcontroller for GoogleMaps
  Completer<GoogleMapController> _controller = Completer();
  //a dummy current position
  LatLng currentPosition = LatLng(29, 54);
  //profile of the user
  Profile profile;
  //markers for the map
  Set<Marker> markers = Set<Marker>();
  //streams the current position
  Stream<Position> positionStream = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      intervalDuration: Duration(seconds: 1));
  //List of checklist widgets
  List<Widget> checklist = [];
  final bottomWidgetConstant = Container();
  Widget bottomWidget = Container();
  //Text for checklist
  String checklistText = "Add to Checklist";

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GeoBloc>(context).add(GetPosition());
    BlocProvider.of<MapBloc>(context).add(GetPosts());
    BlocProvider.of<ProfileBloc>(context).add(GetProfile(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MenuBar().appbar,
      drawer: _buildDrawer(),
      onDrawerChanged: (isOpen) {
        BlocProvider.of<MapBloc>(context).add(GetPostsFromChecklist());
      },
      body: BlocListener<GeoBloc, GeoState>(
        listener: (context, state) {
          if (state is GeoPositionLoaded) {
            currentPosition =
                LatLng(state.position.latitude, state.position.longitude);
            _controller.future.then((controller) {
              controller.moveCamera(CameraUpdate.newLatLng(currentPosition));
            });
          } else if (state is GeoPositionError) {
            return ScaffoldMessengerState().showSnackBar(
              SnackBar(
                content:
                    Text("Location Error, please allow the location access."),
              ),
            );
          }
        },
        child: Stack(
          children: [
            _buildLocationWidget(context, currentPosition),
            Positioned(
              left: 18,
              top: 112,
              child: Column(
                children: [
                  _buildIcon(Icons.ac_unit),
                  _buildIcon(Icons.access_alarm_sharp),
                  _buildIcon(Icons.access_alarm_sharp),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: AnimatedContainer(
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 500),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: bottomWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationWidget(BuildContext context, LatLng position) {
    bool includeMarker = true;
    if (position == null) {
      includeMarker = false;
      position = LatLng(24.483483, 54.374130);
    }
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state is MapPostLoaded) {
          for (var mapPost in state.mapPosts) {
            final bitmap = BitmapDescriptor.fromBytes(mapPost.imagePin);

            markers.add(
              Marker(
                  markerId: MarkerId('Marker-${mapPost.post.postId}'),
                  position: LatLng(
                    mapPost.post.location.latitude,
                    mapPost.post.location.longitude,
                  ),
                  icon: bitmap,
                  onTap: () {
                    setState(() {
                      bottomWidget = _buildBottomWidget(mapPost);
                    });
                  }),
            );
          }
        }

        return Container(
          child: GoogleMap(
            onTap: (location) {
              setState(() {
                bottomWidget = bottomWidgetConstant;
              });
            },
            zoomControlsEnabled: false,
            buildingsEnabled: false,
            myLocationEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                position.latitude,
                position.longitude,
              ),
              zoom: 17,
            ),
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        );
      },
    );
  }

  Widget _buildBottomWidget(MapPost mapPost) {
    BlocProvider.of<MapBloc>(context).add(CheckPostInChecklist(mapPost));
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          )),
      child: Column(
        children: [
          _buildPost(mapPost.post.postImageBytes),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                color: Theme.of(context).accentColor,
                text: "View Post",
                onPressed: () {},
              ),
              SizedBox(
                width: 12.0,
              ),
              BlocBuilder<MapBloc, MapState>(
                builder: (context, state) {
                  if (state is MapPostInChecklist) {
                    //print("MapPostInChecklist(${state.hasPost})");
                    if (state.hasPost) {
                      checklistText = "Remove From Checklist";
                    } else {
                      checklistText = "Add to Checklist";
                    }
                  }
                  return _buildButton(
                    color: Theme.of(context).primaryColor,
                    text: checklistText,
                    onPressed: () {
                      if (checklistText.contains("Add")) {
                        BlocProvider.of<MapBloc>(context).add(
                          AddPostToChecklist(mapPost),
                        );
                      } else {
                        BlocProvider.of<MapBloc>(context).add(
                          RemovePostFromChecklist(mapPost),
                        );
                      }
                    },
                  );
                },
              )
            ],
          ),
          SizedBox(height: 12.0),
        ],
      ),
    );
  }

  Widget _buildPost(
    Uint8List imageBytes,
  ) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        child: Image.memory(
          imageBytes,
          width: width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildButton({Color color, String text, Function onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      child: Text(
        text,
        style: color == Theme.of(context).accentColor
            ? Theme.of(context).textTheme.bodyText1
            : Theme.of(context).textTheme.bodyText2,
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildIcon(IconData iconData) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: CircleAvatar(
        child: Icon(
          iconData,
          size: 32,
          color: Theme.of(context).accentColor,
        ),
        backgroundColor: Colors.transparent,
        radius: 24,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).accentColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  Widget _buildDrawer() {
    return MapDrawer(
      children: [
        ListTile(
          title: Text(
            "Back to Home",
            style: Theme.of(context).primaryTextTheme.bodyText2,
          ),
        ),
        BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            if (state is MapPostInChecklistLoaded) {
              print("MapPostInChecklistLoaded");
              checklist = state.mapPosts.map((mapPost) {
                return _buildChecklistItem(mapPost);
              }).toList();
            }
            return ExpansionTile(
              title: Text(
                "Checklist",
                style: Theme.of(context).primaryTextTheme.bodyText2,
              ),
              children: checklist,
            );
          },
        ),
      ],
    );
    // return Drawer(
    //   child: BlocBuilder<ProfileBloc, ProfileState>(
    //     builder: (context, state) {
    //       if (state is ProfileLoaded) {
    //         BlocProvider.of<MapBloc>(context).add(GetPostsFromChecklist());
    //         profile = state.profile;
    //       }
    //       return profile == null
    //           ? Container()
    //           : ListView(
    //               children: [
    //                 DrawerHeader(
    //                   decoration: BoxDecoration(
    //                     color: Theme.of(context).accentColor,
    //                   ),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.stretch,
    //                     children: [
    //                       Container(
    //                         height: 60,
    //                         child: CircleAvatar(
    //                           backgroundImage: (profile.userImageBytes != null)
    //                               ? MemoryImage(profile.userImageBytes)
    //                               : NetworkImage(profile.userAvatarImage),
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         height: 8.0,
    //                       ),
    //                       profile.isVerified
    //                           ? Row(
    //                               mainAxisAlignment: MainAxisAlignment.center,
    //                               children: [
    //                                 Text(
    //                                   profile.username,
    //                                   style:
    //                                       Theme.of(context).textTheme.bodyText1,
    //                                 ),
    //                                 SizedBox(
    //                                   height: 8.0,
    //                                 ),
    //                                 VerifiedWidget(),
    //                               ],
    //                             )
    //                           : Center(
    //                               child: Text(
    //                                 profile.username,
    //                                 style:
    //                                     Theme.of(context).textTheme.bodyText1,
    //                               ),
    //                             ),
    //                       SizedBox(
    //                         height: 8.0,
    //                       ),
    //                       Center(
    //                         child: Text(
    //                           '${profile.points} points • ${profile.followers} followers',
    //                           style: Theme.of(context).textTheme.bodyText1,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    // ListTile(
    //   title: Text(
    //     "Back to Home",
    //     style: Theme.of(context).primaryTextTheme.bodyText2,
    //   ),
    // ),
    // BlocBuilder<MapBloc, MapState>(
    //   builder: (context, state) {
    //     if (state is MapPostInChecklistLoaded) {
    //       print("MapPostInChecklistLoaded");
    //       checklist = state.mapPosts.map((mapPost) {
    //         return _buildChecklistItem(mapPost);
    //       }).toList();
    //     }
    //     return ExpansionTile(
    //       title: Text(
    //         "Checklist",
    //         style: Theme.of(context).primaryTextTheme.bodyText2,
    //       ),
    //       children: checklist,
    //     );
    //   },
    // ),
    //               ],
    //             );
    //     },
    //   ),
    // );
  }

  Widget _buildChecklistItem(MapPost mapPost) {
    return ListTile(
      title: Text(
        "Post-${mapPost.post.postId}",
        style: Theme.of(context).primaryTextTheme.bodyText2,
      ),
      onTap: () {
        _controller.future.then((controller) {
          controller.moveCamera(
            CameraUpdate.newLatLngZoom(
                LatLng(
                  mapPost.post.location.latitude,
                  mapPost.post.location.longitude,
                ),
                17),
          );
        });

        Navigator.pop(context);
        setState(() {
          bottomWidget = _buildBottomWidget(mapPost);
        });
      },
    );
  }
}
