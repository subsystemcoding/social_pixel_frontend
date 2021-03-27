import 'dart:js';

import 'package:flutter/material.dart';
import 'package:socialpixel/screens/home_screen.dart';
import 'package:socialpixel/screens/authorization_screen/login_screen.dart';
import 'package:socialpixel/screens/authorization_screen/first_screen.dart';
import 'package:socialpixel/screens/authorization_screen/forget_screen.dart';
import 'package:socialpixel/screens/authorization_screen/register_screen.dart';
import 'package:socialpixel/screens/channel_screen/channel_screen.dart';
import 'package:socialpixel/screens/channel_screen/leaderboard_screen.dart';
import 'package:socialpixel/screens/map_screen.dart';
import 'package:socialpixel/screens/message_screen/message_list_screen.dart';
import 'package:socialpixel/screens/message_screen/message_screen.dart';
import 'package:socialpixel/screens/post_screen/camera_screen.dart';
import 'package:socialpixel/screens/post_screen/post_preview_screen.dart';
import 'package:socialpixel/screens/post_screen/post_details_screen.dart';
import 'package:socialpixel/screens/search_screen.dart';
import 'package:socialpixel/screens/user_profile_screen.dart';

import 'screens/settings_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => FirstScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/forget':
        return MaterialPageRoute(builder: (_) => ForgetScreen());
      case '/home':
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case '/search':
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case '/message_list':
        return MaterialPageRoute(builder: (_) => MessageListScreen());
      case '/message':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => MessageScreen(
              chatroomId: args['id'],
              name: args['name'],
              imageLink: args['imageLink'],
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => MessageScreen());
      case '/map':
        return MaterialPageRoute(builder: (_) => MapScreen());
      case '/channel':
        return MaterialPageRoute(
          builder: (_) => ChannelScreen(
            channelId: args,
          ),
        );
      case '/leaderboard':
        return MaterialPageRoute(
          builder: (_) => LeaderboardScreen(
            title: "Game Title",
            description:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacinia ultrices vestibulum. Integer leo elit, mollis vitae turpis non, fringilla vulputate diam. Vestibulum a urna lorem. Aliquam ut laoreet nisl. Vivamus tellus sem, aliquam sed hendrerit in, consectetur ac enim. Integer felis augue, sollicitudin eget eros non, gravida euismod tellus. Mauris eget luctus orci. Nunc tincidunt tempus tortor, sit amet tincidunt orci vestibulum in.",
            coverImage: NetworkImage(
                "https://steamuserimages-a.akamaihd.net/ugc/940586530515504757/CDDE77CB810474E1C07B945E40AE4713141AFD76/"),
          ),
        );
      case '/profile':
        return MaterialPageRoute(
          builder: (_) => UserProfileScreen(
            username: args,
          ),
        );
      case '/camera':
        return MaterialPageRoute(
          builder: (_) => CameraScreen(),
        );
      case '/post_preview':
        return MaterialPageRoute(builder: (_) {
          if (args is Map) {
            return PostPreviewScreen(
              path: args['path'],
              isCamera: args['isCamera'],
            );
          }
          return null;
        });
      case '/post_details':
        return MaterialPageRoute(builder: (_) {
          if (args is Map) {
            return PostDetailScreen(
              image: args['image'],
              location: args['location'],
              photoDate: args['date'],
              isCamera: args['isCamera'],
            );
          }
          return null;
        });
    }
  }
}
