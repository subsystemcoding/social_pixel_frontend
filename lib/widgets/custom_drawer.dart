import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/profile_bloc/profile_bloc.dart';
import 'package:socialpixel/data/models/profile.dart';
import 'package:socialpixel/data/repos/auth_repository.dart';
import 'package:socialpixel/widgets/profile_avatar.dart';
import 'package:socialpixel/widgets/verified_widget.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Profile profile;
    BlocProvider.of<ProfileBloc>(context).add(GetCurrentProfile());
    return Drawer(
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            print("Profile Loaded");
            profile = state.profile;
          }
          print(state);
          return profile == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/profile');
                      },
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              height: 60,
                              child: Center(
                                child: ProfileAvatar(
                                  username: profile.username,
                                  radius: 25,
                                  imageBytes: profile.userImageBytes,
                                  imageLink: profile.userAvatarImage,
                                ),
                              ),
                              // child: CircleAvatar(
                              //   backgroundImage:
                              //       (profile.userImageBytes != null)
                              //           ? MemoryImage(profile.userImageBytes)
                              //           : NetworkImage(profile.userAvatarImage),
                              // ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            profile.isVerified
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        profile.username,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      VerifiedWidget(),
                                    ],
                                  )
                                : Center(
                                    child: Text(
                                      profile.username,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Center(
                              child: Text(
                                '${profile.points} points • ${profile.followers} followers',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ListTile(
                    //   onTap: () {
                    //     Navigator.of(context).pushNamed('/map');
                    //   },
                    //   title: Text(
                    //     "Switch to Map",
                    //     style: Theme.of(context).primaryTextTheme.bodyText2,
                    //   ),
                    // ),
                    // Divider(),
                    ExpansionTile(
                      title: Text(
                        "Subscribed Channels",
                        style: Theme.of(context).primaryTextTheme.bodyText2,
                      ),
                      children: _getSubscribedChannels(context, profile),
                    ),
                    ExpansionTile(
                      title: Text(
                        "Channel Mods",
                        style: Theme.of(context).primaryTextTheme.bodyText2,
                      ),
                      children: _getChannelMods(context, profile),
                    ),
                    ListTile(
                      title: Text(
                        "Sign Out",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      onTap: () {
                        AuthRepository().clearAuth();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("/", (route) => false);
                      },
                    ),
                  ],
                );
        },
      ),
    );
  }

  List<Widget> _getChannelMods(BuildContext context, Profile profile) {
    List<Widget> children = [];
    return [
      ListTile(
        onTap: () {
          Navigator.of(context).pushNamed("/create_channel");
        },
        title: Text("+ Create Channel",
            style: Theme.of(context).textTheme.headline6),
      )
    ];
  }

  List<Widget> _getSubscribedChannels(BuildContext context, Profile profile) {
    List<Widget> children = [];
    if (!(profile.subscribedChannels == null ||
        profile.subscribedChannels.isEmpty)) {
      for (int i = 0; i < profile.subscribedChannels.length; i++) {
        children.add(ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(
              "/channel",
              arguments: profile.subscribedChannels[i].id,
            );
          },
          title: Text(
            profile.subscribedChannels[i].name,
            style: Theme.of(context).textTheme.headline6,
          ),
          leading: ProfileAvatar(
            radius: 20,
            imageLink: profile.subscribedChannels[i].avatarImageLink,
          ),
        ));
      }
    } else {
      children.add(ListTile(
        title: Text("No channels"),
      ));
    }
    return children;
  }
}
