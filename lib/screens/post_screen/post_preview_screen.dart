import 'dart:io';
import 'dart:typed_data';

import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photofilters/photofilters.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as imageLib;
import 'package:socialpixel/bloc/tflite_bloc/tflite_bloc.dart';
import 'package:socialpixel/data/Converter.dart';
import 'package:socialpixel/data/models/location.dart';
import 'package:socialpixel/data/repos/tflite_repository.dart';
import 'package:socialpixel/widgets/raised_container.dart';

class PostPreviewScreen extends StatefulWidget {
  final String path;
  final bool isCamera;
  final imageLib.Image image;
  const PostPreviewScreen({Key key, this.path, this.isCamera, this.image})
      : super(key: key);

  @override
  _PostPreviewScreenState createState() => _PostPreviewScreenState();
}

class _PostPreviewScreenState extends State<PostPreviewScreen> {
  File imageFile;
  bool gotInfo;
  imageLib.Image image;
  DateTime date;
  Location location;

  @override
  void initState() {
    super.initState();
    gotInfo = false;
    if (widget.image != null) {
      image = widget.image;
      getInfo();
    } else {
      this.imageFile = File(this.widget.path);
      this.imageFile.readAsBytes().then((bytes) async {
        image = imageLib.decodeImage(bytes);
        getInfo();
        BlocProvider.of<TfliteBloc>(this.context)
            .add(CheckImageForPerson(this.imageFile));
      });

      imageFile = File(widget.path);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Upload Post')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: !gotInfo
            ? Center(
                child: CircularProgressIndicator(),
              )
            : BlocListener<TfliteBloc, TfliteState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is ImageChecked) {
                    if (state.image != null) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return _buildDialog(state.image, this.context);
                        },
                      );
                    }
                  } else if (state is ImageChecking) {
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
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width,
                      child: Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 150,
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
                                    _cropImage(context);
                                  },
                                ),
                                buildIcon(
                                  context,
                                  text: 'Filter',
                                  iconData: Icons.filter,
                                  onTap: () {
                                    _filterImage(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Container(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () => onPressedNext(context),
                              style: ElevatedButton.styleFrom(
                                primary: gotInfo
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Next",
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
                    ),
                  ],
                ),
              ));
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

  void onPressedNext(BuildContext context) async {
    if (image.height > image.width) {
      print("height > width");
      image = imageLib.copyResizeCropSquare(image, image.width);
    } else if (image.height < image.width) {
      print("height < width");
      image = imageLib.copyResizeCropSquare(image, image.height);
    }

    Map<String, dynamic> args = {
      'image': image,
      'location': location,
      'date': date,
      'isCamera': this.widget.isCamera,
      'imagePathFromPostPreview': this.widget.path,
    };
    // PostDetailScreen(
    //           image: args['image'],
    //           location: args['location'],
    //           photoDate: args['date'],
    //           isCamera: args['isCamera'],
    //         );
    Navigator.of(context).pushNamed('/post_details', arguments: args);
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

  Future<Null> _cropImage(BuildContext context) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).accentColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
          rotateButtonsHidden: false,
          resetButtonHidden: false,
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
        ));
    if (croppedFile != null) {
      setState(() {
        imageFile = croppedFile;
      });
    }
  }

  Future<void> _filterImage(BuildContext context) async {
    Map filteredImagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          title: Text("Photo Filter"),
          appBarColor: Theme.of(context).accentColor,
          image: image,
          filters: presetFiltersList,
          filename: basename(imageFile.path),
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
          circleShape: false,
        ),
      ),
    );
    if (filteredImagefile != null &&
        filteredImagefile.containsKey('image_filtered')) {
      setState(() {
        imageFile = filteredImagefile['image_filtered'];
      });
    }
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
