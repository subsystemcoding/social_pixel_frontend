import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/map_bloc/map_bloc.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/repos/state_repository.dart';
import 'package:socialpixel/widgets/custom_buttons.dart';

class CapturePreview extends StatefulWidget {
  CapturePreview({Key key}) : super(key: key);

  @override
  _CapturePreviewState createState() => _CapturePreviewState();
}

class _CapturePreviewState extends State<CapturePreview> {
  Post selectedPost;
  bool postSelected = false;
  List<Post> posts = [];
  File imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = StateRepo.getImageFromState();
    BlocProvider.of<MapBloc>(context)
        .add(GetPosts(StateRepo.capturePost['location']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image(
            image: FileImage(
              imageFile,
            ),
          ),
          Center(
            child: postSelected
                ? ''
                : Text("Please select the post you are capturing."),
          ),
          BlocListener<MapBloc, MapState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is MapPostAddedForValidation) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  child: WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                      title: Text("Successful"),
                      content: Text(
                          "Capture is under validation. You will recieve points once the capture is validated."),
                      actions: [
                        TextButton(
                          child: Text("Okay"),
                          onPressed: () {
                            Navigator.of(context)
                                .popUntil(ModalRoute.withName('/map'));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is MapPostError) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  child: WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                      title: Text("Unsuccessful"),
                      content: Text("Please Try again"),
                      actions: [
                        TextButton(
                          child: Text("Okay"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
            child: BlocBuilder<MapBloc, MapState>(
              builder: (context, state) {
                if (state is MapPostLoaded) {
                  posts = List<Post>.from(
                    state.mapPosts.map((mapPost) => mapPost.post),
                  );
                } else if (state is MapPostLoading) {
                  return Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return !postSelected
                    ? Expanded(
                        child: GridView.count(
                          shrinkWrap: true,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                          crossAxisCount: 3,
                          children: _buildPosts(posts),
                        ),
                      )
                    : Image(
                        image: NetworkImage(selectedPost.postImageLink),
                      );
              },
            ),
          ),
          !postSelected
              ? Container()
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButtons.standardButton(
                          context,
                          text: "Choose Another",
                          onPressed: () {
                            setState(() {
                              postSelected = false;
                            });
                          },
                          type: ButtonStyleType.DisabledPurpleButton,
                        ),
                        CustomButtons.standardButton(context, text: "Confirm",
                            onPressed: () {
                          BlocProvider.of<MapBloc>(context).add(
                            AddPostForValidation(
                              selectedPost.postId,
                              Post(
                                postImageLink: imageFile.path,
                              ),
                            ),
                          );
                        }),
                        SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ],
                )
        ],
      ),
    );
  }

  List<Widget> _buildPosts(List<Post> posts) {
    return List<Widget>.from(posts.map((post) {
      return GestureDetector(
        child: GridTile(
          child: Image(
            image: NetworkImage(post.postImageLink),
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            child: AlertDialog(
              title: Text("Confirm"),
              content: Image(
                image: NetworkImage(post.postImageLink),
                height: 300,
              ),
              actions: [
                TextButton(
                  child: Text("Cofirm"),
                  onPressed: () {
                    setState(() {
                      postSelected = true;
                      selectedPost = post;
                    });
                  },
                ),
              ],
            ),
          );
        },
      );
    }));
  }
}
