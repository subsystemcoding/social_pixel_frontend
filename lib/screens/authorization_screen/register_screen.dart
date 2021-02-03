import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/auth_bloc/auth_bloc.dart';
import 'package:socialpixel/widgets/raised_container.dart';

class RegisterScreen extends StatelessWidget {
  final values = {
    'username': '',
    'email': '',
    'password1': '',
    'password2': '',
  };
  RegisterScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: Color(0xfffafbfd),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RegistrationSuccessful) {
              Navigator.of(context).pushNamed("/home");
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthWait) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return _buildBody(context);
            },
          ),
        ));
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Register",
              textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.headline1,
            ),
            SizedBox(
              height: 40.0,
            ),
            buildTextField(context,
                hintText: "Enter username", valueToChange: 'username'),
            SizedBox(
              height: 12.0,
            ),
            buildTextField(context,
                hintText: "Enter email", valueToChange: 'email'),
            SizedBox(
              height: 12.0,
            ),
            buildTextField(context,
                hintText: "Enter Password", valueToChange: 'password1'),
            SizedBox(
              height: 12.0,
            ),
            buildTextField(context,
                hintText: "Confirm Password", valueToChange: 'password2'),
            SizedBox(
              height: 12.0,
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
                  "Register",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  print('printing values at register_screen:91');
                  print(values);
                  BlocProvider.of<AuthBloc>(context).add(
                    Register(
                      username: values['username'],
                      email: values['email'],
                      password1: values['password1'],
                      password2: values['password2'],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: Theme.of(context).primaryTextTheme.bodyText2,
                ),
                Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 16.0, color: Theme.of(context).accentColor),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "You are completely safe.",
              textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.bodyText2,
            ),
            Text(
              "Read our Terms & Conditions.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).accentColor),
            )
          ],
        ),
      ],
    );
  }

  Widget buildTextField(BuildContext context,
      {String hintText, String valueToChange}) {
    return RaisedContainer(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 28.0),
      child: Container(
        child: TextField(
          decoration: InputDecoration(
            //contentPadding: EdgeInsets.symmetric(horizontal: 28.0),
            hintText: hintText,
            border: InputBorder.none,
          ),
          onChanged: (value) {
            values[valueToChange] = value;
          },
        ),
      ),
    );
  }
}
