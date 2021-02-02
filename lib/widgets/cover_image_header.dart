import 'package:flutter/material.dart';

class CoverImageHeader extends StatelessWidget {
  final ImageProvider<Object> coverImage;
  final ImageProvider<Object> avatarImage;
  final double coverImageHeight;
  final double avatarImageRadius;

  const CoverImageHeader({
    Key key,
    this.coverImage,
    this.avatarImage,
    this.coverImageHeight,
    this.avatarImageRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: coverImageHeight + avatarImageRadius,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: coverImageHeight,
            child: Image(
              height: coverImageHeight,
              image: coverImage,
              fit: BoxFit.cover,
              color: Color(0x66000000),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Positioned(
            top: coverImageHeight - avatarImageRadius,
            left: 0,
            right: 0,
            height: avatarImageRadius * 2,
            child: Center(
              child: CircleAvatar(
                backgroundImage: avatarImage,
                radius: avatarImageRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
