import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/widgets/app_bar.dart';
import 'package:socialpixel/widgets/bottom_nav_bar.dart';
import 'package:socialpixel/widgets/custom_buttons.dart';
import 'package:socialpixel/widgets/custom_drawer.dart';
import 'package:socialpixel/widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> posts = [];
  var postBloc;

  @override
  void initState() {
    super.initState();
    postBloc = BlocProvider.of<PostBloc>(context);
    postBloc.add(FetchPosts());
  }

  @override
  Widget build(BuildContext context) {
    //initialize a list post
    // this is a temporary caching method
    // posts will not disapper if we navigate back to home screen
    // Emitting the fetch event
    return Scaffold(
      appBar: MenuBar().appbar,
      bottomNavigationBar: BottomNavBar(
        //specifying the currentroute
        currentRoute: '/home',
      ),
      drawer: CustomDrawer(),
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
                    postBloc.add(FetchPosts());
                  });
                },
                //Listener for errors
                child: BlocListener<PostBloc, PostState>(
                  listener: (context, state) {
                    if (state is PostError) {
                      return Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Posts are not loaded, please check your internet connection")));
                    } else if (state is PostUpvotedError) {
                      return Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Could not upvote post"),
                        ),
                      );
                    }
                  },
                  //builds a list of post after receiving posts from the bloc
                  child: BlocBuilder<PostBloc, PostState>(
                    builder: (context, state) {
                      if (state is PostLoaded) {
                        //update the posts
                        posts = state.posts;
                        if (posts.isEmpty) {
                          return Center(
                            child: Container(
                              height: 150,
                              width: 300,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12.5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Seems like you are new, please follow other users or subscribe to channels to view posts",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  CustomButtons.standardButton(
                                    context,
                                    text: "Search Channels and Profiles",
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed('/search');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                      if (posts.isNotEmpty) {
                        return buildPosts(context, posts);
                      }
                      return Center(child: CircularProgressIndicator());
                      //build the posts
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
          post: post,
        );
      },
    );
  }
}
