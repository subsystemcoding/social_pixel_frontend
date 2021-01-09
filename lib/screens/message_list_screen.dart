import 'package:flutter/material.dart';
import 'package:socialpixel/widgets/app_bar.dart';
import 'package:socialpixel/widgets/bottom_nav_bar.dart';

class MessageListScreen extends StatelessWidget {
  const MessageListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuBar().appbar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MenuBar().titleBar(context, title: "Messages"),
          SizedBox(height: 16.0),
          Container(
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 28.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Color(0x199597a1),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 12.0,
                ),
                Icon(
                  Icons.search_outlined,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.0),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  if (index % 2 == 0)
                    return buildUserLists(
                      context,
                      username: "Anas Patel",
                      text: "Hello darkness my old world",
                      imageLink:
                          "https://i.pinimg.com/originals/5b/b4/8b/5bb48b07fa6e3840bb3afa2bc821b882.jpg",
                      time: "02:47",
                      notification: "12",
                    );
                  else {
                    return Container(
                      margin: EdgeInsets.only(bottom: 12.0),
                      child: Divider(
                        indent: 92.0,
                        endIndent: 16.0,
                      ),
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget buildUserLists(BuildContext context,
      {String username,
      String text,
      String imageLink,
      String time,
      String notification}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageLink),
        radius: 30,
      ),
      title: Text(username),
      subtitle: Text(text),
      trailing: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Text(
            time,
            style: Theme.of(context).primaryTextTheme.subtitle1,
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            child: Text(
              notification,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
