import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/channel_bloc/channel_bloc.dart';
import 'package:socialpixel/data/models/channel.dart';
import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/repos/state_repository.dart';
import 'package:socialpixel/widgets/cover_image_header.dart';
import 'package:socialpixel/widgets/custom_buttons.dart';

class CreateChannelScreen extends StatefulWidget {
  CreateChannelScreen({Key key}) : super(key: key);

  @override
  _CreateChannelScreenState createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  var coverImage;
  var avatarImage;
  Channel channel;
  List<Game> games = [];
  List<Chatroom> rooms = [];
  List<Widget> roomWidgets = [];
  TextEditingController _roomTextController = TextEditingController();
  TextEditingController _channelNameController = TextEditingController();
  TextEditingController _channelDescController = TextEditingController();
  bool isRoomOpen = false;
  bool isAddRoomAdded = false;

  @override
  void initState() {
    super.initState();
    if (StateRepo.createChannelState['coverImageFile'] == null) {
      coverImage = AssetImage('assets/images/grey.jpg');
    } else {
      coverImage = FileImage(StateRepo.createChannelState['coverImageFile']);
    }
    if (StateRepo.createChannelState['avatarImageFile'] == null) {
      avatarImage = AssetImage('assets/images/grey.jpg');
    } else {
      avatarImage = FileImage(StateRepo.createChannelState['avatarImageFile']);
    }
    if (StateRepo.createChannelState['name'].isEmpty) {
      _channelNameController.text = "Channel Name";
    } else {
      _channelNameController.text = StateRepo.createChannelState['name'];
    }
    if (StateRepo.createChannelState['desc'].isEmpty) {
      _channelDescController.text = "Channel Description";
    } else {
      _channelDescController.text = StateRepo.createChannelState['desc'];
    }
    rooms = StateRepo.createChannelState['rooms'];
    games = StateRepo.createChannelState['games'];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.chevron_left, color: Colors.white),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            CoverImageHeader(
              coverImage: coverImage,
              avatarImage: avatarImage,
              onTapAvatarImage: () {
                StateRepo.cropState = CropState.ChannelAvatar;
                StateRepo.cropRoute = '/create_channel';
                Navigator.of(context).pushNamed('/camera', arguments: {
                  'route': '/crop_image',
                  'isSquare': false,
                });
              },
              onTapCoverImage: () {
                StateRepo.cropState = CropState.ChannelCover;
                StateRepo.cropRoute = '/create_channel';
                Navigator.of(context).pushNamed('/camera', arguments: {
                  'route': '/crop_image',
                  'isSquare': false,
                });
              },
              editCoverImage: true,
              editAvatarImage: true,
              coverImageHeight: 150,
              avatarImageRadius: 40,
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              textAlign: TextAlign.center,
              controller: _channelNameController,
              style: Theme.of(context).primaryTextTheme.headline3,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              onChanged: (val) {
                StateRepo.createChannelState['name'] =
                    _channelNameController.text;
              },
            ),
            SizedBox(
              height: 12,
            ),
            TextField(
              textAlign: TextAlign.center,
              controller: _channelDescController,
              style: Theme.of(context).primaryTextTheme.subtitle1,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              onChanged: (val) {
                StateRepo.createChannelState['desc'] =
                    _channelDescController.text;
              },
            ),
            SizedBox(
              height: 12,
            ),
            Expanded(
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0.0),
                  children: [
                    StatefulBuilder(
                      builder: (BuildContext context, innerSetState) {
                        return ExpansionTile(
                          title: Text("Rooms"),
                          children: _buildRooms(innerSetState),
                        );
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    ExpansionTile(
                      title: Text("Moderators"),
                      children: _buildMods(),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    StatefulBuilder(
                      builder: (BuildContext context, innerSetState) {
                        return ExpansionTile(
                          title: Text("Games"),
                          children: _buildGames(innerSetState),
                        );
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: 150,
                      alignment: Alignment.center,
                      child: CustomButtons.standardButton(
                        context,
                        text: "Create Channel",
                        margin: EdgeInsets.all(0.0),
                        onPressed: () {
                          if (channel.id != null) {
                            Navigator.of(context).pushNamed(
                              "/channel",
                              arguments: channel.id,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGames(void Function(void Function()) innerSetState) {
    List<Widget> list = [
      ListTile(
        onTap: () {
          Navigator.of(context).pushNamed('/create_game');
        },
        title: Text("+ Add Game"),
      ),
    ];
    list.addAll(games.asMap().entries.map((entry) {
      var game = entry.value;
      return ListTile(
        title: Text(game.name),
        trailing: TextButton(
          child: Icon(Icons.cancel),
          onPressed: () {
            innerSetState(() {
              list.removeAt(entry.key + 1);
              this.games.remove(game);
            });
          },
        ),
      );
    }));
    return list;
  }

  List<Widget> _buildRooms(void Function(void Function()) iSetState) {
    if (!isAddRoomAdded) {
      isAddRoomAdded = true;
      roomWidgets.add(
        ListTile(
          onTap: () {
            var widget = ListTile(
              title: TextField(
                controller: _roomTextController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Room name",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onSubmitted: (val) {
                  _roomTextController.clear();
                  iSetState(() {
                    isRoomOpen = false;
                    roomWidgets.removeAt(1);
                    this.rooms.add(Chatroom(name: val));
                  });
                },
              ),
            );
            //remove set state
            if (!isRoomOpen) {
              iSetState(() {
                isRoomOpen = true;
                if (roomWidgets.length == 1) {
                  roomWidgets.add(widget);
                } else {
                  roomWidgets.insert(1, widget);
                }
              });
            }
          },
          title: Text("+ Add Room"),
        ),
      );
    }
    if (isRoomOpen) {
      roomWidgets.removeRange(2, roomWidgets.length);
    } else {
      roomWidgets.removeRange(1, roomWidgets.length);
    }

    roomWidgets.addAll(
      rooms.asMap().entries.map((entry) {
        var i = entry.key;
        var room = entry.value;
        return ListTile(
          title: Text(room.name),
          trailing: TextButton(
            child: Icon(Icons.cancel),
            onPressed: () {
              iSetState(() {
                if (isRoomOpen) {
                  roomWidgets.removeAt(i + 2);
                } else {
                  roomWidgets.removeAt(i + 1);
                }
                this.rooms.remove(room);
              });
            },
          ),
        );
      }),
    );

    return roomWidgets;
  }

  List<Widget> _buildMods() {
    return [
      ListTile(
        onTap: () {},
        title: Text("+ Add Moderators"),
      ),
    ];
  }
}
