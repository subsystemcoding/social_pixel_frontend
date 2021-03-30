import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/channel_bloc/channel_bloc.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:socialpixel/bloc/profile_bloc/profile_bloc.dart';
import 'package:socialpixel/data/models/channel.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/models/profile.dart';
import 'package:socialpixel/widgets/app_bar.dart';
import 'package:socialpixel/widgets/bottom_nav_bar.dart';
import 'package:socialpixel/widgets/custom_drawer.dart';
import 'package:socialpixel/widgets/search_bar.dart';
import 'package:socialpixel/widgets/tabbar.dart';
import 'package:tinycolor/tinycolor.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  TextEditingController textController = TextEditingController();
  List<Profile> profiles = [];
  List<Post> posts = [];
  List<Channel> channels = [];
  List<String> searchString = ['', '', ''];
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostBloc>(context).add(FetchSearchedPost());
    BlocProvider.of<ChannelBloc>(context).add(StartChannelIniital());
    BlocProvider.of<ProfileBloc>(context).add(StartProfileInitial());
    _controller = TabController(
      vsync: this,
      length: 3,
    );
    _controller.addListener(() {
      textController.text = searchString[_controller.index];
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuBar().appbar,
      drawer: CustomDrawer(),
      bottomNavigationBar: BottomNavBar(
        currentRoute: '/search',
      ),
      body: Column(
        children: [
          SearchBar(
            controller: textController,
            onSubmitted: () {
              searchString[_controller.index] = textController.text;
              if (_controller.index == 2) {
                BlocProvider.of<ChannelBloc>(context).add(
                  SearchChannel(textController.text),
                );
              } else if (_controller.index == 0) {
                BlocProvider.of<ProfileBloc>(context).add(
                  GetProfileList(textController.text),
                );
              }
            },
          ),
          CustomTabBar().tabBar(
            context,
            tabs: [
              Text("People"),
              Text("Posts"),
              Text("Channel"),
            ],
            controller: _controller,
          ),
          SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                buildPeopleSection(),
                buildPostSection(),
                buildChannelSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPeopleSection() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileListLoaded) {
          profiles = state.profiles;
        } else if (state is ProfileLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ProfileInitial) {
          return _buildWhenEmpty("Please search to explore some profiles");
        } else if (state is ChannelError) {
          profiles = [];
        }
        if (profiles.isEmpty) {
          return _buildWhenEmpty(
              "No profiles found with the name ${searchString[0]}");
        }

        return ListView.builder(
          itemCount: profiles.length * 2,
          itemBuilder: (context, i) {
            if (i % 2 == 0) {
              int index = i == 0 ? i : (i ~/ 2);
              return buildUser(
                context,
                username: profiles[index].username,
                description: profiles[index].description,
                image: NetworkImage(profiles[index].userAvatarImage),
              );
            }
            return Divider();
          },
        );
      },
    );
  }

  Widget buildPostSection() {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostLoaded) {
          posts = state.posts;
        } else if (state is PostLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: posts.length * 2,
          itemBuilder: (context, i) {
            if (i % 2 == 0) {
              int index = i == 0 ? i : (i ~/ 2);
              return buildPost(
                context,
                username: posts[index].userName,
                description: posts[index].caption,
                image: NetworkImage(posts[index].postImageLink),
              );
            }
            return Divider();
          },
        );
      },
    );
  }

  Widget buildChannelSection() {
    return BlocBuilder<ChannelBloc, ChannelState>(
      builder: (context, state) {
        if (state is ChannelListLoaded) {
          channels = state.channels;
        } else if (state is ChannelLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ChannelInitial) {
          return _buildWhenEmpty("Please search to explore some new channels");
        } else if (state is ChannelError) {
          channels = [];
        }
        if (channels.isEmpty) {
          return _buildWhenEmpty(
              "No channels found with the name ${searchString[2]}");
        }
        return ListView.builder(
          itemCount: channels.length * 2,
          itemBuilder: (context, i) {
            if (i % 2 == 0) {
              int index = i == 0 ? i : i ~/ 2;
              return buildChannel(
                context,
                channelId: channels[index].id,
                channelName: channels[index].name,
                image: NetworkImage(channels[index].avatarImageLink),
                subscribers: channels[index].subscribers.toString(),
              );
            }
            return Divider();
          },
        );
      },
    );
  }

  Widget buildUser(
    BuildContext context, {
    String username,
    String description,
    ImageProvider<Object> image,
    bool isVerified = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/profile',
          arguments: username,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 4.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: image,
              radius: 25,
            ),
            SizedBox(
              width: 12.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        username,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).primaryTextTheme.headline4,
                      ),
                      isVerified
                          ? Container(
                              margin: EdgeInsets.only(bottom: 8.0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 8.0),
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
                                    color:
                                        TinyColor(Theme.of(context).accentColor)
                                            .lighten(0)
                                            .color),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Text(
                    description,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(context).primaryTextTheme.bodyText2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPost(
    BuildContext context, {
    String username,
    String description,
    ImageProvider<Object> image,
    String datePosted,
  }) {
    return Container(
      height: 125,
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      margin: EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 90,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Theme.of(context).accentColor),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Image(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 12.0,
          ),
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).primaryTextTheme.headline4,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      description,
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).primaryTextTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Row(
                  children: [
                    Text("17.k",
                        style: Theme.of(context).primaryTextTheme.subtitle2),
                    SizedBox(
                      width: 4.0,
                    ),
                    Icon(
                      Icons.thumb_up_outlined,
                      size: 16,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text("999",
                        style: Theme.of(context).primaryTextTheme.subtitle2),
                    SizedBox(
                      width: 4.0,
                    ),
                    Icon(
                      Icons.comment_outlined,
                      size: 16,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "12 Feb 2021",
                      style: Theme.of(context).primaryTextTheme.subtitle2,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildChannel(
    BuildContext context, {
    int channelId,
    String channelName,
    ImageProvider<Object> image,
    String subscribers,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/channel', arguments: channelId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 4.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: image,
              radius: 25,
            ),
            SizedBox(
              width: 12.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    channelName,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).primaryTextTheme.headline4,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(subscribers + " subscribers",
                      style: Theme.of(context).primaryTextTheme.subtitle2),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWhenEmpty(String text) {
    return Center(
      child: Container(
        height: 150,
        width: 300,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.5),
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
