import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/auth_bloc/auth_bloc.dart';
import 'package:socialpixel/bloc/channel_bloc/channel_bloc.dart';
import 'package:socialpixel/bloc/game_bloc/game_bloc.dart';
import 'package:socialpixel/bloc/geo_bloc/geo_bloc.dart';
import 'package:socialpixel/bloc/leaderboard_bloc/leaderboard_bloc.dart';
import 'package:socialpixel/bloc/map_bloc/map_bloc.dart';
import 'package:socialpixel/bloc/message_bloc/bloc/message_bloc.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:socialpixel/bloc/profile_bloc/profile_bloc.dart';
import 'package:socialpixel/bloc/tflite_bloc/tflite_bloc.dart';
import 'package:socialpixel/data/graphql_client.dart';
import 'package:socialpixel/data/repos/hive_repository.dart';
import 'package:socialpixel/data/repos/message_managament.dart';
import 'package:socialpixel/data/repos/tflite_repository.dart';
import 'package:socialpixel/route_generator.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveRepository().init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer timer;
  @override
  void initState() {
    super.initState();

    TfLiteRepository().init();
    //GraphqlClient();
  }

  @override
  void dispose() {
    //GraphqlClient().client.close();
    //timer.cancel();
    TfLiteRepository().dispose();
    HiveRepository().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (context) => PostBloc(),
        ),
        BlocProvider<TfliteBloc>(
          create: (context) => TfliteBloc(),
        ),
        BlocProvider<MapBloc>(
          create: (context) => MapBloc(),
        ),
        BlocProvider<GeoBloc>(
          create: (context) => GeoBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
        ),
        BlocProvider<ChannelBloc>(
          create: (context) => ChannelBloc(),
        ),
        BlocProvider<MessageBloc>(
          create: (context) => MessageBloc(),
        ),
        BlocProvider<LeaderboardBloc>(
          create: (context) => LeaderboardBloc(),
        ),
        BlocProvider<GameBloc>(
          create: (context) => GameBloc(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
          }
        },
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            accentIconTheme: IconThemeData(
              color: Color(0xff7041ee),
            ),
            //primaryIconTheme: IconThemeData(color: Colors.white),
            fontFamily: "Circular",
            primarySwatch: Colors.blue,
            primaryColor: Colors.white,
            accentColor: Color(0xff7041ee),
            disabledColor: Color(0x1a7041ee),
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            //Special case thems
            textTheme: TextTheme(
              bodyText1: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              bodyText2: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff7041ee),
              ),
              headline6: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            primaryTextTheme: TextTheme(
              headline1: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
              headline2: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
              headline3: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
              headline4: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
              subtitle1: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Color(0xff9597a1),
              ),
              subtitle2: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: Color(0xff9597a1),
              ),
              bodyText1: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
              bodyText2: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
              overline: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.red,
              ),
            ),
            tabBarTheme: TabBarTheme(
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
                unselectedLabelStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey),
          ),
          onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
          initialRoute: '/',
          // home: MultiBlocProvider(
          //   providers: [
          //     BlocProvider<PostBloc>(
          //       create: (context) => PostBloc(),
          //     ),
          //     BlocProvider<MessageBloc>(
          //       create: (context) => MessageBloc(),
          //     ),
          //   ],
          //   child: ForgetScreen(),
          // ),
        ),
      ),
    );
  }
}
