import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function onSubmitted;
  final TextEditingController controller;
  SearchBar({
    Key key,
    this.onSubmitted,
    this.controller,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Color(0x199597a1),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 12.0,
          ),
          Icon(
            Icons.search_outlined,
            color: Colors.grey,
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onSubmitted: (val) {
                widget.onSubmitted();
              },
            ),
          ),
        ],
      ),
    );
  }
}
