import 'dart:math';

import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/models/game.dart';

enum PostSending {
  Successful,
  Unsuccessful,
  NoInternet,
}

class PostManagement {
  Random random;
  PostManagement() {
    random = Random();
  }

  Future<PostSending> sendPost(Post post, PostSending value) {
    return Future.delayed(Duration(milliseconds: 500), () {
      return value;
    });
  }

  Future<List<Game>> fetchGamePosts() {
    return Future.delayed(Duration(seconds: 1), () {
      return [
        Game(
            name: "First Game",
            description: "This the channel's first game",
            image:
                "https://data4.origin.com/asset/content/dam/originx/web/app/programs/About/aboutorigin_3840x2160_battlefield1.jpg/27051ac9-d3c0-49e3-9979-3dc1058a69f5/original.jpg"),
        Game(
            name: "Second Game",
            description:
                "This the channel's second game which is amazing and beyond explosion, muhahaha",
            image:
                "https://i.guim.co.uk/img/media/c6f7b43fa821d06fe1ab4311e558686529931492/168_84_1060_636/master/1060.jpg?width=1200&height=900&quality=85&auto=format&fit=crop&s=fd98bc73a66809dbb678b1a88aa6f96c")
      ];
    });
  }

  Future<List<Post>> fetchPosts() {
    return Future.delayed(Duration(seconds: 1), () {
      return [
        Post(
            postId: 1,
            userName: "Anas Patel",
            userAvatarLink:
                "https://i.pinimg.com/originals/5b/b4/8b/5bb48b07fa6e3840bb3afa2bc821b882.jpg",
            datePosted: "2 days ago",
            postImageLink:
                "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/dog-puppy-on-garden-royalty-free-image-1586966191.jpg?crop=1.00xw:0.669xh;0,0.190xh&resize=1200:*",
            otherUsers: [
              "https://pbs.twimg.com/profile_images/1342768807891378178/8le-DzgC.jpg",
              "https://png.pngtree.com/thumb_back/fh260/background/20190827/pngtree-random-energy-wave-background-image_307670.jpg"
            ],
            status: "76 upvotes   2 comments",
            caption: "Ugly dog i found on my strret.",
            gpsTag: "Abu Dhabi"),
        Post(
            postId: 3,
            userName: "Benjamin",
            userAvatarLink:
                "https://pbs.twimg.com/profile_images/1342768807891378178/8le-DzgC.jpg",
            datePosted: "2 days ago",
            postImageLink:
                "https://post.greatist.com/wp-content/uploads/sites/3/2020/02/322868_1100-1100x628.jpg",
            otherUsers: [
              "https://pbs.twimg.com/profile_images/1342768807891378178/8le-DzgC.jpg",
              "https://png.pngtree.com/thumb_back/fh260/background/20190827/pngtree-random-energy-wave-background-image_307670.jpg",
              "https://www.computerhope.com/jargon/r/random-dice.jpg"
            ],
            status: "94562 upvotes   456 comments",
            caption: "Believe or not, I ate this guy",
            gpsTag: "Dubai"),
      ];
    });
  }
}
