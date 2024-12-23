import 'package:davyking/features/common/data/models/top_header_model.dart';
import 'package:davyking/features/common/presentation/widget/back_navigation_widget.dart';
import 'package:flutter/material.dart';

class TopHeaderWidget extends StatefulWidget {
  final TopHeaderModel model;
  const TopHeaderWidget({super.key, required this.model});

  @override
  State<TopHeaderWidget> createState() => _TopHeaderWidgetState();
}

class _TopHeaderWidgetState extends State<TopHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackNavigationWidget(),
          Text(
            widget.model.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 17.22,
                fontWeight: FontWeight.w600,
                height: 1.33),
          ),
          SizedBox(child: widget.model.child ?? const SizedBox())
        ],
      ),
    );
  }
}
