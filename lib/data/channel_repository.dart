import 'package:socialpixel/data/models/channel.dart';

class ChannelRepository {
  Future<Channel> fetchChannel(int channelId) {
    return Future.delayed(
      Duration(seconds: 1),
      () {
        return Channel(
          id: 1,
          name: "Channel 1",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacinia ultrices vestibulum. Integer leo elit, mollis vitae turpis non, fringilla vulputate diam. Vestibulum a urna lorem. Aliquam ut laoreet nisl. Vivamus tellus sem, aliquam sed hendrerit in, consectetur ac enim. Integer felis augue, sollicitudin eget eros non, gravida euismod tellus. Mauris eget luctus orci. Nunc tincidunt tempus tortor, sit amet tincidunt orci vestibulum in.",
          subscribers: 28383,
          coverImageLink:
              "https://steamuserimages-a.akamaihd.net/ugc/940586530515504757/CDDE77CB810474E1C07B945E40AE4713141AFD76/",
          avatarImageLink:
              "https://miro.medium.com/max/5000/1*jFyawcsqoYctkTuZg6wQ1A.jpeg",
        );
      },
    );
  }

  Future<List<Channel>> fetchChannelList() {
    return Future.delayed(
      Duration(seconds: 1),
      () {
        return [
          Channel(
            id: 1,
            name: "Channel 1",
            description:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacinia ultrices vestibulum. Integer leo elit, mollis vitae turpis non, fringilla vulputate diam. Vestibulum a urna lorem. Aliquam ut laoreet nisl. Vivamus tellus sem, aliquam sed hendrerit in, consectetur ac enim. Integer felis augue, sollicitudin eget eros non, gravida euismod tellus. Mauris eget luctus orci. Nunc tincidunt tempus tortor, sit amet tincidunt orci vestibulum in.",
            subscribers: 28383,
            coverImageLink:
                "https://steamuserimages-a.akamaihd.net/ugc/940586530515504757/CDDE77CB810474E1C07B945E40AE4713141AFD76/",
            avatarImageLink:
                "https://miro.medium.com/max/5000/1*jFyawcsqoYctkTuZg6wQ1A.jpeg",
          ),
          Channel(
            id: 2,
            name: "Channel 2",
            description:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacinia ultrices vestibulum. Integer leo elit, mollis vitae turpis non, fringilla vulputate diam. Vestibulum a urna lorem. Aliquam ut laoreet nisl. Vivamus tellus sem, aliquam sed hendrerit in, consectetur ac enim. Integer felis augue, sollicitudin eget eros non, gravida euismod tellus. Mauris eget luctus orci. Nunc tincidunt tempus tortor, sit amet tincidunt orci vestibulum in.",
            subscribers: 2833,
            coverImageLink:
                "https://steamuserimages-a.akamaihd.net/ugc/940586530515504757/CDDE77CB810474E1C07B945E40AE4713141AFD76/",
            avatarImageLink:
                "https://miro.medium.com/max/5000/1*jFyawcsqoYctkTuZg6wQ1A.jpeg",
          ),
          Channel(
            id: 3,
            name: "Channel 3",
            description:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacinia ultrices vestibulum. Integer leo elit, mollis vitae turpis non, fringilla vulputate diam. Vestibulum a urna lorem. Aliquam ut laoreet nisl. Vivamus tellus sem, aliquam sed hendrerit in, consectetur ac enim. Integer felis augue, sollicitudin eget eros non, gravida euismod tellus. Mauris eget luctus orci. Nunc tincidunt tempus tortor, sit amet tincidunt orci vestibulum in.",
            subscribers: 2383,
            coverImageLink:
                "https://steamuserimages-a.akamaihd.net/ugc/940586530515504757/CDDE77CB810474E1C07B945E40AE4713141AFD76/",
            avatarImageLink:
                "https://miro.medium.com/max/5000/1*jFyawcsqoYctkTuZg6wQ1A.jpeg",
          ),
        ];
      },
    );
  }
}
