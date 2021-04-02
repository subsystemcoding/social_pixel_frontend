import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:socialpixel/data/models/comment.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/widgets/post_widget.dart';
import 'package:socialpixel/widgets/profile_avatar.dart';

class PostWidgetScreen extends StatefulWidget {
  final Post post;
  const PostWidgetScreen({Key key, this.post}) : super(key: key);

  @override
  _PostWidgetScreenState createState() => _PostWidgetScreenState();
}

class _PostWidgetScreenState extends State<PostWidgetScreen> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _controller = TextEditingController();
  String hintText = "Type a comment..";
  bool isReplyKeyboard = false;
  Comment replyComment;
  List<Comment> comments;
  Post post;

  @override
  void initState() {
    super.initState();
    comments = [];
    BlocProvider.of<PostBloc>(context).add(FetchPost(widget.post.postId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostSingleLoaded) {
              post = state.post;
              comments = post.comments;
            }
            if (post != null) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: ListView(
                      children: [
                        PostWidget(
                          post: post,
                          inPostScreen: true,
                        ),
                        _buildComments(),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                  //TextField
                  Positioned(
                    bottom: 0,
                    left: 4,
                    right: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              focusNode: _focusNode,
                              controller: _controller,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16.0),
                                border: InputBorder.none,
                                hintText: hintText,
                                hintStyle:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              onSubmitted: (val) {
                                if (_controller.text.isNotEmpty) {
                                  if (!isReplyKeyboard) {
                                    BlocProvider.of<PostBloc>(context).add(
                                      CommentPost(
                                        text: _controller.text,
                                        postId: post.postId,
                                      ),
                                    );
                                  } else {
                                    BlocProvider.of<PostBloc>(context).add(
                                      ReplyComment(
                                        post.postId,
                                        replyComment.commentId,
                                        _controller.text,
                                      ),
                                    );
                                  }
                                  _controller.clear();
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    hintText = "Type a comment..";
                                    isReplyKeyboard = false;
                                  });
                                }
                              },
                            ),
                          ),
                          Container(
                            width: 47,
                            margin: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 2.0),
                            child: TextButton(
                              child: Icon(
                                Icons.send,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 0.0),
                                elevation: 2,
                                backgroundColor: Theme.of(context).accentColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (_controller.text.isNotEmpty) {
                                  if (!isReplyKeyboard) {
                                    BlocProvider.of<PostBloc>(context).add(
                                      CommentPost(
                                        text: _controller.text,
                                        postId: post.postId,
                                      ),
                                    );
                                  } else {
                                    BlocProvider.of<PostBloc>(context).add(
                                      ReplyComment(
                                        post.postId,
                                        replyComment.commentId,
                                        _controller.text,
                                      ),
                                    );
                                  }
                                  _controller.clear();
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    hintText = "Type a comment..";
                                    isReplyKeyboard = false;
                                  });
                                } else {
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Cannot post empty comment"),
                                    ),
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            } else if (post == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container();
          },
        ));
  }

  Widget _buildComments() {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostCommentsFetched) {
          comments = state.post.comments;
        } else if (state is PostCommented) {
          comments.insert(0, state.comment);
        } else if (state is PostReplied) {
          replyComment.replies.add(state.comment);
        }
        return Column(
          children: comments
              .map(
                (comment) => _buildComment(comment, true),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildComment(Comment comment, bool hasReplies) {
    var margin = EdgeInsets.all(12);
    if (!hasReplies) {
      margin = EdgeInsets.fromLTRB(40, 12, 12, 12);
    }
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
          margin: margin,
          padding: EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: ProfileAvatar(
                  imageLink: comment.user.userAvatarImage,
                  radius: 20,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.user.username,
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      comment.commentContent,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 12,
              ),
              hasReplies
                  ? Expanded(
                      child: GestureDetector(
                        child: Icon(
                          Icons.reply,
                          color: Theme.of(context).accentColor,
                          size: 16,
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(_focusNode);
                          setState(() {
                            replyComment = comment;
                            hintText = "Reply ..";
                            isReplyKeyboard = true;
                          });
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        hasReplies ? _buildReplies(comment.replies ?? []) : Container(),
      ],
    );
  }

  Widget _buildReplies(List<Comment> comments) {
    return Column(
      children: comments
          .map(
            (comment) => _buildComment(comment, false),
          )
          .toList(),
    );
  }
}
