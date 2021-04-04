import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/channel_bloc/channel_bloc.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/mapPost.dart';
import 'package:socialpixel/data/repos/state_repository.dart';
import 'package:socialpixel/widgets/cover_image_header.dart';
import 'package:socialpixel/widgets/custom_buttons.dart';

class CreateGameScreen extends StatefulWidget {
  CreateGameScreen({Key key}) : super(key: key);

  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  var coverImage;
  var gameName = TextEditingController();
  var gameDescription = TextEditingController();
  var posts = List<MapPost>();

  @override
  void initState() {
    super.initState();
    coverImage = AssetImage("assets/images/grey.jpg");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CoverImageHeader(
            coverImage: coverImage,
            editCoverImage: true,
            coverImageHeight: 150,
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Game Name",
                style: Theme.of(context).primaryTextTheme.headline3,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Game Description",
                  style: Theme.of(context).primaryTextTheme.subtitle1),
              Container(
                height: 10,
                margin: EdgeInsets.only(bottom: 20),
                child: Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(0.0),
              children: [
                ExpansionTile(
                  title: Text("Posts"),
                  children: [],
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  width: 150,
                  alignment: Alignment.center,
                  child: CustomButtons.standardButton(
                    context,
                    text: "Add Game",
                    margin: EdgeInsets.all(0.0),
                    onPressed: () {
                      StateRepo.createChannelState['games'].add(Game());
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
