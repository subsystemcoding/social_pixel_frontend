import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/channel_bloc/channel_bloc.dart';
import 'package:socialpixel/bloc/message_bloc/bloc/message_bloc.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:socialpixel/bloc/profile_bloc/profile_bloc.dart';
import 'package:socialpixel/route_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (context) => PostBloc(),
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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
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
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
            bodyText2: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff7041ee)),
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
                fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
            bodyText2: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
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
    );
  }
}
