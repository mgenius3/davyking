import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/features/home/data/model/other_services_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtherServicesWidget extends StatelessWidget {
  const OtherServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 5,
          runSpacing: 20,
          children: [
            servicesContainer(
              data: const OtherServicesModel(
                color: Color(0x1950C2D6),
                icon: Icons
                    .currency_bitcoin, // Represents cryptocurrency purchase
                name: "Buy Crypto",
                route: RoutesConstant
                    .buy_crypto, // Note: Should this route be specific to crypto?
              ),
            ),
            servicesContainer(
              data: const OtherServicesModel(
                color: Color(0x1950C2D6),
                icon: Icons.sell, // Represents selling action
                name: "Sell Crypto",
                route: RoutesConstant
                    .sell_crypto, // Note: Should this route be specific to crypto?
              ),
            ),
            servicesContainer(
              data: const OtherServicesModel(
                  color: Color(0x1950C2D6),
                  icon: Icons.card_giftcard, // Perfect for gift card purchase
                  name: "Buy GiftCard",
                  route: RoutesConstant.buy_giftcard),
            ),
            servicesContainer(
              data: const OtherServicesModel(
                  color: Color(0x1950C2D6),
                  icon: Icons
                      .attach_money, // Suitable for redeeming/selling a gift card
                  name: "Sell GiftCard",
                  route: RoutesConstant.sell_giftcard),
            ),
            servicesContainer(
              data: const OtherServicesModel(
                  color: Color(0x1950C2D6),
                  icon: Icons.phone_android, // Suitable for airtime
                  name: "Airtime",
                  route: RoutesConstant.airtime),
            ),
            servicesContainer(
              data: const OtherServicesModel(
                  color: Color(0x1950C2D6),
                  icon: Icons.signal_cellular_alt, // Represents mobile data
                  name: "Data",
                  route: RoutesConstant.data),
            ),
            servicesContainer(
              data: const OtherServicesModel(
                  color: Color(0x1950C2D6),
                  icon: Icons.electric_meter, // Represents mobile data
                  name: "Electricity",
                  route: RoutesConstant.electricity),
            ),
            servicesContainer(
              data: const OtherServicesModel(
                  color: Color(0x1950C2D6),
                  icon: Icons.sports_soccer, // Represents mobile data
                  name: "Betting",
                  route: RoutesConstant.betting),
            ),
            servicesContainer(
              data: const OtherServicesModel(
                  color: Color(0x1950C2D6),
                  icon: Icons.tv, // Represents mobile data
                  name: "TV",
                  route: RoutesConstant.tv),
            ),
          ],
        ),
      ],
    ));
  }
}

Widget servicesContainer({required OtherServicesModel data}) {
  return GestureDetector(
      onTap: () {
        Get.toNamed(data.route);
      },
      child: SizedBox(
        // width: Get.width * .18,
        width: Get.width * .24,
        child: Column(
          children: [
            Container(
                width: 43.90,
                height: 41.51,
                decoration: ShapeDecoration(
                  color: data.color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Icon(data.icon)),
            const SizedBox(height: 10),
            SizedBox(
              width: 43.90,
              // height: 12.45,
              child: Text(
                data.name,
                textAlign: TextAlign.center,
                style: Theme.of(Get.context!)
                    .textTheme
                    .displayMedium
                    ?.copyWith(fontSize: 8, fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      ));
}
