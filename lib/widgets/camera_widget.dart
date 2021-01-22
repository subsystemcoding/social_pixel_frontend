import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image/image.dart' as imageLib;

class CameraWidget extends StatefulWidget {
  CameraWidget({Key key}) : super(key: key);

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  int state = 0;

  void onNewCameraSelected(int index) async {
    final cameras = await availableCameras();
    final cameraDescription = cameras[index];

    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
    );

    // If the _controller is updated then update the UI.
    _controller.addListener(() {
      if (mounted) setState(() {});
    });

    _initializeControllerFuture = _controller.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    onNewCameraSelected(state);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: FutureBuilder(
            future: _initializeControllerFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        Positioned.fill(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            AspectRatio(
              aspectRatio: 1,
              child: Container(),
            ),
            Expanded(
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ]),
        ),
        Positioned(
          bottom: 50,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).accentColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                // child: ClipRRect(
                //   child: Image.network(
                //     "https://data4.origin.com/asset/content/dam/originx/web/app/programs/About/aboutorigin_3840x2160_battlefield1.jpg/27051ac9-d3c0-49e3-9979-3dc1058a69f5/original.jpg",
                //     fit: BoxFit.cover,
                //   ),
                // ),
              ),
              GestureDetector(
                onTap: () async {
                  try {
                    await _initializeControllerFuture;
                    //take the picture
                    XFile xfile = await _controller.takePicture();
                    //Fix the image rotation
                    File file =
                        await FlutterExifRotation.rotateImage(path: xfile.path);

                    var image = imageLib.decodeImage(file.readAsBytesSync());

                    image = imageLib.copyResizeCropSquare(image, image.width);

                    file.writeAsBytesSync(imageLib.encodePng(image));

                    //push
                    Navigator.of(context).pushNamed(
                      "/post_preview",
                      arguments: file.path,
                    );
                  } catch (e) {
                    print(e);
                  }
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    state = state == 0 ? 1 : 0;
                    onNewCameraSelected(state);
                  });
                },
                child: Icon(
                  Icons.flip_camera_android,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
