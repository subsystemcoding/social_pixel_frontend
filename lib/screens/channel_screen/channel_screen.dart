import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/channel_bloc/channel_bloc.dart';
import 'package:socialpixel/bloc/game_bloc/game_bloc.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/widgets/app_bar.dart';
import 'package:socialpixel/widgets/bottom_nav_bar.dart';
import 'package:socialpixel/widgets/game_widget.dart';
import 'package:socialpixel/widgets/post_widget.dart';
import 'package:socialpixel/widgets/tabbar.dart';

class ChannelScreen extends StatelessWidget {
  final int channelId;

  const ChannelScreen({
    Key key,
    this.channelId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Post> posts = [];
    List<Game> games = [];
    final postBloc = BlocProvider.of<PostBloc>(context);
    final gameBloc = BlocProvider.of<GameBloc>(context);
    BlocProvider.of<ChannelBloc>(context).add(GetChannel(channelId));
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: BlocBuilder<ChannelBloc, ChannelState>(
        builder: (context, state) {
          if (state is ChannelLoaded) {
            postBloc.add(FetchInitialPost(channelId: channelId));
            gameBloc.add(FetchGames(channelId));
            return DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder: (context, value) {
                  return [
                    SliverAppBar(
                      expandedHeight: 300,
                      collapsedHeight: 260,
                      //floating: true,
                      //pinned: true,
                      flexibleSpace: buildImages(
                        context,
                        NetworkImage(state.channel.coverImageLink),
                        NetworkImage(state.channel.avatarImageLink),
                        state.channel.name,
                        state.channel.description,
                      ),
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
            );
          } else if (state is ChannelLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget buildPostSection(BuildContext context) {
    List<Game> games = [];
    List<Post> posts = [];
    return ListView(
      children: [
        BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state is GameLoaded) {
              return state.games.isEmpty
                  ? Container()
                  : buildGames(context, state.games);
            } else if (state is GameLoading) {
              return Container(
                height: 250,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Container();
          },
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
              if (state is PostLoaded) {
                posts = state.posts;
              } else if (state is PostLoading) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return buildPosts(context, posts);
            },
          ),
        ),
      ],
    );
  }

  Widget buildGames(BuildContext context, List<Game> games) {
    return Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        ///////////////////Debug///////////////////////////
        ///Remove itemCount
        itemCount: 2,
        itemBuilder: (context, i) {
          final game = games[i];
          return GameWidget(
            title: game.name,
            description: game.description,
            backgroundImage: NetworkImage(game.image),
          );
        },
      ),
    );
  }

  Widget buildPosts(BuildContext context, List<Post> posts) {
    return Column(
      children: posts
          .map((post) => PostWidget(
                userName: post.userName,
                userAvatar: post.userAvatarLink,
                datePosted: post.datePosted,
                postImage: post.postImageLink,
                otherUsers: post.otherUsers
                    .map((user) => user.userAvatarImage)
                    .toList(),
                caption: post.caption,
                location: post.location,
              ))
          .toList(),
    );
  }

  Widget buildImages(
    BuildContext context,
    ImageProvider<Object> coverImage,
    ImageProvider<Object> avatarImage,
    String title,
    String description,
  ) {
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
              image: coverImage,
              color: Color(0x66000000),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Positioned(
            top: coverImageHeight - radius,
            left: MediaQuery.of(context).size.width / 2 - radius,
            child: CircleAvatar(
              backgroundImage: avatarImage,
              radius: radius,
            ),
          ),
          Positioned(
            top: coverImageHeight + radius,
            width: MediaQuery.of(context).size.width,
            child: buildInfo(context, title, description),
          ),
        ],
      ),
    );
  }

  Widget buildInfo(BuildContext context, String title, String description) {
    return Column(
      children: [
        SizedBox(
          height: 12,
        ),
        Text(
          title,
          style: Theme.of(context).primaryTextTheme.headline3,
        ),
        Text(description, style: Theme.of(context).primaryTextTheme.subtitle1)
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
