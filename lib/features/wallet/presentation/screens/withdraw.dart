import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/controllers/transaction_auth_controller.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/wallet/controllers/withdraw_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController amountController = TextEditingController();

  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();
  final WithdrawController withdrawController = Get.put(WithdrawController());
  final TransactionAuthController transactionAuthController =
      Get.find<TransactionAuthController>();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Spacing.defaultMarginSpacing,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopHeaderWidget(
                  data: TopHeaderModel(title: 'Withdraw Funds')),
              const SizedBox(height: 30),
              // _buildTopBar(),
              const SizedBox(height: 20),
              _buildWalletBalanceCard(),
              const SizedBox(height: 40),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAmountField(),
                      const SizedBox(height: 20),
                      _buildPaymentMethodField(context),
                      const SizedBox(height: 50),
                      Obx(() => withdrawController.isLoading.value
                          ? CustomPrimaryButton(
                              controller: CustomPrimaryButtonController(
                                  model: const CustomPrimaryButtonModel(
                                      child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              color: Colors.white))),
                                  onPressed: () {}),
                            )
                          : CustomPrimaryButton(
                              controller: CustomPrimaryButtonController(
                                  model: const CustomPrimaryButtonModel(
                                      text: 'Withdraw Funds'),
                                  onPressed: () async {
                                    bool isAuthenticated =
                                        await transactionAuthController
                                            .authenticate(
                                      context,
                                      'withdrawal of ${withdrawController.amountController.text}',
                                    );

                                    if (isAuthenticated) {
                                      withdrawController.withdrawFunds();
                                    }
                                  }),
                            )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        const Text(
          'Account Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWalletBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: Get.width,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.greenAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Wallet Balance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'N ${double.parse(userAuthDetailsController.user.value!.walletBalance).toStringAsFixed(2)}',
            style: const TextStyle(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amount',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: withdrawController.amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter amount',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.green),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Max daily amount - N${double.parse(userAuthDetailsController.user.value?.walletBalance ?? "0")}',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _showPaymentMethodModal(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    withdrawController.selectedPaymentMethod.value.isEmpty
                        ? 'Select a Payment Method'
                        : withdrawController.selectedPaymentMethod.value,
                    style: TextStyle(
                      color:
                          withdrawController.selectedPaymentMethod.value.isEmpty
                              ? Colors.grey
                              : Colors.black,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPaymentMethodModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              Container(
                width: 58,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: .1,
                        offset: Offset(0, 2),
                        spreadRadius: 0)
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select a Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              if (userAuthDetailsController
                      .user.value?.withdrawalBank?.accountNumber !=
                  null)
                GestureDetector(
                  onTap: () {
                    withdrawController.updateSelectedInput();
                    Navigator.pop(context);
                  },
                  child: DottedBorder(
                    dashPattern: [6, 3], // 6px line, 3px gap
                    strokeWidth: 1,
                    color: Colors.grey,
                    borderType: BorderType.RRect,
                    radius: Radius.circular(8),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(userAuthDetailsController
                                  .user.value?.withdrawalBank?.accountNumber ??
                              ""),
                          Text(userAuthDetailsController
                                  .user.value?.withdrawalBank?.bankName ??
                              " "),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RoutesConstant.withdrawalBank);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${userAuthDetailsController.user.value?.withdrawalBank?.bankName == null ? 'Add' : 'Change'} Bank',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                     const Icon(Icons.add, color: Colors.green),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
