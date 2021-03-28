import 'package:flutter/material.dart';

import 'package:socialpixel/widgets/camera_widget.dart';

class CameraScreen extends StatelessWidget {
  final String route;
  final bool isSquare;
  const CameraScreen({
    Key key,
    this.route,
    this.isSquare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CameraWidget(
        route: this.route,
        isSquare: this.isSquare,
      ),
    );
  }
}
