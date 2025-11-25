import 'package:davyking/core/utils/helper.dart';

class WalletTransactionModel {
  final int id;
  final int userId;
  final String reference;
  final String amount;
  final String type;
  final String status;
  final String gateway;
  final DateTime createdAt;
  final DateTime updatedAt;

  WalletTransactionModel({
    required this.id,
    required this.userId,
    required this.reference,
    required this.amount,
    required this.type,
    required this.status,
    required this.gateway,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'],
      userId: parseInt(json['user_id']),
      reference: json['reference'],
      amount: json['amount'],
      type: json['type'],
      status: json['status'],
      gateway: json['gateway'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
