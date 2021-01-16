import 'package:flutter/material.dart';

class CustomTabBar {
  PreferredSizeWidget tabBar(BuildContext context, {List<Widget> tabs}) {
    return TabBar(
      labelPadding: EdgeInsets.symmetric(vertical: 16.0),
      tabs: tabs,
      labelStyle: Theme.of(context).tabBarTheme.labelStyle,
      unselectedLabelStyle: Theme.of(context).tabBarTheme.unselectedLabelStyle,
    );
  }
}
