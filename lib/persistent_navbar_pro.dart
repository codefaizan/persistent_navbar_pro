/// A customizable persistent bottom navigation bar for switching between
/// multiple screens while maintaining navigation stacks for each tab.
library persistent_navbar_pro;

import 'package:flutter/material.dart';
import 'navbar_item.dart';

export 'navbar_item.dart';

/// A [StatefulWidget] that creates a persistent bottom navigation bar.
class PersistentNavbar extends StatefulWidget {
  /// Creates a persistent navigation bar.
  ///
  /// The [items] and [screens] parameters must not be null.
  const PersistentNavbar({
    super.key,
    required this.items,
    required this.screens,
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

  /// The index of the initial selected tab.
  final int initialIndex;

  /// The list of widgets representing the screens for each tab.
  final List<Widget> screens;

  /// The items to display in the bottom navigation bar.
  final List<NavBarItem> items;

  /// The background color of the navigation bar.
  final Color? backgroundColor;

  /// The color of the selected item.
  final Color? selectedItemColor;

  /// The color of the unselected item.
  final Color? unselectedItemColor;

  /// The color used when [BottomNavigationBar.type] is [BottomNavigationBarType.fixed].
  final Color? fixedColor;

  /// The font size of the selected item's label.
  final double selectedFontSize;

  /// The font size of the unselected item's label.
  final double unselectedFontSize;

  /// Whether to show the labels for unselected items.
  final bool? showUnselectedLabels;

  /// The type of the [BottomNavigationBar].
  final BottomNavigationBarType? type;

  /// The elevation of the navigation bar.
  final double? elevation;

  /// The theme for the icons of the selected item.
  final IconThemeData? selectedIconTheme;

  /// The theme for the icons of the unselected items.
  final IconThemeData? unselectedIconTheme;

  /// The text style for the selected item's label.
  final TextStyle? selectedLabelStyle;

  /// The text style for the unselected items' labels.
  final TextStyle? unselectedLabelStyle;

  /// Whether to show the labels for selected items.
  final bool? showSelectedLabels;

  /// The cursor to display when interacting with the navigation bar.
  final MouseCursor? mouseCursor;

  /// Whether to enable feedback sounds or haptics.
  final bool? enableFeedback;

  /// Whether to use the legacy color scheme.
  final bool useLegacyColorScheme;

  /// The layout of the navigation bar in landscape mode.
  final BottomNavigationBarLandscapeLayout? landscapeLayout;

  /// The size of the icons in the navigation bar.
  final double iconSize;

  /// A map of routes for additional navigation inside each screen.
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

  /// Changes the currently visible screen based on the [index].
  ///
  /// If the current screen has a navigation stack and [maintainTabStack]
  /// is set to true, the stack will be reset to the initial route.
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
          ),
        ),
      ),
    );
  }
}

/// A widget that wraps a screen and provides navigation handling
/// for that specific screen's tab.
class DestinationSetter extends StatelessWidget {
  /// Creates a widget that provides navigation handling for the screen.
  const DestinationSetter({
    super.key,
    required this.screen,
    required this.navKey,
    this.routes,
  });

  /// The widget that represents the screen.
  final Widget screen;

  /// The map of routes for additional navigation.
  final Map<String, WidgetBuilder>? routes;

  /// The [NavigatorState] key for this screen.
  final GlobalKey<NavigatorState> navKey;

  /// Handles the back button press. If there are items in the navigation
  /// stack, it pops the stack.
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
            settings: settings,
            builder: (context) {
              if (routes != null && routes!.containsKey(settings.name)) {
                return routes![settings.name]!(context);
              }
              return screen;
            },
          );
        },
      ),
    );
  }
}
