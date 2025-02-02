import 'package:davyking/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:davyking/core/models/persistent_tab_item_model.dart';
import 'package:davyking/core/states/mode.dart';
import 'package:get/get.dart';

class PersistentBottomBarScaffold extends StatefulWidget {
  /// pass the required items for the tabs and BottomNavigationBar
  final List<PersistentTabItem> items;

  const PersistentBottomBarScaffold({Key? key, required this.items})
      : super(key: key);

  @override
  _PersistentBottomBarScaffoldState createState() =>
      _PersistentBottomBarScaffoldState();
}

class _PersistentBottomBarScaffoldState
    extends State<PersistentBottomBarScaffold> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final LightningModeController lightningModeController =
        Get.find<LightningModeController>();

    return WillPopScope(
      onWillPop: () async {
        /// Check if curent tab can be popped
        if (widget.items[_selectedTab].navigatorkey?.currentState?.canPop() ??
            false) {
          widget.items[_selectedTab].navigatorkey?.currentState?.pop();
          return false;
        } else {
          // if current tab can't be popped then use the root navigator
          return true;
        }
      },
      child: Obx(() => Scaffold(
            /// Using indexedStack to maintain the order of the tabs and the state of the
            /// previously opened tab
            body: IndexedStack(
              index: _selectedTab,
              children: widget.items
                  .map((page) => Navigator(
                        /// Each tab is wrapped in a Navigator so that naigation in
                        /// one tab can be independent of the other tabs
                        key: page.navigatorkey,
                        onGenerateInitialRoutes: (navigator, initialRoute) {
                          return [
                            MaterialPageRoute(builder: (context) => page.tab)
                          ];
                        },
                      ))
                  .toList(),
            ),

            /// Define the persistent bottom bar
            bottomNavigationBar: BottomNavigationBar(
                unselectedItemColor:
                    lightningModeController.currentMode.value.mode == "light"
                        ? const Color(0xFF000000)
                        : const Color(0xFFFFFFFF),
                selectedItemColor: DarkThemeColors.primaryColor,
                currentIndex: _selectedTab,
                onTap: (index) {
                  /// Check if the tab that the user is pressing is currently selected
                  if (index == _selectedTab) {
                    /// if you want to pop the current tab to its root then use
                    widget.items[index].navigatorkey?.currentState
                        ?.popUntil((route) => route.isFirst);

                    /// if you want to pop the current tab to its last page
                    /// then use
                    // widget.items[index].navigatorkey?.currentState?.pop();
                  } else {
                    setState(() {
                      _selectedTab = index;
                    });
                  }
                },
                items: widget.items
                    .map((item) => BottomNavigationBarItem(
                        icon: Icon(item.icon), label: item.title))
                    .toList()),
          )),
    );
  }
}
