import 'package:flutter/material.dart';
import 'package:socialpixel/widgets/raised_container.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafbfd),
      body: Column(
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
          buildTextField(context, hintText: "Enter username"),
          SizedBox(
            height: 12.0,
          ),
          buildTextField(context, hintText: "Enter email"),
          SizedBox(
            height: 12.0,
          ),
          buildTextField(context, hintText: "Enter Password"),
          SizedBox(
            height: 12.0,
          ),
          buildTextField(context, hintText: "Confirm Password"),
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
