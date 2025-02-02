import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/profile/controllers/withdrawal_bank_controller.dart';
import 'package:davyking/features/profile/data/model/input_field_model.dart';
import 'package:davyking/features/profile/data/source/withdrawal_bank_list.dart';
import 'package:davyking/features/profile/presentation/widget/input_field_model.dart';
import 'package:davyking/features/profile/presentation/widget/withdrawal_bank_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawalBankScreen extends StatelessWidget {
  const WithdrawalBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GetBuilder(
              init: WithdrawalBankController(),
              builder: (WithdrawalBankController controller) {
                return Container(
                  margin: Spacing.defaultMarginSpacing,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TopHeaderWidget(
                          data: TopHeaderModel(title: 'Withdrawal Bank')),
                      const SizedBox(height: 37.82),
                      Text('Withdrawal Bank',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 20),
                      Text(
                          'This is where funds you have earned  on the platform will be sent to',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: DarkThemeColors.shade)),
                      const SizedBox(height: 20),
                      WithdrawalBankWidget(),
                      const SizedBox(height: 20),
                      DropdownSearch<String>(
                        items: (filter, infiniteScrollProps) => banks,
                        onChanged: (value) {
                          // setState(() {
                          //   selectedBank = value;
                          //   showAccountNameField = true;
                          // });
                        },
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            labelText: "Select Bank",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      profileInputField(ProfileInputFieldModel(
                          inputcontroller: TextEditingController(),
                          name: 'Account Number',
                          hintText: 'Account Number')),
                    ],
                  ),
                );
              }
              //  Container(
              //   margin: Spacing.defaultMarginSpacing,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       TopHeaderWidget(data: TopHeaderModel(title: 'Withdrawal Bank')),
              //       const SizedBox(height: 37.82),
              //       Text('Withdrawal Bank',
              //           style: Theme.of(context)
              //               .textTheme
              //               .displayMedium
              //               ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
              //       const SizedBox(height: 20),
              //       Text(
              //           'This is where funds you have earned  on the platform will be sent to',
              //           style: Theme.of(context).textTheme.displayMedium?.copyWith(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w500,
              //               color: DarkThemeColors.shade)),
              //       const SizedBox(height: 20),
              //       WithdrawalBankWidget(),
              //       const SizedBox(height: 20),
              //       DropdownSearch<String>(
              //         items: (filter, infiniteScrollProps) => banks,
              //         onChanged: (value) {
              //           // setState(() {
              //           //   selectedBank = value;
              //           //   showAccountNameField = true;
              //           // });
              //         },
              //         decoratorProps: DropDownDecoratorProps(
              //           decoration: InputDecoration(
              //             labelText: "Select Bank",
              //             contentPadding: const EdgeInsets.symmetric(
              //                 vertical: 15, horizontal: 15),
              //             border: OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(8)),
              //           ),
              //         ),
              //       ),
              //       const SizedBox(height: 20),
              //       profileInputField(ProfileInputFieldModel(
              //         inputcontroller: TextEditingController(),
              //         name: 'Account Name',
              //         hintText: 'Account Number',
              //       )),
              //     ],
              //   ),
              // ),
              )),
    );
  }
}
