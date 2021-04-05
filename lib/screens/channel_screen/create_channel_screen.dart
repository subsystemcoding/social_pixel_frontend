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
  String errorMessage = '';
  bool isCreatingChannel = false;

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
    return BlocListener<ChannelBloc, ChannelState>(listener: (context, state) {
      if (state is ChannelCreated) {
        Navigator.of(context).pushNamed('/channel', arguments: state.channelId);
      }
    }, child: BlocBuilder<ChannelBloc, ChannelState>(
      builder: (context, state) {
        print(state);
        if (state is ChannelLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is ChannelError) {
          errorMessage = "A channel with the same name exists";
        }
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
                    StateRepo.goBackRoute = '/create_channel';
                    StateRepo.cropRoute = '/create_channel';
                    Navigator.of(context).pushNamed('/camera', arguments: {
                      'route': '/crop_image',
                      'isSquare': false,
                    }).then((_) {
                      setState(() {});
                    });
                  },
                  onTapCoverImage: () {
                    StateRepo.cropState = CropState.ChannelCover;
                    StateRepo.goBackRoute = '/create_channel';
                    StateRepo.cropRoute = '/create_channel';
                    Navigator.of(context).pushNamed('/camera', arguments: {
                      'route': '/crop_image',
                      'isSquare': false,
                    }).then((_) {
                      setState(() {});
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
                                        )),
                                Container(
                                  width: 150,
                                  alignment: Alignment.center,
                                  child: CustomButtons.standardButton(
                                    context,
                                    text: "Create Channel",
                                    margin: EdgeInsets.all(0.0),
                                    onPressed: () {
                                      _createChannel(innerSetState);
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
                ),
              ],
            ),
          ),
        );
      },
    ));
  }

  List<Widget> _buildGames(void Function(void Function()) innerSetState) {
    List<Widget> list = [
      ListTile(
        onTap: () {
          Navigator.of(context).pushNamed('/create_game').then((_) {
            setState(() {});
          });
        },
        title: Text("+ Add Game"),
      ),
    ];
    list.addAll(games.asMap().entries.map((entry) {
      var game = entry.value;
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: FileImage(File(game.image)),
        ),
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

  //after if statements and assigning error message
  // display the error message above the create channel button
  // if there are no error message proceed to call the event create channel
  // check the bloc and  the repo
  // test run
  bool _createChannel(void Function(void Function()) innserSetState) {
    if (!isCreatingChannel) {
      var state = StateRepo.createChannelState;
      if (state['name'].isEmpty) {
        innserSetState(() {
          errorMessage = "Please add a channel name";
        });
        return false;
      }
      if (state['desc'].isEmpty) {
        innserSetState(() {
          errorMessage = "Please add a channel description";
        });
        return false;
      }
      if (state['coverImageFile'] == null) {
        innserSetState(() {
          errorMessage = "Please add a cover image";
        });
        return false;
      }
      if (state['avatarImageFile'] == null) {
        innserSetState(() {
          errorMessage = "Please add a profile image";
        });
        return false;
      }
      BlocProvider.of<ChannelBloc>(context).add(CreateChannel(
        Channel(
          name: state['name'],
          description: state['desc'],
          coverImageLink: state['coverImageFile'].path,
          avatarImageLink: state['avatarImageFile'].path,
        ),
        rooms,
        games,
      ));

      return true;
    }
    return false;
  }
}
