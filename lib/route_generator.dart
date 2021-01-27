import 'package:flutter/material.dart';
import 'package:socialpixel/screens/camera_screen.dart';
import 'package:socialpixel/screens/channel_screen.dart';
import 'package:socialpixel/screens/first_screen.dart';
import 'package:socialpixel/screens/forget_screen.dart';
import 'package:socialpixel/screens/home_screen.dart';
import 'package:socialpixel/screens/leaderboard_screen.dart';
import 'package:socialpixel/screens/login_screen.dart';
import 'package:socialpixel/screens/message_list_screen.dart';
import 'package:socialpixel/screens/message_screen.dart';
import 'package:socialpixel/screens/post_details_screen.dart';
import 'package:socialpixel/screens/post_preview_screen.dart';
import 'package:socialpixel/screens/register_screen.dart';
import 'package:socialpixel/screens/search_screen.dart';
import 'package:socialpixel/screens/user_profile_screen.dart';

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
      case '/search':
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case '/message_list':
        return MaterialPageRoute(builder: (_) => MessageListScreen());
      case '/message':
        return MaterialPageRoute(builder: (_) => MessageScreen());
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
            userId: args,
          ),
        );
      case '/camera':
        return MaterialPageRoute(
          builder: (_) => CameraScreen(),
        );
      case '/post_preview':
        return MaterialPageRoute(
          builder: (_) => PostPreviewScreen(path: args),
        );
      case '/post_details':
        return MaterialPageRoute(
          builder: (_) => PostDetailScreen(image: args),
        );
    }
  }
}
