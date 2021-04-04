import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/channel_bloc/channel_bloc.dart';
import 'package:socialpixel/data/models/channel.dart';
import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/models/game.dart';
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
  bool isRoomOpen = false;
  bool isAddRoomAdded = false;

  @override
  void initState() {
    super.initState();
    coverImage = AssetImage('assets/images/grey.jpg');
    avatarImage = AssetImage('assets/images/grey.jpg');
    BlocProvider.of<ChannelBloc>(context).add(GetTemp());
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
        children: [
          CoverImageHeader(
            coverImage: coverImage,
            avatarImage: avatarImage,
            editCoverImage: true,
            editAvatarImage: true,
            coverImageHeight: 150,
            avatarImageRadius: 40,
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Channel Name",
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
              Text("Channel Description",
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
          BlocBuilder<ChannelBloc, ChannelState>(
            builder: (context, state) {
              if (state is ChannelGamesAndRooms) {
                this.games = state.games;
                this.rooms = state.rooms;
              }
              return Expanded(
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
                      ExpansionTile(
                        title: Text("Games"),
                        children: _buildGames(),
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
              );
            },
          )
        ],
      ),
    );
  }

  List<Widget> _buildGames() {
    return [
      ListTile(
        onTap: () {
          Navigator.of(context).pushNamed('/create_game');
        },
        title: Text("+ Add Game"),
      ),
    ];
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
