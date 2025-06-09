import 'package:davyking/core/controllers/transaction_log_controller.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/models/persistent_tab_item_model.dart';
import 'package:davyking/core/widgets/persistent_bottom_nav_bar.dart';
import 'package:davyking/core/widgets/transaction_logs_widget.dart';
import 'package:davyking/features/ads/presentation/screens/ad_screen.dart';
import 'package:davyking/features/airtime/controllers/index_controller.dart';
import 'package:davyking/features/crypto/controllers/index_controller.dart';
import 'package:davyking/features/crypto/presentation/screens/index_screen.dart';
import 'package:davyking/features/giftcards/controllers/index_controller.dart';
import 'package:davyking/features/giftcards/presentation/screens/index_screen.dart';
import 'package:davyking/features/home/presentation/widget/header_widget.dart';
import 'package:davyking/features/home/presentation/widget/other_services_widget.dart';
import 'package:davyking/features/profile/presentation/screen/index_screen.dart';
import 'package:davyking/features/wallet/presentation/screens/index_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/balance_display_widget.dart';
import 'package:flutter/cupertino.dart';
import './chat_screen.dart';

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
    return PersistentBottomBarScaffold(items: [
      PersistentTabItem(
          navigatorkey: _tab1navigatorKey,
          title: 'Home',
          icon: Icons.home,
          tab: Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: Spacing.defaultMarginSpacing,
                    child: HomeHeaderWidget(),
                  ),
                  const SizedBox(height: 10), // Optional spacing
                  // Scrollable Content
                  Expanded(
                      child: RefreshIndicator(
                    onRefresh: () async {
                      await Get.find<UserAuthDetailsController>()
                          .getUserDetail();
                      await Get.find<TransactionLogController>()
                          .fetchTransactionLogs();
                      await Get.find<GiftCardController>()
                          .fetchAllGiftCardsTransaction();
                      await Get.find<CryptoController>()
                          .fetchAllCryptosTransaction();
                    },
                    child: SingleChildScrollView(
                      child: Container(
                        margin: Spacing.defaultMarginSpacing,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BalanceDisplayWidget(),
                            const SizedBox(height: 26),
                            OtherServicesWidget(),
                            const SizedBox(height: 26),
                            SizedBox(
                                width: Get.width,
                                // height: 130,
                                child: AdScreen()),
                            const SizedBox(height: 20),
                            SizedBox(
                                width: Get.width,
                                // height: 500,
                                child: RecentTransactionsWidget()),
                          ],
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Get.to(() => const ChatScreen());
                },
                backgroundColor: DarkThemeColors.background,
                child: const Icon(Icons.support_agent_outlined,
                    color: Colors.white)),
          )),
      PersistentTabItem(
          navigatorkey: _tab2navigatorKey,
          title: 'Gift Cards',
          icon: Icons.wallet_giftcard,
          tab: GiftCardScreen()),
      PersistentTabItem(
          navigatorkey: _tab3navigatorKey,
          title: 'Crypto',
          icon: Icons.currency_bitcoin,
          tab: CryptoScreen()),
      PersistentTabItem(
          navigatorkey: _tab4navigatorKey,
          title: 'Wallet',
          icon: Icons.wallet,
          tab: WalletScreen()),
      PersistentTabItem(
          navigatorkey: _tab5navigatorKey,
          title: 'Profile',
          icon: CupertinoIcons.profile_circled,
          tab: ProfileIndexScreen())
    ]);
  }
}
