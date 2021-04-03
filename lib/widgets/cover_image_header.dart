import 'package:flutter/material.dart';

class CoverImageHeader extends StatelessWidget {
  final ImageProvider<Object> coverImage;
  final ImageProvider<Object> avatarImage;
  final bool editCoverImage;
  final bool editAvatarImage;
  final double coverImageHeight;
  final double avatarImageRadius;

  const CoverImageHeader({
    Key key,
    this.coverImage,
    this.avatarImage,
    this.coverImageHeight,
    this.avatarImageRadius,
    this.editCoverImage = false,
    this.editAvatarImage = false,
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
          !editCoverImage
              ? null
              : Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: coverImageHeight,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 20,
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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
          !editCoverImage
              ? null
              : Positioned(
                  top: coverImageHeight - avatarImageRadius,
                  left: 0,
                  right: 0,
                  height: avatarImageRadius * 2,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 20,
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
