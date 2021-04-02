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
      // backgroundImage = NetworkImage(
      //   imageLink,
      // );
      backgroundImage = Image.network(
        imageLink,
        width: this.radius * 2,
        height: this.radius * 2,
        fit: BoxFit.cover,
      );
    } else if (!(imageBytes == null || imageBytes.isEmpty)) {
      backgroundImage = Image.memory(
        imageBytes,
        width: this.radius * 2,
        height: this.radius * 2,
        fit: BoxFit.cover,
      );
    } else {
      // backgroundImage = AssetImage(
      //   "assets/images/default_profile.jpg",
      // );
      backgroundImage = Image.asset(
        "assets/images/default_profile.jpg",
        width: this.radius * 2,
        height: this.radius * 2,
        fit: BoxFit.cover,
      );
    }
    return GestureDetector(
      child: ClipOval(
        child: backgroundImage,
      ),
      // child: CircleAvatar(
      //   backgroundImage: backgroundImage,
      //   radius: this.radius,
      // ),
      onTap: () {
        if (this.username != null)
          Navigator.of(context).pushNamed('/profile', arguments: this.username);
      },
    );
  }
}
