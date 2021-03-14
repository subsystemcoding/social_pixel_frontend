import 'package:flutter/material.dart';
import 'package:socialpixel/widgets/app_bar.dart';
import 'package:socialpixel/widgets/bottom_nav_bar.dart';

class NotifScreen extends StatelessWidget {
  const NotifScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuBar().appbar(context, title: "Notifications"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //MenuBar().titleBar(context, title: "Notifications"),
          SizedBox(height: 8.0),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView(
                children: [
                  buildUserLists(
                    context,
                    username: "Anna Waltz upvoted your post",
                    text: "Hello darkness my old friend",
                    imageLink:
                        "https://i.pinimg.com/originals/5b/b4/8b/5bb48b07fa6e3840bb3afa2bc821b882.jpg",
                    time: "5hrs ago",
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: Divider(
                      indent: 92.0,
                      endIndent: 16.0,
                    ),
                  ),
                  buildUserLists(
                    context,
                    username: "Tehya Bone and 5 others commented on your post",
                    text: "So hit me up when you're ready!!!",
                    imageLink:
                        "https://i.pinimg.com/originals/5a/90/53/5a9053e149285b43f8dd58f842267f3c.png",
                    time: "2d ago",
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: Divider(
                      indent: 92.0,
                      endIndent: 16.0,
                    ),
                  ),
                  buildUserLists(
                    context,
                    username:
                        "Shawn Carter and 2 others mentioned you in their post",
                    text: "Lorem ipsum dolor sit amet,...",
                    imageLink:
                        "http://creativeedtech.weebly.com/uploads/4/1/6/3/41634549/published/avatar.png?1487742111",
                    time: "31 Jan",
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: Divider(
                      indent: 92.0,
                      endIndent: 16.0,
                    ),
                  ),
                  buildUserLists(
                    context,
                    username: "Jasmine Essim commented on your post",
                    text: "Let me call my agency",
                    imageLink:
                        "https://i.pinimg.com/474x/e5/0c/1d/e50c1d3835400d1a1cd4363eae694105.jpg",
                    time: "30 Jan",
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: Divider(
                      indent: 92.0,
                      endIndent: 16.0,
                    ),
                  ),
                  buildUserLists(
                    context,
                    username: "Han Keepson shared your post",
                    text: "Lorem ipsum dolor sit amet,...",
                    imageLink:
                        "https://xenforo.com/community/data/avatars/o/202/202502.jpg?1587654225",
                    time: "30 Jan",
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: Divider(
                      indent: 92.0,
                      endIndent: 16.0,
                    ),
                  ),
                  buildUserLists(
                    context,
                    username: "Zachery Whitney and 5 others upvoted your post",
                    text: "Lorem ipsum dolor sit amet,...",
                    imageLink:
                        "https://image.shutterstock.com/image-vector/young-afro-man-avatar-character-260nw-723829372.jpg",
                    time: "29 Jan",
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: Divider(
                      indent: 92.0,
                      endIndent: 16.0,
                    ),
                  ),
                  buildUserLists(
                    context,
                    username: "Nigel Carr commented on your post",
                    text: "For sure!",
                    imageLink:
                        "https://media.istockphoto.com/vectors/portrait-of-smiling-afro-man-bearded-businessman-in-suit-and-orange-vector-id1135342261?k=6&m=1135342261&s=612x612&w=0&h=oJHqmDPemVZkiE71KZwm4fwN5JAMwsLGr4AhIn1KAog=",
                    time: "29 Jan",
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentRoute: '/notif',
      ),
    );
  }

  Widget buildUserLists(
    BuildContext context, {
    String username,
    String text,
    String imageLink,
    String time,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageLink),
        radius: 30,
      ),
      title: Text(
        username,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        text,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Text(
            time,
            style: Theme.of(context).primaryTextTheme.subtitle1,
          ),
        ],
      ),
      onTap: () {
        //Navigator.of(context).pushNamed('/message');
      },
    );
  }
}
