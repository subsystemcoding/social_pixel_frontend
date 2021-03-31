import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/auth_bloc/auth_bloc.dart';
import 'package:socialpixel/widgets/raised_container.dart';

class LoginScreen extends StatelessWidget {
  final values = {
    'username': '',
    'password': '',
  };
  final Map<String, dynamic> errors = {
    'nonFieldErrors': {},
    'username': {},
    'password': {},
  };
  LoginScreen({Key key}) : super(key: key);
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
          if (state is LoginSuccessful) {
            Navigator.of(context).pushNamed("/home");
          } else if (state is AuthError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("You may have lost connection to the server"),
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthWait) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is LoginUnsuccessful) {
              errors['nonFieldErrors'] =
                  state.errors.containsKey('nonFieldErrors')
                      ? state.errors['nonFieldErrors'][0]
                      : {};
              errors['username'] = state.errors.containsKey('username')
                  ? state.errors['username'][0]
                  : {};
              errors['password'] = state.errors.containsKey('password')
                  ? state.errors['password'][0]
                  : {};
              print(state.errors);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).primaryTextTheme.headline1,
                ),
                SizedBox(
                  height: 40.0,
                ),
                _buildErrorMessage(context, errors['nonFieldErrors']),
                _buildErrorMessage(context, errors['username']),
                RaisedContainer(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    child: TextField(
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        hintText: "Enter username",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        values['username'] = value;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                _buildErrorMessage(context, errors['password']),
                RaisedContainer(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  color: Colors.white,
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Enter password", border: InputBorder.none),
                    onChanged: (value) {
                      values['password'] = value;
                    },
                  ),
                ),
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
                      "Login",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      print('priniting username and password');
                      print(values['username']);
                      print(values['password']);
                      BlocProvider.of<AuthBloc>(context).add(
                        Login(
                            username: values['username'],
                            password: values['password']),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                GestureDetector(
                  child: Text(
                    "Forget password?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).primaryTextTheme.bodyText2,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/forget');
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "New around here? ",
                      style: Theme.of(context).primaryTextTheme.bodyText2,
                    ),
                    GestureDetector(
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).accentColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/register');
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context, Map<dynamic, dynamic> error) {
    String message = error.isNotEmpty ? error['message'] : null;
    return error.isEmpty
        ? Container()
        : Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
            child: Text(
              '• $message',
              style: Theme.of(context).primaryTextTheme.overline,
            ));
  }
}
