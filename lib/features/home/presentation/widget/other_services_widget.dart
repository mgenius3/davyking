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
          alignment: WrapAlignment.spaceAround,
          spacing: 5,
          runSpacing: 20,
          children: [
            servicesContainer(
                data: const OtherServicesModel(
                    color: Color(0x1950C2D6),
                    icon: Icons.phone_android,
                    name: "Airtime",
                    route: RoutesConstant.airtime)),
            servicesContainer(
                data: const OtherServicesModel(
                    color: Color(0x1950C2D6),
                    icon: Icons.phone_android,
                    name: "Data",
                    route: RoutesConstant.airtime)),
            servicesContainer(
                data: const OtherServicesModel(
                    color: Color(0x1950C2D6),
                    icon: Icons.currency_exchange,
                    name: "Buy Crypto",
                    route: RoutesConstant.airtime)),
            servicesContainer(
                data: const OtherServicesModel(
                    color: Color(0x1950C2D6),
                    icon: Icons.currency_bitcoin,
                    name: "Sell Crypto",
                    route: RoutesConstant.airtime)),
            servicesContainer(
                data: const OtherServicesModel(
                    color: Color(0x1950C2D6),
                    icon: Icons.phone_android,
                    name: "Buy GiftCard",
                    route: RoutesConstant.buy_giftcard)),
            servicesContainer(
                data: const OtherServicesModel(
                    color: Color(0x1950C2D6),
                    icon: Icons.phone_android,
                    name: "Sell GiftCard",
                    route: RoutesConstant.sell_giftcard)),
            servicesContainer(
                data: const OtherServicesModel(
                    color: Color(0x1950C2D6),
                    icon: Icons.phone_android,
                    name: "Sell GiftCard",
                    route: RoutesConstant.airtime)),
            servicesContainer(
                data: const OtherServicesModel(
                    color: Color(0x1950C2D6),
                    icon: Icons.phone_android,
                    name: "Sell GiftCard",
                    route: RoutesConstant.airtime))
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
        width: Get.width * .18,
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
