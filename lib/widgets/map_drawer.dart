import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/profile_bloc/profile_bloc.dart';
import 'package:socialpixel/data/models/profile.dart';
import 'package:socialpixel/widgets/profile_avatar.dart';
import 'package:socialpixel/widgets/verified_widget.dart';

class MapDrawer extends StatelessWidget {
  final List<Widget> children;
  final Function initial;
  MapDrawer({Key key, this.children, this.initial}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Profile profile;
    initial();
    return Drawer(
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            profile = state.profile;
          }
          return profile == null
              ? Container()
              : _buildDrawerList(context, profile);
        },
      ),
    );
  }

  Widget _buildDrawerList(context, profile) {
    List<Widget> children = [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 60,
              child: ProfileAvatar(
                username: profile.username,
                radius: 30,
                imageLink: profile.userAvatarImage,
                imageBytes: profile.userImageBytes,
              ),
              // child: CircleAvatar(
              //   backgroundImage: (profile.userImageBytes != null)
              //       ? MemoryImage(profile.userImageBytes)
              //       : NetworkImage(profile.userAvatarImage),
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
                        style: Theme.of(context).textTheme.bodyText1,
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
                      style: Theme.of(context).textTheme.bodyText1,
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
    ];

    children.addAll(this.children);

    return ListView(children: children);
  }
}
