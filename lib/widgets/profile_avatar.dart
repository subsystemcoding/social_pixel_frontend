import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final double radius;
  final String imageLink;
  final Uint8List imageBytes;
  final String username;
  const ProfileAvatar({
    Key key,
    this.radius = 20,
    this.imageLink,
    this.imageBytes,
    this.username,
  }) : super(key: key);

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
    return GestureDetector(
      child: CircleAvatar(
        backgroundImage: backgroundImage,
        radius: this.radius,
      ),
      onTap: () {
        if (this.username != null)
          Navigator.of(context).pushNamed('/profile', arguments: this.username);
      },
    );
  }
}
