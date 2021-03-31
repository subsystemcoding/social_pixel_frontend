import 'package:flutter/material.dart';

class CheckboxExpansionTile extends StatefulWidget {
  final List<Widget> children;
  final String title;
  final bool isExpandedInitially;
  CheckboxExpansionTile(
      {Key key, this.children, this.title, this.isExpandedInitially = false})
      : super(key: key);

  @override
  _CheckboxExpansionTileState createState() => _CheckboxExpansionTileState();
}

class _CheckboxExpansionTileState extends State<CheckboxExpansionTile>
    with SingleTickerProviderStateMixin {
  bool isExpanded;
  Animation<double> animation;
  AnimationController expandController;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpandedInitially;
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    animation = CurvedAnimation(parent: expandController, curve: Curves.easeIn);
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (isExpanded) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _runExpandCheck();
    List<Widget> children = [];
    children.addAll(widget.children);
    return Column(
      children: [
        Row(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 12,
                ),
                Checkbox(
                  value: isExpanded,
                  onChanged: (val) {
                    setState(() {
                      isExpanded = val;
                    });
                  },
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ],
        ),
        SizeTransition(
          sizeFactor: animation,
          axisAlignment: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ],
    );
  }
}
