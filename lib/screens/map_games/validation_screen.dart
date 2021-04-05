import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/map_bloc/map_bloc.dart';
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
  int validateId;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MapBloc>(context).add(GetValidatePost());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Validate"),
      ),
      body: BlocListener<MapBloc, MapState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            if (state is ValidatingPost || state is GettingValidatePost) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PostValidated) {
              originalPost = null;
              post = null;
              validateId = 0;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Post is validated. Would you like to validate another post",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButtons.standardButton(context, text: "Yes",
                              onPressed: () {
                            BlocProvider.of<MapBloc>(context)
                                .add(GetValidatePost());
                          }),
                          SizedBox(width: 12.0),
                          CustomButtons.standardButton(context, text: "No",
                              onPressed: () {
                            Navigator.of(context)
                                .popUntil(ModalRoute.withName("/map"));
                          })
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is PostValidationError) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No more post available to validate. Please try again shortly after a while.",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CustomButtons.standardButton(context, text: "Okay",
                          onPressed: () {
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName("/map"));
                      })
                    ],
                  ),
                ),
              );
            } else if (state is PostValidateLoaded) {
              originalPost = state.originalPost;
              post = state.comparedPost;
              validateId = state.validateId;
            }
            if (originalPost == null) {
              return Center(
                child: Container(),
              );
            }
            return ListView(
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
                SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image(
                    image: NetworkImage(originalPost.postImageLink),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Compared Post:",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 12,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image(
                    image: NetworkImage(post.postImageLink),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtons.standardButton(context, text: "Not Correct",
                        onPressed: () {
                      BlocProvider.of<MapBloc>(context)
                          .add(ValidatePost(validateId, false));
                    }, type: ButtonStyleType.DisabledPurpleButton),
                    SizedBox(
                      width: 12.0,
                    ),
                    CustomButtons.standardButton(
                      context,
                      text: "Correct",
                      onPressed: () {
                        BlocProvider.of<MapBloc>(context)
                            .add(ValidatePost(validateId, true));
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
}
