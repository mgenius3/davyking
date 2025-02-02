import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/models/persistent_tab_item_model.dart';
import 'package:davyking/core/widgets/bottom_navigation_widget.dart';
import 'package:davyking/core/widgets/persistent_bottom_nav_bar.dart';
import 'package:davyking/features/giftcards/presentation/screens/index_screen.dart';
import 'package:davyking/features/home/data/model/header_model.dart';
import 'package:davyking/features/home/presentation/widget/header_widget.dart';
import 'package:davyking/features/home/presentation/widget/other_services_widget.dart';
import 'package:davyking/features/profile/presentation/screen/index_screen.dart';
import 'package:flutter/material.dart';
import '../widget/balance_display_widget.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _tab1navigatorKey = GlobalKey<NavigatorState>();
  final _tab2navigatorKey = GlobalKey<NavigatorState>();
  final _tab3navigatorKey = GlobalKey<NavigatorState>();
  final _tab4navigatorKey = GlobalKey<NavigatorState>();
  final _tab5navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: SafeArea(
    //     child: Container(
    //       margin: Spacing.defaultMarginSpacing,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           homeHeaderWidget(
    //             const HomeHeaderModel(firstName: "Moses"),
    //           ),
    //           const SizedBox(height: 37.82),
    //           BalanceDisplayWidget(),
    //           const SizedBox(height: 26),
    //           OtherServicesWidget()
    //         ],
    //       ),
    //     ),
    //   ),
    //   bottomNavigationBar: const BottomNavigationWidget(currentIndex: 0),
    // );

    return PersistentBottomBarScaffold(items: [
      PersistentTabItem(
          navigatorkey: _tab1navigatorKey,
          title: 'Home',
          icon: Icons.home,
          tab: Scaffold(
            body: SafeArea(
              child: Container(
                margin: Spacing.defaultMarginSpacing,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    homeHeaderWidget(
                      const HomeHeaderModel(firstName: "Moses"),
                    ),
                    const SizedBox(height: 37.82),
                    BalanceDisplayWidget(),
                    const SizedBox(height: 26),
                    OtherServicesWidget()
                  ],
                ),
              ),
            ),
            // bottomNavigationBar: const BottomNavigationWidget(currentIndex: 0),
          )),
      PersistentTabItem(
          navigatorkey: _tab2navigatorKey,
          title: 'Gift Cards',
          icon: Icons.wallet_giftcard,
          tab: GiftCardScreen()),
      PersistentTabItem(
          navigatorkey: _tab5navigatorKey,
          title: 'Profile',
          icon: CupertinoIcons.profile_circled,
          tab: ProfileIndexScreen()),
    ]);
  }
}
