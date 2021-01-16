import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/widgets/app_bar.dart';
import 'package:socialpixel/widgets/bottom_nav_bar.dart';
import 'package:socialpixel/widgets/game_widget.dart';
import 'package:socialpixel/widgets/post_widget.dart';
import 'package:socialpixel/widgets/tabbar.dart';

class ChannelScreen extends StatelessWidget {
  final ImageProvider<Object> coverImage;
  final ImageProvider<Object> avatarImage;
  final String title;
  final String description;

  const ChannelScreen({
    Key key,
    this.coverImage,
    this.avatarImage,
    this.title,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Post> posts = [];
    List<Game> games = [];
    final postBloc = BlocProvider.of<PostBloc>(context);
    postBloc.add(GetPostAndGame());
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                expandedHeight: 300,
                collapsedHeight: 260,
                //floating: true,
                //pinned: true,
                flexibleSpace: buildImages(context),
                bottom: CustomTabBar().tabBar(
                  context,
                  tabs: [
                    Text("Posts"),
                    Text("Rooms"),
                  ],
                ),
              ),
              // title: Column(
              //   children: [
              // buildImages(context),
              // buildInfo(context),
              // SizedBox(
              //   height: 12.0,
              // ),
              //   ],
              // ),
            ];
          },
          body: TabBarView(
            children: [
              buildPostSection(context),
              buildRooms(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPostSection(BuildContext context) {
    List<Game> games = [];
    List<Post> posts = [];
    return ListView(
      children: [
        Container(
          height: 250,
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is GamePostLoaded) {
                games = state.games;
              }
              return buildGames(context, games);
            },
          ),
        ),
        BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if (state is PostError)
              return Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Posts are not loaded, please check your internet connection")));
          },
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              print(state);
              if (state is PostLoaded) {
                posts = state.posts;
              }
              return buildPosts(context, posts);
            },
          ),
        ),
      ],
    );
  }

  Widget buildGames(BuildContext context, List<Game> games) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: games
          .map((game) => GameWidget(
                title: game.name,
                description: game.description,
                backgroundImage: NetworkImage(game.image),
              ))
          .toList(),
    );
  }

  Widget buildPosts(BuildContext context, List<Post> posts) {
    return Column(
      children: posts
          .map((post) => PostWidget(
                userName: post.userName,
                userAvatar: NetworkImage(post.userAvatarLink),
                datePosted: post.datePosted,
                postImage: NetworkImage(post.postImageLink),
                otherUsers: post.otherUsers
                    .map((imageLink) => NetworkImage(imageLink))
                    .toList(),
                status: post.status,
                caption: post.caption,
                gpsTag: post.gpsTag,
              ))
          .toList(),
    );
  }

  Widget buildImages(BuildContext context) {
    double radius = 50;
    double coverImageHeight = 150;
    return Container(
      height: 300,
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
            top: coverImageHeight - radius,
            left: MediaQuery.of(context).size.width / 2 - radius,
            child: CircleAvatar(
              backgroundImage: this.avatarImage,
              radius: radius,
            ),
          ),
          Positioned(
            top: coverImageHeight + radius,
            width: MediaQuery.of(context).size.width,
            child: buildInfo(context),
          ),
        ],
      ),
    );
  }

  Widget buildInfo(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 12,
        ),
        Text(
          this.title,
          style: Theme.of(context).primaryTextTheme.headline3,
        ),
        Text(this.description,
            style: Theme.of(context).primaryTextTheme.subtitle1)
      ],
    );
  }

  Widget buildRooms(context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        if (index % 2 == 0)
          return buildRoom(
            context,
            roomName: "Anas Patel",
            text: "Hello darkness my old world",
            time: "02:47",
          );
        else {
          return Container(
            margin: EdgeInsets.only(bottom: 12.0),
            child: Divider(
              indent: 92.0,
              endIndent: 16.0,
            ),
          );
        }
      },
    );
  }

  Widget buildRoom(
    BuildContext context, {
    String roomName,
    String text,
    String time,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 28),
      title: Text(roomName),
      subtitle: Text(text),
      trailing: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Text(
            time,
            style: Theme.of(context).primaryTextTheme.subtitle1,
          ),
          SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}
