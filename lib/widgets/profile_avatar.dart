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
    if (!(imageLink == null || imageLink.isEmpty)) {
      print("image link found and printing");
      print(imageLink);
      backgroundImage = NetworkImage(
        imageLink,
      );
    } else if (!(imageBytes == null || imageBytes.isEmpty)) {
      backgroundImage = MemoryImage(
        imageBytes,
      );
    } else {
      print("using default Image");
      backgroundImage = AssetImage(
        "assets/images/default_profile.jpg",
      );
    }
    return CircleAvatar(
      backgroundImage: backgroundImage,
      radius: this.radius,
    );
  }
}
