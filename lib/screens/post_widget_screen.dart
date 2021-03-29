import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:socialpixel/data/models/comment.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/widgets/post_widget.dart';

class PostWidgetScreen extends StatefulWidget {
  final Post post;
  const PostWidgetScreen({Key key, this.post}) : super(key: key);

  @override
  _PostWidgetScreenState createState() => _PostWidgetScreenState();
}

class _PostWidgetScreenState extends State<PostWidgetScreen> {
  TextEditingController _controller = TextEditingController();
  List<Comment> comments;

  @override
  void initState() {
    super.initState();
    comments = [];
    BlocProvider.of<PostBloc>(context).add(FetchComments(widget.post));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView(
              children: [
                PostWidget(
                  post: widget.post,
                  inPostScreen: true,
                ),
                _buildComments(),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
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
                      controller: _controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        border: InputBorder.none,
                        hintText: "Type a message",
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      onSubmitted: (val) {
                        if (_controller.text.isNotEmpty) {
                          BlocProvider.of<PostBloc>(context).add(
                            CommentPost(
                              text: _controller.text,
                              postId: widget.post.postId,
                            ),
                          );
                          _controller.clear();
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  ),
                  Container(
                    width: 47,
                    margin:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
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
                          BlocProvider.of<PostBloc>(context).add(
                            CommentPost(
                              text: _controller.text,
                              postId: widget.post.postId,
                            ),
                          );
                          _controller.clear();
                          FocusScope.of(context).unfocus();
                        } else {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Cannot post empty comment"),
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
      ),
    );
  }

  Widget _buildComments() {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostCommentsFetched) {
          print("Hello dis is postCommentsFetchd");
          comments = state.post.comments;
        } else if (state is PostCommented) {
          print("Hello dis is postCommented");
          comments.insert(0, state.comment);
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
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(comment.user.userAvatarImage),
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
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        // ListTile(
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(12.0),
        //   ),
        //   leading: CircleAvatar(
        //     backgroundImage: NetworkImage(comment.user.userAvatarImage),
        //   ),
        //   title: Text(
        //     comment.user.username,
        //     style: Theme.of(context).textTheme.headline6,
        //   ),
        //   subtitle: Text(
        //     comment.commentContent,
        //     style: Theme.of(context).primaryTextTheme.subtitle1,
        //   ),
        // ),
        hasReplies ? _buildReplies(comment.replies) : Container(),
      ],
    );
  }

  Widget _buildReplies(List<Comment> comments) {
    return Column(
      children: comments
          .map(
            (comment) => _buildComment(comment, true),
          )
          .toList(),
    );
  }
}
