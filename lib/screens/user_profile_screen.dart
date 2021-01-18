import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/profile_bloc/profile_bloc.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:tinycolor/tinycolor.dart';

class UserProfileScreen extends StatelessWidget {
  final int userId;
  const UserProfileScreen({
    Key key,
    this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProfileBloc>(context).add(GetProfile(userId));
    return Container(
      child: Scaffold(
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return Center(
                child: NestedScrollView(
                  headerSliverBuilder: (context, bool) {
                    return [
                      SliverAppBar(
                        expandedHeight: 200,
                        flexibleSpace: buildImages(
                          context,
                          state.profile.userCoverImage,
                          state.profile.userAvatarImage,
                        ),
                      ),
                    ];
                  },
                  body: Column(
                    children: [
                      buildInfo(
                        context,
                        state.profile.username,
                        state.profile.isVerified,
                        state.profile.points.toString(),
                        state.profile.followers.toString(),
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      buildButtons(context, userId == 12),
                      SizedBox(
                        height: 12.0,
                      ),
                      buildPosts(context),
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
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
              image: NetworkImage(coverImage),
              color: Color(0x66000000),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Positioned(
            top: coverImageHeight - radius,
            left: MediaQuery.of(context).size.width / 2 - radius,
            child: CircleAvatar(
              backgroundImage: NetworkImage(avatarImage),
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
    bool isVerified,
    String points,
    String followers,
  ) {
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
            isVerified
                ? Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: TinyColor(Theme.of(context).accentColor)
                          .lighten(35)
                          .color,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      "Verified",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: TinyColor(Theme.of(context).accentColor)
                              .lighten(0)
                              .color),
                    ),
                  )
                : Container(),
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
            buildButton(context, "Follow"),
            buildButton(context, "Message"),
            buildButton(context, "Stats"),
          ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        children: buttons,
      ),
    );
  }

  Widget buildButton(BuildContext context, String text,
      {Color primaryColor, Color backgroundColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: TextButton(
        onPressed: () {},
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
    BlocProvider.of<PostBloc>(context).add(GetPost());
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Pictures Posted",
            style: Theme.of(context).primaryTextTheme.headline4,
          ),
          SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is PostLoaded) {
                  print(state);
                  posts = state.posts
                      .map((post) =>
                          buildPostImage(NetworkImage(post.postImageLink)))
                      .toList();
                } else if (state is PostLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  children: posts,
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildPostsRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildPostImage(
          NetworkImage(
              "https://i.pinimg.com/originals/5b/b4/8b/5bb48b07fa6e3840bb3afa2bc821b882.jpg"),
        ),
        buildPostImage(
          NetworkImage(
              "https://i.pinimg.com/originals/5b/b4/8b/5bb48b07fa6e3840bb3afa2bc821b882.jpg"),
        ),
        buildPostImage(
          NetworkImage(
              "https://i.pinimg.com/originals/5b/b4/8b/5bb48b07fa6e3840bb3afa2bc821b882.jpg"),
        ),
      ],
    );
  }

  Widget buildPostImage(ImageProvider<Object> image) {
    return GridTile(
      child: Image(
        fit: BoxFit.cover,
        image: image,
      ),
    );
  }
}
