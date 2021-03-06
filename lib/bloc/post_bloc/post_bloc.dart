import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image/image.dart' as imageLib;
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/data/models/comment.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/location.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/models/profile.dart';
import 'package:socialpixel/data/repos/auth_repository.dart';
import 'package:socialpixel/data/repos/post_management.dart';
import 'package:exif/exif.dart';
import 'package:socialpixel/data/repos/profile_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final postManagement = PostManagement();

  PostBloc() : super(PostInitial());

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    yield PostLoading();

    if (event is FetchPosts) {
      try {
        if (event.channelId == -1) {
          var cachedPosts = await postManagement.fetchCachedPosts();
          if (cachedPosts.isNotEmpty) {
            yield PostLoaded(cachedPosts);
          }
        }

        ///if not available due to internet
        ///show no internet connection snackbar
        ///If both are not available then
        ///connect to internet screen
        yield PostLoaded(
          await postManagement.fetchPosts(
            channelId: event.channelId,
          ),
        );
      } catch (e) {
        yield PostError("Could not find posts");
      }
    } else if (event is FetchSearchedPost) {
      List<String> hashtags = event.hashtags.trim().split(' ');
      for (var hashtag in hashtags) {
        if (hashtag.startsWith("#")) {
          continue;
        }
        hashtag = "#$hashtag";
      }
      log(hashtags.toString());

      /// Return searched posts with hashtags
      yield SearchedPostLoaded(
        await postManagement.fetchSearchedPosts(hashtags: hashtags),
      );
    } else if (event is SendPost) {
      //await postManagement.sendPost(post, PostSending.Successful);
      try {
        bool res = await postManagement.sendPost(event.post, event.imageLink);
        yield PostSent();
      } catch (e) {
        yield PostSentError();
      }
    } else if (event is UpvotePost) {
      try {
        var modifier = event.upvote ? "ADD" : "REMOVE";
        bool success = await postManagement.upvotePost(
          postId: event.post.postId,
          modifier: modifier,
        );
        event.post.isUpvoted = !event.post.isUpvoted;
        if (event.post.isUpvoted) {
          event.post.upvotes++;
        } else {
          event.post.upvotes--;
        }
        yield PostUpvoted();
      } catch (e) {
        yield PostUpvotedError();
      }
    } else if (event is CommentPost) {
      try {
        await postManagement.addComment(
          postId: event.postId,
          text: event.text,
        );
        print("Dis in postbloc CommentPost");
        final profile = await ProfileRepository().fetchCurrentProfile();
        yield PostCommented(
          Comment(
            commentContent: event.text,
            dateCreated: DateTime.now().toString(),
            user: profile,
            replies: [],
          ),
        );
      } catch (e) {
        print(e);
        yield PostCommentError();
      }
    } else if (event is FetchComments) {
      try {
        final post = await postManagement.fetchPostComments(event.post);
        yield PostCommentsFetched(post);
      } catch (e) {
        print(e);
        yield PostCommentsFetchedError();
      }
    } else if (event is ReplyComment) {
      await postManagement.postReplyToComment(
        postId: event.postId,
        commentId: event.commentId,
        text: event.text,
      );
      final profile = await ProfileRepository().fetchCurrentProfile();

      yield PostReplied(Comment(
        commentContent: event.text,
        dateCreated: DateTime.now().toString(),
        user: profile,
      ));
    } else if (event is StartPostInitial) {
      yield PostInitial();
    } else if (event is FetchPost) {
      Post post = await postManagement.fetchSinglePost(event.postId);
      yield PostSingleLoaded(post);
    }
    // TODO: implement mapEventToState
  }
}
