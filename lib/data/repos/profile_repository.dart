import 'package:socialpixel/data/models/profile.dart';

class ProfileRepository {
  Future<Profile> fetchProfile(int userId) {
    return Future.delayed(
      Duration(seconds: 1),
      () {
        return Profile(
          userId: 12,
          username: "Anas Patel",
          userAvatarImage:
              "https://steamuserimages-a.akamaihd.net/ugc/940586530515504757/CDDE77CB810474E1C07B945E40AE4713141AFD76/",
          userCoverImage:
              "https://miro.medium.com/max/5000/1*jFyawcsqoYctkTuZg6wQ1A.jpeg",
          email: "anaspatel@gmail.com",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacinia ultrices vestibulum. Integer leo elit, mollis vitae turpis non, fringilla vulputate diam. Vestibulum a urna lorem. Aliquam ut laoreet nisl. Vivamus tellus sem, aliquam sed hendrerit in, consectetur ac enim. Integer felis augue, sollicitudin eget eros non, gravida euismod tellus. Mauris eget luctus orci. Nunc tincidunt tempus tortor, sit amet tincidunt orci vestibulum in.",
          isVerified: true,
          points: 897,
          followers: 12,
        );
      },
    );
  }

  Future<List<Profile>> fetchProfileList() {
    return Future.delayed(
      Duration(seconds: 1),
      () {
        return [
          Profile(
            userId: 1,
            username: "Anas Patel",
            userAvatarImage:
                "https://steamuserimages-a.akamaihd.net/ugc/940586530515504757/CDDE77CB810474E1C07B945E40AE4713141AFD76/",
            userCoverImage:
                "https://miro.medium.com/max/5000/1*jFyawcsqoYctkTuZg6wQ1A.jpeg",
            email: "anaspatel@gmail.com",
            description:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacinia ultrices vestibulum. Integer leo elit, mollis vitae turpis non, fringilla vulputate diam. Vestibulum a urna lorem. Aliquam ut laoreet nisl. Vivamus tellus sem, aliquam sed hendrerit in, consectetur ac enim. Integer felis augue, sollicitudin eget eros non, gravida euismod tellus. Mauris eget luctus orci. Nunc tincidunt tempus tortor, sit amet tincidunt orci vestibulum in.",
            isVerified: true,
            points: 897,
            followers: 12,
          ),
          Profile(
            userId: 11,
            username: "Riya",
            userAvatarImage:
                "https://steamuserimages-a.akamaihd.net/ugc/940586530515504757/CDDE77CB810474E1C07B945E40AE4713141AFD76/",
            userCoverImage:
                "https://miro.medium.com/max/5000/1*jFyawcsqoYctkTuZg6wQ1A.jpeg",
            email: "anaspatel@gmail.com",
            description:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacinia ultrices vestibulum. Integer leo elit, mollis vitae turpis non, fringilla vulputate diam. Vestibulum a urna lorem. Aliquam ut laoreet nisl. Vivamus tellus sem, aliquam sed hendrerit in, consectetur ac enim. Integer felis augue, sollicitudin eget eros non, gravida euismod tellus. Mauris eget luctus orci. Nunc tincidunt tempus tortor, sit amet tincidunt orci vestibulum in.",
            isVerified: true,
            points: 897,
            followers: 12,
          ),
          Profile(
            userId: 10,
            username: "Prith",
            userAvatarImage:
                "https://steamuserimages-a.akamaihd.net/ugc/940586530515504757/CDDE77CB810474E1C07B945E40AE4713141AFD76/",
            userCoverImage:
                "https://miro.medium.com/max/5000/1*jFyawcsqoYctkTuZg6wQ1A.jpeg",
            email: "anaspatel@gmail.com",
            description:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacinia ultrices vestibulum. Integer leo elit, mollis vitae turpis non, fringilla vulputate diam. Vestibulum a urna lorem. Aliquam ut laoreet nisl. Vivamus tellus sem, aliquam sed hendrerit in, consectetur ac enim. Integer felis augue, sollicitudin eget eros non, gravida euismod tellus. Mauris eget luctus orci. Nunc tincidunt tempus tortor, sit amet tincidunt orci vestibulum in.",
            isVerified: true,
            points: 897,
            followers: 12,
          ),
        ];
      },
    );
  }
}
