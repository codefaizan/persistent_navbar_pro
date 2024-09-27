library persistent_navbar_pro;

import 'package:flutter/material.dart';
import 'navbar_item.dart';

export 'navbar_item.dart';

class PersistentNavbar extends StatefulWidget {
  const PersistentNavbar({
    super.key,
    required this.items,
    required this.screens,
    // this.onTap,
    this.elevation,
    this.type,
    this.backgroundColor,
    this.iconSize = 24.0,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.fixedColor,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.selectedFontSize = 10.0,
    this.unselectedFontSize = 10.0,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showSelectedLabels,
    this.showUnselectedLabels,
    this.mouseCursor,
    this.enableFeedback,
    this.landscapeLayout,
    this.useLegacyColorScheme = true,
    this.routes,
    this.initialIndex = 0,
  });
  final int initialIndex;
  final List<Widget> screens;
  final List<NavBarItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color? fixedColor;
  final double selectedFontSize;
  final double unselectedFontSize;
  final bool? showUnselectedLabels;
  final BottomNavigationBarType? type;
  final double? elevation;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool? showSelectedLabels;
  final MouseCursor? mouseCursor;
  final bool? enableFeedback;
  final bool useLegacyColorScheme;
  final BottomNavigationBarLandscapeLayout? landscapeLayout;
  final double iconSize;
  final Map<String, WidgetBuilder>? routes;

  @override
  State<PersistentNavbar> createState() => _PersistentNavbarState();
}

class _PersistentNavbarState extends State<PersistentNavbar> {
  List<GlobalKey<NavigatorState>>? _destinationKeys;
  int _currentIndex = 0;

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    _destinationKeys = List<GlobalKey<NavigatorState>>.generate(
            widget.screens.length, (int index) => GlobalKey<NavigatorState>())
        .toList();
    super.initState();
  }

  changeScreen(int index) {
    if (index == _currentIndex &&
        widget.items[index].maintainTabStack &&
        _destinationKeys![index].currentState!.canPop()) {
      _destinationKeys![index].currentState!.popUntil((route) => route.isFirst);
    } else if (!widget.items[index].maintainTabStack &&
        _destinationKeys![index].currentState!.canPop()) {
      _destinationKeys![index].currentState!.popUntil((route) => route.isFirst);
    }
    _currentIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          elevation: widget.elevation,
          enableFeedback: widget.enableFeedback,
          iconSize: widget.iconSize,
          landscapeLayout: widget.landscapeLayout,
          mouseCursor: widget.mouseCursor,
          selectedIconTheme: widget.selectedIconTheme,
          selectedLabelStyle: widget.selectedLabelStyle,
          showSelectedLabels: widget.showSelectedLabels,
          unselectedIconTheme: widget.unselectedIconTheme,
          unselectedLabelStyle: widget.unselectedLabelStyle,
          useLegacyColorScheme: widget.useLegacyColorScheme,
          fixedColor: widget.fixedColor,
          backgroundColor: widget.backgroundColor,
          currentIndex: _currentIndex,
          onTap: (value) => changeScreen(value),
          selectedItemColor: widget.selectedItemColor,
          unselectedItemColor: widget.unselectedItemColor,
          showUnselectedLabels: widget.showUnselectedLabels,
          type: widget.type,
          selectedFontSize: widget.selectedFontSize,
          unselectedFontSize: widget.unselectedFontSize,
          items: widget.items.map((e) => e.item!).toList(),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: List.generate(
              widget.screens.length,
              (index) => DestinationSetter(
                    screen: widget.screens[index],
                    navKey: _destinationKeys![index],
                    routes: widget.routes,
                  )),
        ));
  }
}

class DestinationSetter extends StatelessWidget {
  const DestinationSetter(
      {super.key, required this.screen, required this.navKey, this.routes});
  final Widget screen;
  final Map<String, WidgetBuilder>? routes;
  final GlobalKey<NavigatorState> navKey;

  Future<bool> onWillPop() async {
    if (navKey.currentState!.canPop()) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        bool canPop = await onWillPop();
        if (canPop && context.mounted) {
          navKey.currentState!.pop();
        } else {
          return;
        }
      },
      child: Navigator(
        key: navKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            // maintainState: false,
            settings: settings,
            builder: (context) {
              if (routes != null) {
                if (routes!.containsKey(settings.name)) {
                  return routes![settings.name]!(context);
                }
              }
              return screen;
            },
          );
        },
      ),
    );
  }
}
