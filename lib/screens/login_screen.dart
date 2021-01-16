import 'package:flutter/material.dart';
import 'package:socialpixel/widgets/raised_container.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafbfd),
      body: Column(
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
          RaisedContainer(
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 28.0),
            child: Container(
              child: TextField(
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.symmetric(horizontal: 28.0),
                  hintText: "Enter username",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          RaisedContainer(
            margin: EdgeInsets.symmetric(horizontal: 28.0),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Enter password", border: InputBorder.none),
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
              onPressed: () {},
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            "Forget password?",
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.bodyText2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "New around here? ",
                style: Theme.of(context).primaryTextTheme.bodyText2,
              ),
              Text(
                "Sign In",
                style: TextStyle(
                    fontSize: 16.0, color: Theme.of(context).accentColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
