import 'dart:io';

import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socialpixel/data/Converter.dart';
import 'package:socialpixel/data/models/location.dart';
import 'package:image/image.dart' as imageLib;
import 'package:socialpixel/data/repos/state_repository.dart';
import 'package:socialpixel/widgets/custom_buttons.dart';

class CheckLocationScreen extends StatefulWidget {
  final bool isCamera;
  final String path;
  CheckLocationScreen({Key key, this.path, this.isCamera}) : super(key: key);

  @override
  _CheckLocationScreenState createState() => _CheckLocationScreenState();
}

class _CheckLocationScreenState extends State<CheckLocationScreen> {
  Location location;
  bool gotInfo = false;

  @override
  void initState() {
    super.initState();
    getInfo().then((_) async {
      if (widget.isCamera) {
        //print("Location found");
        if (this.location == null) {
          var position = await _determinePosition();
          this.location = Location(
            latitude: position.latitude,
            longitude: position.longitude,
          );
        }
        print("Location found");
        print(StateRepo.checkLocationRoute);
        StateRepo.createGameState['location'] = location;
        Navigator.of(context)
            .pushNamed(StateRepo.checkLocationRoute, arguments: {
          'path': widget.path,
        });
      } else {
        if (this.location == null) {
          print("Location Notfound");
          setState(() {
            gotInfo = true;
          });
        } else {
          StateRepo.createGameState['location'] = location;
          Navigator.of(context)
              .pushNamed(StateRepo.checkLocationRoute, arguments: {
            'path': widget.path,
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !gotInfo
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: Container(),
                ),
                Text(
                    "No Location Data found on the picture. Please select a picture with location data"),
                CustomButtons.standardButton(context, text: "Okay",
                    onPressed: () {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName('/create_game'));
                }),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
    );
  }

  Future<void> getInfo() async {
    print('Checking');
    final data = await readExifFromBytes(File(widget.path).readAsBytesSync());

    if (data.containsKey('GPS GPSLatitude')) {
      this.location = Converter.exifToLocation(data);
    }
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
}
