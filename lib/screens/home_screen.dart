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
    //initialize a list post
    // this is a temporary caching method
    // posts will not disapper if we navigate back to home screen
    List<Post> posts = [];
    final postBloc = BlocProvider.of<PostBloc>(context);
    // Emitting the fetch event
    postBloc.add(FetchInitialPost());
    return Scaffold(
      appBar: MenuBar().appbar,
      bottomNavigationBar: BottomNavBar(
        //specifying the currentroute
        currentRoute: '/home',
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MenuBar().titleBar(context, title: "Home"),
            Expanded(
              //Fetch new post when refreshing
              child: RefreshIndicator(
                onRefresh: () {
                  return Future(() {
                    postBloc.add(FetchNewPost());
                  });
                },
                //Listener for errors
                child: BlocListener<PostBloc, PostState>(
                  listener: (context, state) {
                    if (state is PostError)
                      return Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Posts are not loaded, please check your internet connection")));
                  },
                  //builds a list of post after receiving posts from the bloc
                  child: BlocBuilder<PostBloc, PostState>(
                    builder: (context, state) {
                      if (state is PostLoaded) {
                        //update the posts
                        posts = state.posts;
                      }
                      //build the posts
                      return buildPosts(context, posts);
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
    ///uses a listview builder
    ///this builds the list lazily
    ///therefore, not cpu intensive
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int i) {
        var post = posts[i];

        /// returns a post widget with the available info
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
