import 'dart:math';

import 'package:flutter/material.dart';
import 'package:socialpixel/data/repos/leaderboard_repository.dart';
import 'package:socialpixel/data/models/leaderboard.dart';
import 'package:socialpixel/widgets/bottom_nav_bar.dart';
import 'package:english_words/english_words.dart';

class LeaderboardScreen extends StatelessWidget {
  final String title;
  final String description;
  final ImageProvider<Object> coverImage;

  const LeaderboardScreen({
    Key key,
    this.title,
    this.description,
    this.coverImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: Column(
        children: [
          buildImages(context),
          SizedBox(
            height: 20.0,
          ),
          buildInfo(context),
          SizedBox(
            height: 12.0,
          ),
          buildLeaderboard(context),
        ],
      ),
    );
  }

  Widget buildImages(BuildContext context) {
    double coverImageHeight = 150;
    return Container(
      height: coverImageHeight,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Image(
              height: coverImageHeight,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              image: this.coverImage,
              color: Color(0x66000000),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(this.title, style: Theme.of(context).primaryTextTheme.headline2),
          SizedBox(
            height: 8.0,
          ),
          Text(
            this.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.subtitle1,
          ),
          SizedBox(
            height: 8.0,
          ),
          buildButton(context, "Subscribe"),
        ],
      ),
    );
  }

  Widget buildButton(
    BuildContext context,
    String text,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).accentColor,
          textStyle: Theme.of(context).primaryTextTheme.headline4,
          minimumSize: Size(100, 0),
          //padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Text(
          text,
        ),
      ),
    );
  }

  Widget buildLeaderboard(BuildContext context) {
    var exampleLeaderboard = LeaderboardRepository().fetchLeaderboardSync();
    return Expanded(
      child: Column(
        children: [
          Text("Leaderboards",
              style: Theme.of(context).primaryTextTheme.headline3),
          SizedBox(
            height: 12.0,
          ),
          Divider(
            indent: 16.0,
            endIndent: 16.0,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 12.0),
              itemCount: exampleLeaderboard.rows.length * 2,
              itemBuilder: (context, i) {
                if (i % 2 == 0 || i == 0) {
                  int index = (i / 2).toInt();
                  return buildListTile(
                    context,
                    name: exampleLeaderboard.rows[index].userName,
                    points: exampleLeaderboard.rows[index].points,
                    image:
                        NetworkImage(exampleLeaderboard.rows[index].userAvatar),
                    rank: index + 1,
                  );
                }
                return Divider(
                  indent: 28.0,
                  endIndent: 28.0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListTile(BuildContext context,
      {String name, int points, ImageProvider<Object> image, int rank}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24.0,
            child: Text(rank.toString()),
          ),
          SizedBox(width: 12.0),
          Container(
            width: 200,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: image,
                  radius: 15,
                ),
                SizedBox(
                  width: 12.0,
                ),
                Text(
                  name,
                  style: Theme.of(context).primaryTextTheme.bodyText2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 12.0,
          ),
          Container(
            width: 36,
            child: Text(
              points.toString(),
              style: Theme.of(context).primaryTextTheme.bodyText2,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
