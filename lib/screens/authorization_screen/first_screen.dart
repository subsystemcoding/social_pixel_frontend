import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/auth_bloc/auth_bloc.dart';
import 'package:socialpixel/bloc/message_bloc/bloc/message_bloc.dart';
import 'package:socialpixel/widgets/raised_container.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(LoginWithHive());
    return Scaffold(
        backgroundColor: Color(0xfffafbfd),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoginSuccessful) {
              Navigator.of(context).pushNamed('/home');
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthWait) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is AuthError) {
                return _buildBody(context);
              } else if (state is LoginUnsuccessful) {
                return _buildBody(context);
              } else if (state is AuthInitial) {
                return _buildBody(context);
              }
              return _buildBody(context);
            },
          ),
        ));
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 208,
          height: 208,
          child: Image(
            image: AssetImage('assets/images/logo.jpg'),
            // image: NetworkImage(
            //     "https://cdn.logo.com/hotlink-ok/logo-social.png"),
          ),
        ),
        Text(
          "socialpixel.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 40,
          ),
        ),
        SizedBox(
          height: 60,
        ),
        RaisedContainer(
          child: TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                backgroundColor: Theme.of(context).accentColor,
                primary: Theme.of(context).primaryColor),
            child: Text(
              "Login",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/login');
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        RaisedContainer(
          child: TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                primary: Theme.of(context).accentColor),
            child: Text(
              "Register",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/register');
            },
          ),
        ),
      ],
    );
  }
}
