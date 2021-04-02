import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/leaderboard_bloc/leaderboard_bloc.dart';
import 'package:socialpixel/data/repos/leaderboard_repository.dart';
import 'package:socialpixel/data/models/leaderboard.dart';
import 'package:socialpixel/widgets/bottom_nav_bar.dart';
import 'package:english_words/english_words.dart';
import 'package:socialpixel/widgets/profile_avatar.dart';

class LeaderboardScreen extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final ImageProvider<Object> coverImage;

  const LeaderboardScreen({
    Key key,
    this.title,
    this.description,
    this.coverImage,
    this.id,
  }) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  Leaderboard leaderboard;
  @override
  Widget build(BuildContext context) {
    //// Needs to add a valid leaderboardId
    //// Get Leaderboard Id from the game Screen
    BlocProvider.of<LeaderboardBloc>(context).add(GetLeaderboard(widget.id));
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
              image: this.widget.coverImage,
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
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(this.widget.title,
              style: Theme.of(context).primaryTextTheme.headline2),
          SizedBox(
            height: 8.0,
          ),
          Text(
            this.widget.description,
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
            child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
              builder: (context, state) {
                if (state is LeaderboardLoaded) {
                  leaderboard = state.leaderboard;
                } else if (state is LeaderboardLoading) {
                  if (leaderboard == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }

                if (leaderboard == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (leaderboard.rows.isEmpty) {
                  return _buildEmpty(context,
                      "No has played the game yet. You could be the first one to complete");
                }
                return ListView.builder(
                  padding: EdgeInsets.only(top: 12.0),
                  itemCount: leaderboard.rows.length * 2,
                  itemBuilder: (context, i) {
                    if (i % 2 == 0 || i == 0) {
                      int index = i ~/ 2;
                      return buildListTile(
                        context,
                        name: leaderboard.rows[index].user.username,
                        points: leaderboard.rows[index].points,
                        imageLink: leaderboard.rows[index].user.userAvatarImage,
                        rank: index + 1,
                      );
                    }
                    return Divider(
                      indent: 20.0,
                      endIndent: 20.0,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListTile(BuildContext context,
      {String name, int points, String imageLink, int rank}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                ProfileAvatar(
                  username: name,
                  radius: 15,
                  imageLink: imageLink,
                ),
                // CircleAvatar(
                //   backgroundImage: image,
                //   radius: 15,
                // ),
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

  Widget _buildEmpty(BuildContext context, String text) {
    return Center(
      child: Container(
        width: 300,
        margin: EdgeInsets.symmetric(vertical: 16),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
