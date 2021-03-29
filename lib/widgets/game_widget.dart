import 'package:flutter/material.dart';

class GameWidget extends StatelessWidget {
  final int gameId;
  final String title;
  final String description;
  final ImageProvider<Object> backgroundImage;
  final Function onTap;
  const GameWidget(
      {Key key,
      this.gameId,
      this.title,
      this.description,
      this.backgroundImage,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(28.0),
        child: Stack(
          children: [buildImage(context), buildInfo(context)],
        ),
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: OverflowBox(
        maxHeight: double.infinity,
        child: Image(
          image: this.backgroundImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Widget buildInfo(BuildContext context, double padding) {
  //   return Positioned(
  //     bottom: 0,
  //     height: 60,
  //     width: MediaQuery.of(context).size.width - (padding * 2),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 16.0),
  //       decoration: BoxDecoration(
  //         color: Color(0xaa000000),
  //         borderRadius: BorderRadius.vertical(
  //           bottom: Radius.circular(25.0),
  //         ),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             title,
  //             style: TextStyle(color: Colors.white),
  //           ),
  //           Divider(
  //             color: Colors.white,
  //           ),
  //           Text(
  //             description,
  //             overflow: TextOverflow.ellipsis,
  //             style: TextStyle(color: Colors.white),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget buildInfo(BuildContext context) {
    return OverflowBox(
      alignment: Alignment.bottomLeft,
      maxHeight: 70,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Color(0xaa000000),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
            Divider(
              color: Colors.white,
            ),
            Text(
              description,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
