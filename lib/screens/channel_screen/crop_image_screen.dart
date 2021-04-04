import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socialpixel/bloc/channel_bloc/channel_bloc.dart';
import 'package:socialpixel/data/repos/state_repository.dart';

class CropImageScreen extends StatefulWidget {
  final String route;
  final String path;

  CropImageScreen({Key key, this.route = '/create_channel', this.path})
      : super(key: key);

  @override
  _CropImageScreenState createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  File imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = File(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    _cropImage(context);
    return Scaffold(
      body: Container(),
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
      imageFile = croppedFile;
    }
    StateRepo.addImageFromCrop(imageFile);
    Navigator.of(context).pushNamed(widget.route);
  }
}
