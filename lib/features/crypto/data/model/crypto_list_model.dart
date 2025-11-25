import 'dart:convert'; // Import for JSON decoding
import 'package:davyking/core/utils/helper.dart';

class CryptoListModel {
  final int id;
  final String name;
  final String symbol;
  final String network;
  final String buyRate; // Kept as String to match your data
  final String sellRate; // Kept as String to match your data
  final String currentPrice;
  final int isEnabled; // 1 or 0 as per your data
  final DateTime createdAt;
  final DateTime updatedAt;
  final String image;
  final String wallet_address;
  final double liquid_balance; // Add liquid_balance field

  const CryptoListModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.network,
    required this.buyRate,
    required this.sellRate,
    required this.currentPrice,
    required this.isEnabled,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
    required this.wallet_address,
    required this.liquid_balance,
  });

  factory CryptoListModel.fromJson(Map<String, dynamic> json) {
    return CryptoListModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      symbol: json['symbol'] as String,
      network: json['network'] as String,
      buyRate: json['buy_rate'] as String,
      sellRate: json['sell_rate'] as String,
      currentPrice: json['current_price'] as String,
      isEnabled: parseInt(json['is_enabled']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      wallet_address: json['wallet_address'] as String,
      liquid_balance: (json['liquid_balance'] as num?)?.toDouble() ??
          0.0, // Add liquid_balance parsing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'network': network,
      'buy_rate': buyRate,
      'sell_rate': sellRate,
      'is_enabled': isEnabled,
      'current_price': currentPrice,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'wallet_address': wallet_address,
      'liquid_balance': liquid_balance
    };
  }
}
