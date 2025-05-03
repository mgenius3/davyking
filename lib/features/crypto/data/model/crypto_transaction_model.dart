

import 'package:davyking/core/models/user_auth_response_model.dart';

class CryptoTransactionModel {
  final int id;
  final int userId;
  final int cryptoCurrencyId;
  final String type;
  final String amount;
  final String fiatAmount;
  final String status;
  final String? proofFile;
  final String? paymentMethod;
  final String? walletAddress;
  final int confirmations;
  final String? txHash;
  final String? adminNotes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;
  final CryptoCurrency cryptoCurrency;

  CryptoTransactionModel({
    required this.id,
    required this.userId,
    required this.cryptoCurrencyId,
    required this.type,
    required this.amount,
    required this.fiatAmount,
    required this.status,
    this.proofFile,
    this.paymentMethod,
    this.walletAddress,
    required this.confirmations,
    this.txHash,
    this.adminNotes,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.cryptoCurrency,
  });

  factory CryptoTransactionModel.fromJson(Map<String, dynamic> json) {
    return CryptoTransactionModel(
      id: json['id'],
      userId: json['user_id'],
      cryptoCurrencyId: json['crypto_currency_id'],
      type: json['type'],
      amount: json['amount'].toString(),
      fiatAmount: json['fiat_amount'].toString(),
      status: json['status'],
      proofFile: json['proof_file'],
      paymentMethod: json['payment_method'],
      walletAddress: json['wallet_address'],
      confirmations: json['confirmations'],
      txHash: json['tx_hash'],
      adminNotes: json['admin_notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: User.fromJson(json['user']),
      cryptoCurrency: CryptoCurrency.fromJson(json['crypto_currency']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'crypto_currency_id': cryptoCurrencyId,
      'type': type,
      'amount': amount,
      'fiat_amount': fiatAmount,
      'status': status,
      'proof_file': proofFile,
      'payment_method': paymentMethod,
      'wallet_address': walletAddress,
      'confirmations': confirmations,
      'tx_hash': txHash,
      'admin_notes': adminNotes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user.toJson(),
      'crypto_currency': cryptoCurrency.toJson(),
    };
  }
}

class CryptoCurrency {
  final int id;
  final String name;
  final String symbol;
  final String network;
  final String buyRate;
  final String sellRate;
  final bool isEnabled;
  final String image;
  final String? walletAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  CryptoCurrency({
    required this.id,
    required this.name,
    required this.symbol,
    required this.network,
    required this.buyRate,
    required this.sellRate,
    required this.isEnabled,
    required this.image,
    this.walletAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CryptoCurrency.fromJson(Map<String, dynamic> json) {
    return CryptoCurrency(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      network: json['network'],
      buyRate: json['buy_rate'].toString(),
      sellRate: json['sell_rate'].toString(),
      isEnabled: json['is_enabled'] == 1,
      image: json['image'],
      walletAddress: json['wallet_address'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
      'is_enabled': isEnabled ? 1 : 0,
      'image': image,
      'wallet_address': walletAddress,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}