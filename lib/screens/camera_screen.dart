import 'package:flutter/material.dart';
import 'package:socialpixel/widgets/camera_widget.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CameraWidget(),
    );
  }
}
