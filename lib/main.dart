import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/post_bloc/post_bloc.dart';
import 'package:socialpixel/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Circular",
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        accentColor: Color(0xff7041ee),
        disabledColor: Color(0x1a7041ee),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
              fontSize: 36.0, fontWeight: FontWeight.w700, color: Colors.black),
          headline2: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black),
          subtitle1: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: Color(0xff9597a1)),
          bodyText1: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
        ),
      ),
      home: BlocProvider(
        create: (context) => PostBloc(),
        child: HomeScreen(),
      ),
    );
  }
}
