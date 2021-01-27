import 'package:flutter/material.dart';
import 'package:socialpixel/widgets/raised_container.dart';

class ForgetScreen extends StatelessWidget {
  const ForgetScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafbfd),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Forgot Password?",
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.headline1,
          ),
          SizedBox(
            height: 40.0,
          ),
          buildTextField(context, hintText: "Enter email"),
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
                "Send Reset Link",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Text.rich(
            TextSpan(
              text: "Go back to ",
              style: Theme.of(context).primaryTextTheme.bodyText2,
              children: [
                TextSpan(
                  text: "Login",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          Text.rich(
            TextSpan(
              text: "New around here? ",
              style: Theme.of(context).primaryTextTheme.bodyText2,
              children: [
                TextSpan(
                  text: "Sign in",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildTextField(BuildContext context, {String hintText}) {
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
        ),
      ),
    );
  }
}
