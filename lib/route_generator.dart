import 'package:flutter/material.dart';
import 'package:socialpixel/screens/channel_screen/check_human_screen.dart';
import 'package:socialpixel/screens/channel_screen/check_location_screen.dart';
import 'package:socialpixel/screens/channel_screen/create_channel_screen.dart';
import 'package:socialpixel/screens/channel_screen/create_game_screen.dart';
import 'package:socialpixel/screens/channel_screen/crop_image_screen.dart';
import 'package:socialpixel/screens/home_screen.dart';
import 'package:socialpixel/screens/authorization_screen/login_screen.dart';
import 'package:socialpixel/screens/authorization_screen/first_screen.dart';
import 'package:socialpixel/screens/authorization_screen/forget_screen.dart';
import 'package:socialpixel/screens/authorization_screen/register_screen.dart';
import 'package:socialpixel/screens/channel_screen/channel_screen.dart';
import 'package:socialpixel/screens/channel_screen/leaderboard_screen.dart';
import 'package:socialpixel/screens/map_games/capture_preview.dart';
import 'package:socialpixel/screens/map_games/map_screen.dart';
import 'package:socialpixel/screens/map_games/validation_screen.dart';
import 'package:socialpixel/screens/message_screen/message_list_screen.dart';
import 'package:socialpixel/screens/message_screen/message_screen.dart';
import 'package:socialpixel/screens/message_screen/preview_message_screen.dart';
import 'package:socialpixel/screens/post_screen/camera_screen.dart';
import 'package:socialpixel/screens/post_screen/post_preview_screen.dart';
import 'package:socialpixel/screens/post_screen/post_details_screen.dart';
import 'package:socialpixel/screens/post_widget_screen.dart';
import 'package:socialpixel/screens/search_screen.dart';
import 'package:socialpixel/screens/user_profile_screen.dart';

import 'screens/settings_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            settings: settings, builder: (_) => FirstScreen());
      case '/login':
        return MaterialPageRoute(
            settings: settings, builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(
            settings: settings, builder: (_) => RegisterScreen());
      case '/forget':
        return MaterialPageRoute(
            settings: settings, builder: (_) => ForgetScreen());
      case '/home':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HomeScreen(),
        );
      case '/post_widget':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PostWidgetScreen(
            post: args,
          ),
        );
      case '/settings':
        return MaterialPageRoute(
            settings: settings, builder: (_) => SettingsScreen());
      case '/search':
        return MaterialPageRoute(
            settings: settings, builder: (_) => SearchScreen());
      case '/message_list':
        return MaterialPageRoute(
            settings: settings, builder: (_) => MessageListScreen());
      case '/message':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MessageScreen(
            chatroom: args,
          ),
        );

        return MaterialPageRoute(
            settings: settings, builder: (_) => MessageScreen());
      case '/preview_screen':
        if (args is Map) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => PreviewMessageScreen(
              imageFilePath: args['path'],
            ),
          );
        }
        return MaterialPageRoute(
            settings: settings, builder: (_) => Container());
      case '/map':
        return MaterialPageRoute(
            settings: settings, builder: (_) => MapScreen());
      case '/channel':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChannelScreen(
            channelId: args,
          ),
        );
      case '/create_channel':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CreateChannelScreen(),
        );
      case '/create_game':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CreateGameScreen(),
        );
      case '/check_human':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CheckHumanScreen(),
        );
      case '/check_location':
        if (args is Map) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => CheckLocationScreen(
              isCamera: args['isCamera'],
              path: args['path'],
            ),
          );
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Container(),
        );
      case '/crop_image':
        if (args is Map) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => CropImageScreen(
              path: args['path'],
            ),
          );
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Container(),
        );
      case '/check_location':
        if (args is Map) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => CheckLocationScreen(
              isCamera: args['isCamera'],
              path: args['path'],
            ),
          );
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Container(),
        );
      case '/capture':
        if (args is Map) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => CapturePreview(),
          );
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CapturePreview(),
        );
      case '/validate':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ValidationScreen(),
        );

      case '/leaderboard':
        if (args is Map) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => LeaderboardScreen(
              id: args['id'],
              title: args['title'],
              description: args['description'],
              coverImage: NetworkImage(args['image']),
            ),
          );
        }
        return MaterialPageRoute(
            settings: settings, builder: (_) => Container());
      case '/profile':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => UserProfileScreen(
            args,
          ),
        );
      case '/camera':
        if (args is Map) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => CameraScreen(
              route: args['route'],
              isSquare: args['isSquare'],
            ),
          );
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Container(),
        );
      case '/post_preview':
        return MaterialPageRoute(
            settings: settings,
            builder: (_) {
              if (args is Map) {
                return PostPreviewScreen(
                  path: args['path'],
                  isCamera: args['isCamera'],
                  image: args['image'],
                );
              }
              return null;
            });
      case '/post_details':
        return MaterialPageRoute(
            settings: settings,
            builder: (_) {
              if (args is Map) {
                return PostDetailScreen(
                  imagePathFromPostPreview: args['imagePathFromPostPreview'],
                  image: args['image'],
                  location: args['location'],
                  photoDate: args['date'],
                  isCamera: args['isCamera'],
                );
              }
              return null;
            });
    }
    return null;
  }
}
