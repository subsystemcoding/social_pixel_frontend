import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/channel_bloc/channel_bloc.dart';
import 'package:socialpixel/bloc/game_bloc/game_bloc.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/widgets/app_bar.dart';
import 'package:socialpixel/widgets/bottom_nav_bar.dart';
import 'package:socialpixel/widgets/cover_image_header.dart';
import 'package:socialpixel/widgets/custom_buttons.dart';
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
    //Getting the post and game blocs
    //final gameBloc = BlocProvider.of<GameBloc>(context);
    //getting the channel information from the bloc
    BlocProvider.of<ChannelBloc>(context).add(GetChannel(channelId));

    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: BlocBuilder<ChannelBloc, ChannelState>(
        builder: (context, state) {
          if (state is ChannelLoaded) {
            posts = state.channel.posts;
            games = state.channel.games;
            return DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder: (context, value) {
                  return [
                    //Appvar
                    SliverAppBar(
                      collapsedHeight: 170,
                      flexibleSpace: Column(
                        children: [
                          CoverImageHeader(
                            coverImage:
                                NetworkImage(state.channel.coverImageLink),
                            avatarImage:
                                NetworkImage(state.channel.avatarImageLink),
                            coverImageHeight: 150,
                            avatarImageRadius: 40,
                          ),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          buildInfo(
                            context,
                            state.channel.name,
                            state.channel.description,
                            state.channel.subscribers,
                          ),
                          CustomTabBar().tabBar(
                            context,
                            tabs: [
                              Text("Posts"),
                              Text("Rooms"),
                            ],
                          ),
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
                    buildPostSection(
                        context, state.channel.games, state.channel.posts),
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

  Widget buildPostSection(
      BuildContext context, List<Game> games, List<Post> posts) {
    return ListView(
      children: [
        games.isEmpty
            ? _buildEmpty(context, "No Games available")
            : buildGames(context, games),
        posts.isEmpty
            ? _buildEmpty(
                context, "No has posted yet, be the first one to post")
            : buildPosts(context, posts),
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
        itemCount: games.length,
        itemBuilder: (context, i) {
          final game = games[i];
          return GameWidget(
            title: game.name,
            description: game.description,
            backgroundImage: NetworkImage(game.image),
            onTap: () {
              Navigator.of(context).pushNamed('/leaderboard', arguments: {
                'id': game.gameId,
                'title': game.name,
                'description': game.description,
                'image': game.image,
              });
            },
          );
        },
      ),
    );
  }

  Widget buildPosts(BuildContext context, List<Post> posts) {
    return Column(
      children: posts
          .map((post) => PostWidget(
                post: post,
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
            child: buildInfo(context, title, description, 12),
          ),
        ],
      ),
    );
  }

  Widget buildInfo(
      BuildContext context, String title, String description, int subscribers) {
    return Column(
      children: [
        SizedBox(
          height: 12,
        ),
        Text(
          title,
          style: Theme.of(context).primaryTextTheme.headline3,
        ),
        Text(description, style: Theme.of(context).primaryTextTheme.subtitle1),
        Text('$subscribers subscribers',
            style: Theme.of(context).primaryTextTheme.subtitle1),
        CustomButtons.standardButton(
          context,
          text: "Subscribe",
          onPressed: () {},
        ),
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

  Widget _buildEmpty(BuildContext context, String text) {
    return Center(
      child: Container(
        width: 300,
        margin: EdgeInsets.symmetric(vertical: 16),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 40),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
