import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/profile_bloc/profile_bloc.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/models/profile.dart';
import 'package:socialpixel/widgets/verified_widget.dart';
import 'package:tinycolor/tinycolor.dart';

class UserProfileScreen extends StatefulWidget {
  final String username;
  const UserProfileScreen({
    Key key,
    this.username,
  }) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isUser = false;
  Profile profile;

  @override
  Widget build(BuildContext context) {
    if (widget.username == null) {
      BlocProvider.of<ProfileBloc>(context).add(GetCurrentProfile());
      isUser = true;
    }
    BlocProvider.of<ProfileBloc>(context).add(GetProfile(widget.username));
    return Container(
      child: Scaffold(
          body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is MessageUserSuccess) {
            Navigator.of(context).pushNamed(
              '/message',
              arguments: Chatroom(
                  id: state.chatroomId,
                  name: profile.username,
                  userImage: profile.userAvatarImage),
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              profile = state.profile;
            } else if (state is ProfileLoading) {
              if (profile == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            } else if (state is UserFollowed) {}
            if (profile == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    flexibleSpace: buildImages(
                      context,
                      profile.userCoverImage,
                      profile.userAvatarImage,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      buildInfo(
                        context,
                        profile.username,
                        profile.points.toString(),
                        profile.followers.toString(),
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      buildButtons(context, isUser),
                      SizedBox(
                        height: 12.0,
                      ),
                      buildPosts(context),
                    ]),
                  ),
                ],

                // body: Column(
                //   children: [

                //   ],
                // ),
              ),
            );
          },
        ),
      )),
    );
  }

  Widget buildImages(
      BuildContext context, String coverImage, String avatarImage) {
    double radius = 50;
    double coverImageHeight = 150;
    return Container(
      height: 200,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Image(
              height: coverImageHeight,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              image: coverImage != null
                  ? NetworkImage(coverImage)
                  : AssetImage("assets/images/grey.jpg"),
              color: Color(0x66000000),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Positioned(
            top: coverImageHeight - radius,
            left: MediaQuery.of(context).size.width / 2 - radius,
            child: CircleAvatar(
              backgroundImage: avatarImage != null && avatarImage.isNotEmpty
                  ? NetworkImage(avatarImage)
                  : AssetImage("assets/images/default_profile.jpg"),
              radius: radius,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfo(
    BuildContext context,
    String username,
    String points,
    String followers, {
    bool isVerified = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              username,
              style: Theme.of(context).primaryTextTheme.headline3,
            ),
            SizedBox(
              width: isVerified ? 16 : 0,
            ),
            isVerified ? VerifiedWidget() : Container(),
          ],
        ),
        SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(points, style: Theme.of(context).primaryTextTheme.headline4),
            Text(" points • ",
                style: Theme.of(context).primaryTextTheme.subtitle2),
            Text(followers,
                style: Theme.of(context).primaryTextTheme.headline4),
            Text(" followers",
                style: Theme.of(context).primaryTextTheme.subtitle2),
          ],
        ),
      ],
    );
  }

  Widget buildButtons(BuildContext context, bool isUser) {
    List<Widget> buttons = isUser
        ? [
            buildButton(
              context,
              "Edit Profile",
              primaryColor:
                  TinyColor(Theme.of(context).accentColor).lighten(10).color,
              backgroundColor:
                  TinyColor(Theme.of(context).accentColor).lighten(38).color,
            ),
            buildButton(context, "Stats"),
          ]
        : [
            buildButton(
              context,
              this.profile.isFollowing ? "Unfollow" : "Follow",
              onPressed: () {
                BlocProvider.of<ProfileBloc>(context)
                    .add(FollowUser(this.profile));
              },
              primaryColor: this.profile.isFollowing
                  ? Theme.of(context).accentColor
                  : null,
              backgroundColor: this.profile.isFollowing
                  ? Theme.of(context).disabledColor
                  : null,
            ),
            buildButton(context, "Message",
                primaryColor: Theme.of(context).primaryColor, onPressed: () {
              BlocProvider.of<ProfileBloc>(context)
                  .add(MessageUser(this.profile));
            }),
            buildButton(context, "Stats",
                primaryColor: Theme.of(context).primaryColor, onPressed: () {}),
          ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        children: buttons,
      ),
    );
  }

  Widget buildButton(BuildContext context, String text,
      {Color primaryColor, Color backgroundColor, Function onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          primary: primaryColor ?? Theme.of(context).primaryColor,
          backgroundColor: backgroundColor ?? Theme.of(context).accentColor,
          textStyle: Theme.of(context).primaryTextTheme.subtitle1,
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

  Widget buildPosts(context) {
    List<Widget> posts = [];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Pictures Posted",
          style: Theme.of(context).primaryTextTheme.headline4,
        ),
        SizedBox(
          height: 8.0,
        ),
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
          children:
              profile.postsMade.map((post) => buildPostImage(post)).toList(),
        ),
      ]),
    );
  }

  Widget buildPostImage(Post post) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/post_widget', arguments: post);
      },
      child: GridTile(
        child: Image(
          fit: BoxFit.cover,
          image: NetworkImage(post.postImageLink),
        ),
      ),
    );
  }
}
