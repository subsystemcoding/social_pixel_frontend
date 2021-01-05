import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/widgets/app_bar.dart';
import 'package:socialpixel/widgets/bottom_nav_bar.dart';
import 'package:socialpixel/widgets/post_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postBloc = BlocProvider.of<PostBloc>(context);
    postBloc.add(GetPost());
    return Scaffold(
      appBar: MenuBar().appbar,
      bottomNavigationBar: BottomNavBar(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 28.0),
              child: Text(
                "Home",
                textAlign: TextAlign.left,
                style: Theme.of(context).primaryTextTheme.headline1,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  return Future(() {
                    postBloc.add(GetPost());
                  });
                },
                child: BlocListener<PostBloc, PostState>(
                  listener: (context, state) {
                    if (state is PostError)
                      return Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Posts are not loaded, please check your internet connection")));
                  },
                  child: BlocBuilder<PostBloc, PostState>(
                    builder: (context, state) {
                      if (state is PostLoaded) {
                        return buildPosts(context, state.posts);
                      }
                      return Container(
                        height: 300,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPosts(BuildContext context, List<Post> posts) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (BuildContext context, int i) {
        var post = posts[i];
        return PostWidget(
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
        );
      },
    );
  }
}
