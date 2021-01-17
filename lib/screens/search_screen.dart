import 'package:flutter/material.dart';
import 'package:socialpixel/widgets/app_bar.dart';
import 'package:socialpixel/widgets/bottom_nav_bar.dart';
import 'package:socialpixel/widgets/search_bar.dart';
import 'package:socialpixel/widgets/tabbar.dart';
import 'package:tinycolor/tinycolor.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuBar().appbar,
      bottomNavigationBar: BottomNavBar(
        currentRoute: '/search',
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            SearchBar(),
            CustomTabBar().tabBar(
              context,
              tabs: [
                Text("People"),
                Text("Posts"),
                Text("Channel"),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildPeopleSection(),
                  buildPostSection(),
                  buildChannelSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPeopleSection() {
    return ListView.builder(
      itemCount: 5 * 2,
      itemBuilder: (context, i) {
        if (i % 2 == 0) {
          return buildUser(
            context,
            username: "UserName",
            description: "some description",
            image: NetworkImage(
                "https://i.picsum.photos/id/691/200/300.jpg?hmac=1nouilaOHm3p-SqXPrCLcCcFEtJ60GlDAwkLAHq4x-c"),
          );
        }
        return Divider();
      },
    );
  }

  Widget buildPostSection() {
    return ListView.builder(
      itemCount: 5 * 2,
      itemBuilder: (context, i) {
        if (i % 2 == 0) {
          return buildPost(
            context,
            username: "UserName",
            description:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacinia ultrices vestibulum. Integer leo elit, mollis vitae turpis non, fringilla vulputate diam. Vestibulum a urna lorem. Aliquam ut laoreet nisl. Vivamus tellus sem, aliquam sed hendrerit in, consectetur ac enim. Integer felis augue, sollicitudin eget eros non, gravida euismod tellus. Mauris eget luctus orci. Nunc tincidunt tempus tortor, sit amet tincidunt orci vestibulum in.",
            image: NetworkImage(
                "https://i.picsum.photos/id/691/200/300.jpg?hmac=1nouilaOHm3p-SqXPrCLcCcFEtJ60GlDAwkLAHq4x-c"),
          );
        }
        return Divider();
      },
    );
  }

  Widget buildChannelSection() {
    return ListView.builder(
      itemCount: 5 * 2,
      itemBuilder: (context, i) {
        if (i % 2 == 0) {
          return buildChannel(context,
              channelName: "UserName",
              image: NetworkImage(
                  "https://i.picsum.photos/id/691/200/300.jpg?hmac=1nouilaOHm3p-SqXPrCLcCcFEtJ60GlDAwkLAHq4x-c"),
              subscribers: "12.4k");
        }
        return Divider();
      },
    );
  }

  Widget buildUser(
    BuildContext context, {
    String username,
    String description,
    ImageProvider<Object> image,
    bool isVerified = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/profile');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 4.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: image,
              radius: 25,
            ),
            SizedBox(
              width: 12.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        username,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).primaryTextTheme.headline4,
                      ),
                      isVerified
                          ? Container(
                              margin: EdgeInsets.only(bottom: 8.0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: TinyColor(Theme.of(context).accentColor)
                                    .lighten(35)
                                    .color,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              child: Text(
                                "Verified",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color:
                                        TinyColor(Theme.of(context).accentColor)
                                            .lighten(0)
                                            .color),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Text(
                    description,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(context).primaryTextTheme.bodyText2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPost(
    BuildContext context, {
    String username,
    String description,
    ImageProvider<Object> image,
    String datePosted,
  }) {
    return Container(
      height: 125,
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      margin: EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 90,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Theme.of(context).accentColor),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Image(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 12.0,
          ),
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).primaryTextTheme.headline4,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      description,
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).primaryTextTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Row(
                  children: [
                    Text("17.k",
                        style: Theme.of(context).primaryTextTheme.subtitle2),
                    SizedBox(
                      width: 4.0,
                    ),
                    Icon(
                      Icons.thumb_up_outlined,
                      size: 16,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text("999",
                        style: Theme.of(context).primaryTextTheme.subtitle2),
                    SizedBox(
                      width: 4.0,
                    ),
                    Icon(
                      Icons.comment_outlined,
                      size: 16,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "12 Feb 2021",
                      style: Theme.of(context).primaryTextTheme.subtitle2,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildChannel(
    BuildContext context, {
    String channelName,
    ImageProvider<Object> image,
    String subscribers,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/channel');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 4.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: image,
              radius: 25,
            ),
            SizedBox(
              width: 12.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    channelName,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).primaryTextTheme.headline4,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(subscribers + " subscribers",
                      style: Theme.of(context).primaryTextTheme.subtitle2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
