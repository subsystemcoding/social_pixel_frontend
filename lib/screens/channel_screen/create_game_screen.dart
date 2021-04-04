import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/channel_bloc/channel_bloc.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/mapPost.dart';
import 'package:socialpixel/data/models/post.dart';
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
  var errorMessage = '';
  var isCreatingGame = false;

  @override
  void initState() {
    super.initState();
    if (StateRepo.createGameState['imageFile'] == null) {
      coverImage = AssetImage("assets/images/grey.jpg");
    } else {
      coverImage = FileImage(StateRepo.createGameState['imageFile']);
    }

    if (StateRepo.createGameState['name'].isEmpty) {
      gameName.text = "Game Name";
    } else {
      gameName.text = StateRepo.createGameState['name'];
    }

    if (StateRepo.createGameState['desc'].isEmpty) {
      gameDescription.text = "Game Description";
    } else {
      gameDescription.text = StateRepo.createGameState['desc'];
    }
    if (StateRepo.createGameState['eligible']) {
      StateRepo.createGameState['posts'].add(
        MapPost(
          post:
              Post(postImageLink: StateRepo.createGameState['postImage'].path),
        ),
      );
      StateRepo.createGameState['postImage'] = null;
      StateRepo.createGameState['eligible'] = false;
    }
    posts = StateRepo.createGameState['posts'];
    print(posts);
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
            onTapCoverImage: () {
              StateRepo.cropState = CropState.GameImage;
              StateRepo.cropRoute = '/create_game';
              Navigator.of(context).pushNamed('/camera', arguments: {
                'route': '/crop_image',
                'isSquare': false,
              });
            },
            editCoverImage: true,
            coverImageHeight: 150,
          ),
          SizedBox(
            height: 16,
          ),
          TextField(
            textAlign: TextAlign.center,
            controller: gameName,
            style: Theme.of(context).primaryTextTheme.headline3,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: (val) {
              StateRepo.createGameState['name'] = gameName.text;
            },
          ),
          SizedBox(
            height: 12,
          ),
          TextField(
            textAlign: TextAlign.center,
            controller: gameDescription,
            style: Theme.of(context).primaryTextTheme.subtitle1,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: (val) {
              StateRepo.createGameState['desc'] = gameDescription.text;
            },
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(0.0),
              children: [
                StatefulBuilder(
                  builder: (BuildContext context, innerSetState) {
                    return ExpansionTile(
                      title: Text("Posts"),
                      children: [
                        ListTile(
                          onTap: () {
                            StateRepo.cropRoute = "/check_human";
                            StateRepo.checkHumanRoute = "/create_game";
                            StateRepo.checkLocationRoute = "/crop_image";
                            StateRepo.createGameState['eligible'] = false;
                            StateRepo.cropState = CropState.PostImage;
                            Navigator.of(context)
                                .pushNamed('/camera', arguments: {
                              'route': '/check_location',
                              'isSquare': false,
                            });
                          },
                          title: Text("+ Add Image"),
                        ),
                        _buildPosts(innerSetState),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                StatefulBuilder(
                  builder: (BuildContext context, innerSetState) {
                    return Column(
                      children: [
                        errorMessage.isEmpty
                            ? Container()
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 40.0),
                                child: Text(
                                  '• $errorMessage',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .overline,
                                ),
                              ),
                        Container(
                          width: 150,
                          alignment: Alignment.center,
                          child: CustomButtons.standardButton(
                            context,
                            text: "Add Game",
                            margin: EdgeInsets.all(0.0),
                            onPressed: () {
                              if (_createGame(innerSetState))
                                Navigator.of(context)
                                    .popAndPushNamed('/create_channel');
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPosts(void Function(void Function()) innerSetState) {
    List<MapPost> posts = StateRepo.createGameState['posts'];
    List<Widget> list = List<Widget>.from(posts.map((post) {
      return _buildPost(post, post.post.postImageLink);
    }));
    return GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.all(0.0),
      crossAxisCount: 2,
      children: list,
    );
  }

  Widget _buildPost(MapPost post, String path) {
    return Container(
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image(
              image: FileImage(File(path)),
            ),
          ),
          GestureDetector(
            onTap: () {
              posts.remove(post);
            },
            child: Container(
              child: Icon(Icons.cancel),
            ),
          ),
        ],
      ),
    );
  }

  bool _createGame(void Function(void Function()) innserSetState) {
    if (!isCreatingGame) {
      var state = StateRepo.createGameState;
      if (state['name'].isEmpty) {
        innserSetState(() {
          errorMessage = "Please add a game name";
        });
        return false;
      }
      if (state['desc'].isEmpty) {
        innserSetState(() {
          errorMessage = "Please add a game description";
        });
        return false;
      }
      if (state['imageFile'] == null) {
        innserSetState(() {
          errorMessage = "Please add an image";
        });
        return false;
      }
      if (state['posts'].isEmpty) {
        innserSetState(() {
          errorMessage = "Please add some posts";
        });
        return false;
      }
      StateRepo.createChannelState['games'].add(
        Game(
          name: state['name'],
          description: state['desc'],
          image: state['imageFile'].path,
          mapPosts: state['posts'],
        ),
      );

      return true;
    }
    return false;
  }
}
