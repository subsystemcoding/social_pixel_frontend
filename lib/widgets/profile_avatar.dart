import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final double radius;
  final String imageLink;
  final Uint8List imageBytes;
  const ProfileAvatar(
      {Key key, this.radius = 20, this.imageLink, this.imageBytes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var backgroundImage;
    if (imageLink != null || imageLink.isNotEmpty) {
      backgroundImage = Image.network(
        imageLink,
        fit: BoxFit.cover,
      );
    } else if (imageBytes != null || imageBytes.isNotEmpty) {
      backgroundImage = Image.memory(
        imageBytes,
        fit: BoxFit.cover,
      );
    } else {
      backgroundImage = Image.asset(
        "assets/images/default_profile.jpg",
        fit: BoxFit.cover,
      );
    }
    return CircleAvatar(
      backgroundImage: backgroundImage,
      radius: this.radius,
    );
  }
}
