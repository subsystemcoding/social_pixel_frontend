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
      bottomNavigationBar: BottomNavBar(
        currentRoute: '/home',
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MenuBar().titleBar(context, title: "Home"),
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
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int i) {
        var post = posts[i];
        return PostWidget(
          userName: post.userName,
          userAvatar: post.userAvatarLink,
          datePosted: post.datePosted,
          postImage: post.postImageLink,
          otherUsers:
              post.otherUsers.map((user) => user.userAvatarImage).toList(),
          caption: post.caption,
          location: post.location,
          userAvatarBytes: post.userImageBytes,
          postImageBytes: post.postImageBytes,
          otherUsersBytes:
              post.otherUsers.map((user) => user.userImageBytes).toList(),
        );
      },
    );
  }
}
