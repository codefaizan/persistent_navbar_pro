import 'package:flutter/material.dart';

class NavBarItem {
  NavBarItem(
      {this.maintainTabStack = false,
      required this.icon,
      required this.label,
      this.activeIcon,
      this.backgroundColor,
      this.tooltip,
      this.key}) {
    item = BottomNavigationBarItem(
        icon: icon,
        activeIcon: activeIcon,
        label: label,
        backgroundColor: backgroundColor,
        tooltip: tooltip,
        key: key);
  }
  Key? key;
  Widget icon;
  String? label;
  Widget? activeIcon;
  Color? backgroundColor;
  BottomNavigationBarItem? item;
  String? tooltip;
  bool maintainTabStack;
}
