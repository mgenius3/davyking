import 'package:davyking/core/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpWidget extends StatelessWidget {
  const HelpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        helpList(CupertinoIcons.question_circle_fill, "Customer Service", ''),
        const SizedBox(height: 20),
        helpList(CupertinoIcons.globe, "Website", ''),
        const SizedBox(height: 20),
        helpList(FontAwesomeIcons.facebook, "Facebook", ''),
        const SizedBox(height: 20),
        helpList(FontAwesomeIcons.whatsapp, "Whatsapp", ''),
        const SizedBox(height: 20),
        helpList(FontAwesomeIcons.instagram, "Instagram", ''),
      ],
    );
  }
}

Widget helpList(IconData icon, String title, String routes) {
  return GestureDetector(
      onTap: () {
        Get.toNamed(routes);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                  // width: 28.81,
                  // height: 28.81,
                  padding: const EdgeInsets.only(
                      top: 5.58, left: 4.65, right: 4.25, bottom: 4.57),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: DarkThemeColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11.15)),
                  ),
                  child: Icon(icon)),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                      fontSize: 13.94, fontWeight: FontWeight.w500))
            ],
          ),
          const Icon(CupertinoIcons.chevron_right, size: 15)
        ],
      ));
}
