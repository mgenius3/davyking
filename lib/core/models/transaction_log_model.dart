// transaction_model.dart
import 'package:davyking/core/utils/helper.dart';

class TransactionLogModel {
  final int id;
  final String transactionType;
  final String? referenceId;
  final Map<String, dynamic> details;
  final int success;
  final DateTime timestamp;

  TransactionLogModel({
    required this.id,
    required this.transactionType,
    this.referenceId,
    required this.details,
    required this.success,
    required this.timestamp,
  });

  factory TransactionLogModel.fromJson(Map<String, dynamic> json) =>
      TransactionLogModel(
        id: json['id'],
        transactionType: json['transaction_type'],
        referenceId: json['reference_id'],
        details: Map<String, dynamic>.from(json['details']),
        success: parseInt(json['success']),
        timestamp: DateTime.parse(json['created_at']),
      );
}
