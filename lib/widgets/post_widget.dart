import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:socialpixel/data/Converter.dart';
import 'package:socialpixel/data/models/location.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/widgets/custom_buttons.dart';
import 'package:socialpixel/widgets/profile_avatar.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final bool inPostScreen;

  const PostWidget({
    Key key,
    this.post,
    this.inPostScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
              blurRadius: 10.0,
              color: Colors.grey[300],
              offset: Offset(0.5, 0.5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          profile(context),
          SizedBox(
            height: 12.0,
          ),
          _buildpost(context),
          SizedBox(
            height: 12.0,
          ),
          this.post.location.latitude != null
              ? getGpsTag(text: this.post.location.address)
              : Container(),
          getCaption(context),
          SizedBox(
            height: 12.0,
          ),
          buttons(context),
          SizedBox(
            height: 12.0,
          ),
          information(context),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  Widget profile(BuildContext context) {
    var dateTime = Converter.dateTimeStringtoReadable(this.post.datePosted);
    return Row(children: [
      ProfileAvatar(
        radius: 25,
        imageBytes: this.post.userImageBytes,
        imageLink: this.post.userAvatarLink,
      ),
      // CircleAvatar(
      //   backgroundImage: this.post.userImageBytes != null &&
      //           this.post.userImageBytes.isNotEmpty
      //       ? MemoryImage(this.post.userImageBytes)
      //       : NetworkImage(this.post.userAvatarLink),
      //   radius: 30,
      // ),
      SizedBox(
        width: 12.0,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              this.post.userName,
              textAlign: TextAlign.left,
              style: Theme.of(context).primaryTextTheme.headline4,
            ),
            Text(
              dateTime,
              textAlign: TextAlign.left,
              style: Theme.of(context).primaryTextTheme.subtitle1,
            )
          ],
        ),
      ),
    ]);
  }

  Widget _buildpost(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!inPostScreen) {
          Navigator.of(context).pushNamed("/post_widget", arguments: post);
        }
      },
      //padding: EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: Image(
          image: this.post.postImageBytes != null
              ? MemoryImage(this.post.postImageBytes)
              : NetworkImage(this.post.postImageLink),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget getCaption(BuildContext context) {
    return Container(
      child: Text(
        this.post.caption,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            {
              if (state is PostUpvoted) {
                this.post.isUpvoted = this.post.isUpvoted;
              }
              return CustomButtons.standardButtonIcon(
                context,
                icondata: Icons.thumb_up_rounded,
                type: this.post.isUpvoted
                    ? ButtonStyleType.PurpleButton
                    : ButtonStyleType.DisabledPurpleButton,
                onPressed: () => {
                  BlocProvider.of<PostBloc>(context).add(
                    UpvotePost(
                      upvote: !this.post.isUpvoted,
                      post: this.post,
                    ),
                  )
                },
              );
            }
          },
        ),
        SizedBox(width: 12.0),
        CustomButtons.standardButtonIcon(
          context,
          icondata: Icons.add_comment,
          onPressed: () => {
            if (!inPostScreen)
              {
                Navigator.of(context)
                    .pushNamed("/post_widget", arguments: post),
              }
          },
          type: inPostScreen
              ? ButtonStyleType.PurpleButton
              : ButtonStyleType.DisabledPurpleButton,
        ),
        SizedBox(width: 12.0),
        CustomButtons.standardButtonIcon(
          context,
          icondata: Icons.share,
          onPressed: () => {},
          type: ButtonStyleType.DisabledPurpleButton,
        ),
      ],
    );
  }

  Widget button(BuildContext context,
      {String text,
      Function onPressed,
      TextStyle textStyle,
      Color backgroundColor}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      child: TextButton(
        child: Text(
          text,
          style: textStyle,
        ),
        style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
        onPressed: onPressed,
      ),
    );
  }

  Widget information(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostUpvoted) {}
        return Row(
          children: [
            Text(
              this.post.upvotes.toString() +
                  " upvotes " +
                  this.post.commentCount.toString() +
                  ' comments ',
              style: Theme.of(context).primaryTextTheme.subtitle1,
            )
          ],
        );
      },
    );
  }

  Widget getGpsTag({String text}) {
    return Container(
      height: 50,
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Icon(Icons.location_pin, color: Colors.blue),
          SizedBox(
            width: 4,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 14.0, color: Colors.blue),
          )
        ],
      ),
    );
  }
}
