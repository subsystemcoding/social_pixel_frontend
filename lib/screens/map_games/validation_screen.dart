import 'package:flutter/material.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/widgets/custom_buttons.dart';

class ValidationScreen extends StatefulWidget {
  ValidationScreen({Key key}) : super(key: key);

  @override
  _ValidationScreenState createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  Post originalPost;
  Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Validate"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 12,
          ),
          Text(
            "Original Post",
            style: Theme.of(context).textTheme.headline6,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image(
              image: NetworkImage(originalPost.postImageLink),
            ),
          ),
          Text(
            "Compared Post",
            style: Theme.of(context).textTheme.headline6,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image(
              image: NetworkImage(post.postImageLink),
            ),
          ),
          Row(
            children: [
              CustomButtons.standardButton(context, text: "Not Correct", onPressed: () {

              }, type: ButtonStyleType.DisabledPurpleButton),
              SizedBox(width: 12.0,),
              CustomButtons.standardButton(context, text: "Correct", onPressed: () {

              }, ),
            ],
          ),
        ],
      ),
    );
  }
}
