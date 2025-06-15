import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/features/home/data/model/other_services_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OtherServicesWidget extends StatelessWidget {
  const OtherServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildServicesGrid()
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue[600]!,
                Colors.blue[700]!,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.grid_view_rounded,
              size: 22, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Services',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Choose what you need',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServicesGrid() {
    final services = _getServices();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Get.width < 400 ? 2 : 3,
          childAspectRatio: 1.1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return _buildServiceCard(services[index], index);
      },
    );
  }

  List<OtherServicesModel> _getServices() {
    return [
      const OtherServicesModel(
        color: Color(0xFF00C853),
        icon: Icons.currency_bitcoin,
        name: "Buy Crypto",
        route: RoutesConstant.buy_crypto,
      ),
      const OtherServicesModel(
        color: Color(0xFFFF3D00),
        icon: Icons.trending_down,
        name: "Sell Crypto",
        route: RoutesConstant.sell_crypto,
      ),
      const OtherServicesModel(
          color: Color(0xFFAD1457),
          icon: Icons.card_giftcard,
          name: "Buy GiftCard",
          route: RoutesConstant.buy_giftcard),
      const OtherServicesModel(
        color: Color(0xFF7B1FA2),
        icon: Icons.redeem,
        name: "Sell GiftCard",
        route: RoutesConstant.sell_giftcard,
      ),
      const OtherServicesModel(
        color: Color(0xFF1976D2),
        icon: Icons.phone_iphone,
        name: "Airtime",
        route: RoutesConstant.airtime,
      ),
      const OtherServicesModel(
        color: Color(0xFF0097A7),
        icon: Icons.signal_cellular_4_bar,
        name: "Data",
        route: RoutesConstant.data,
      ),
      const OtherServicesModel(
        color: Color(0xFFF57C00),
        icon: Icons.bolt,
        name: "Electricity",
        route: RoutesConstant.electricity,
      ),
      const OtherServicesModel(
        color: Color(0xFF689F38),
        icon: Icons.sports_esports,
        name: "Betting",
        route: RoutesConstant.betting,
      ),
      const OtherServicesModel(
        color: Color(0xFF303F9F),
        icon: Icons.live_tv,
        name: "TV",
        route: RoutesConstant.tv,
      ),
    ];
  }

  Widget _buildServiceCard(OtherServicesModel service, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onTap: () => Get.toNamed(service.route),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: service.color.withOpacity(0.1),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: service.color.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 6)),
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    splashColor: service.color.withOpacity(0.1),
                    highlightColor: service.color.withOpacity(0.05),
                    onTap: () {
                      // Add haptic feedback
                      HapticFeedback.lightImpact();
                      Get.toNamed(service.route);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  service.color.withOpacity(0.2),
                                  service.color.withOpacity(0.1)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: service.color.withOpacity(0.2),
                                  width: 1),
                            ),
                            child: Icon(service.icon,
                                color: service.color, size: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            service.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                              letterSpacing: -0.2,
                              height: 1.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Enhanced Compact Version with Modern Styling
class CompactOtherServicesWidget extends StatelessWidget {
  const CompactOtherServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[600]!, Colors.blue[700]!],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.grid_view_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Services',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'Quick access',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 12,
              children: _getCompactServices().asMap().entries.map((entry) {
                final index = entry.key;
                final service = entry.value;

                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 400 + (index * 80)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Opacity(
                        opacity: value,
                        child: GestureDetector(
                          onTap: () => Get.toNamed(service.route),
                          child: Container(
                            width: (Get.width - 60) / 4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: service.color.withOpacity(0.15),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: service.color.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                splashColor: service.color.withOpacity(0.1),
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  Get.toNamed(service.route);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 6,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              service.color.withOpacity(0.2),
                                              service.color.withOpacity(0.1),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          service.icon,
                                          color: service.color,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        service.name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1A1A1A),
                                          letterSpacing: -0.1,
                                          height: 1.0,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<OtherServicesModel> _getCompactServices() {
    return [
      const OtherServicesModel(
        color: Color(0xFF00C853),
        icon: Icons.currency_bitcoin,
        name: "Buy Crypto",
        route: RoutesConstant.buy_crypto,
      ),
      const OtherServicesModel(
        color: Color(0xFFFF3D00),
        icon: Icons.trending_down,
        name: "Sell Crypto",
        route: RoutesConstant.sell_crypto,
      ),
      const OtherServicesModel(
        color: Color(0xFFAD1457),
        icon: Icons.card_giftcard,
        name: "Buy GiftCard",
        route: RoutesConstant.buy_giftcard,
      ),
      const OtherServicesModel(
        color: Color(0xFF7B1FA2),
        icon: Icons.redeem,
        name: "Sell GiftCard",
        route: RoutesConstant.sell_giftcard,
      ),
      const OtherServicesModel(
        color: Color(0xFF1976D2),
        icon: Icons.phone_iphone,
        name: "Airtime",
        route: RoutesConstant.airtime,
      ),
      const OtherServicesModel(
        color: Color(0xFF0097A7),
        icon: Icons.signal_cellular_4_bar,
        name: "Data",
        route: RoutesConstant.data,
      ),
      const OtherServicesModel(
        color: Color(0xFFF57C00),
        icon: Icons.bolt,
        name: "Electricity",
        route: RoutesConstant.electricity,
      ),
      const OtherServicesModel(
        color: Color(0xFF689F38),
        icon: Icons.sports_esports,
        name: "Betting",
        route: RoutesConstant.betting,
      ),
      const OtherServicesModel(
          color: Color(0xFF303F9F),
          icon: Icons.live_tv,
          name: "TV",
          route: RoutesConstant.tv),
    ];
  }
}
