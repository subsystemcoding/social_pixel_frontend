import 'package:flutter/material.dart';
import 'package:socialpixel/widgets/cover_image_header.dart';

class CreateChannelScreen extends StatefulWidget {
  CreateChannelScreen({Key key}) : super(key: key);

  @override
  _CreateChannelScreenState createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  var coverImage;
  var avatarImage;

  @override
  void initState() {
    super.initState();
    coverImage = AssetImage('assets/images/grey.jpg');
    avatarImage = AssetImage('assets/images/grey.jpg');
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
          ExpansionTile(
            title: Text("Rooms"),
            children: _buildRooms(),
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
        ],
      ),
    );
  }

  List<Widget> _buildGames() {
    return [
      ListTile(
        onTap: () {},
        title: Text("+ Add Game"),
      ),
    ];
  }

  List<Widget> _buildRooms() {
    return [
      ListTile(
        onTap: () {},
        title: Text("+ Add Room"),
      ),
    ];
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
