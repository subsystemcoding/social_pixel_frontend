import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/message_bloc/bloc/message_bloc.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:socialpixel/screens/channel_screen.dart';
import 'package:socialpixel/screens/first_screen.dart';
import 'package:socialpixel/screens/forget_screen.dart';
import 'package:socialpixel/screens/home_screen.dart';
import 'package:socialpixel/screens/leaderboard_screen.dart';
import 'package:socialpixel/screens/login_screen.dart';
import 'package:socialpixel/screens/message_list_screen.dart';
import 'package:socialpixel/screens/message_screen.dart';
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
          builder: (_) => BlocProvider<PostBloc>(
            create: (context) => PostBloc(),
            child: HomeScreen(),
          ),
        );
      case '/search':
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case '/message_list':
        return MaterialPageRoute(builder: (_) => MessageListScreen());
      case '/message':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<MessageBloc>(
                  create: (context) => MessageBloc(),
                  child: MessageScreen(),
                ));
      case '/channel':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PostBloc>(
            create: (context) => PostBloc(),
            child: ChannelScreen(
              coverImage: NetworkImage(
                  "https://steamuserimages-a.akamaihd.net/ugc/940586530515504757/CDDE77CB810474E1C07B945E40AE4713141AFD76/"),
              avatarImage: NetworkImage(
                  "https://miro.medium.com/max/5000/1*jFyawcsqoYctkTuZg6wQ1A.jpeg"),
              title: "Muda channel",
              description: "This channel for mudas and no one elses",
            ),
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
            coverImage: NetworkImage(
                "https://steamuserimages-a.akamaihd.net/ugc/940586530515504757/CDDE77CB810474E1C07B945E40AE4713141AFD76/"),
            avatarImage: NetworkImage(
                "https://miro.medium.com/max/5000/1*jFyawcsqoYctkTuZg6wQ1A.jpeg"),
            userName: "Pikachu",
            description:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacinia ultrices vestibulum. Integer leo elit, mollis vitae turpis non, fringilla vulputate diam. Vestibulum a urna lorem. Aliquam ut laoreet nisl. Vivamus tellus sem, aliquam sed hendrerit in, consectetur ac enim. Integer felis augue, sollicitudin eget eros non, gravida euismod tellus. Mauris eget luctus orci. Nunc tincidunt tempus tortor, sit amet tincidunt orci vestibulum in.",
            isVerified: true,
            points: '897',
            followers: '12',
          ),
        );
    }
  }
}
