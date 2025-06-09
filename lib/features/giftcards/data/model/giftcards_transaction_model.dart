import 'dart:convert';

class GiftCardTransactionModel {
  final int id;
  final int userId;
  final int? countryId;
  final int giftCardId;
  final String type;
  final String balance;
  final String? fiatAmount;
  final String status;
  final String? proofFile;
  final String? cloudinaryPublicId;
  final String? txHash;
  final String? adminNotes;
  final String? paymentMethod;
  final String giftCardType;
  final String? ecode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;
  final GiftCard giftCard;

  GiftCardTransactionModel({
    required this.id,
    required this.userId,
    this.countryId,
    required this.giftCardId,
    required this.type,
    required this.balance,
    this.fiatAmount,
    required this.status,
    this.proofFile,
    this.cloudinaryPublicId,
    this.txHash,
    this.adminNotes,
    this.paymentMethod,
    required this.giftCardType,
    this.ecode,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.giftCard,
  });

  factory GiftCardTransactionModel.fromJson(Map<String, dynamic> json) {
    return GiftCardTransactionModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      countryId: json['country_id'] as int?,
      giftCardId: json['gift_card_id'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      balance: json['balance'] as String? ?? '0.00',
      fiatAmount: json['fiat_amount'] as String?,
      status: json['status'] as String? ?? '',
      proofFile: json['proof_file'] as String?,
      cloudinaryPublicId: json['cloudinary_public_id'] as String?,
      txHash: json['tx_hash'] as String?,
      adminNotes: json['admin_notes'] as String?,
      paymentMethod: json['payment_method'] as String?,
      giftCardType: json['gift_card_type'] as String? ?? '',
      ecode: json['ecode'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String? ?? '1970-01-01T00:00:00Z'),
      updatedAt: DateTime.parse(json['updated_at'] as String? ?? '1970-01-01T00:00:00Z'),
      user: User.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      giftCard: GiftCard.fromJson(json['gift_card'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'country_id': countryId,
      'gift_card_id': giftCardId,
      'type': type,
      'balance': balance,
      'fiat_amount': fiatAmount,
      'status': status,
      'proof_file': proofFile,
      'cloudinary_public_id': cloudinaryPublicId,
      'tx_hash': txHash,
      'admin_notes': adminNotes,
      'payment_method': paymentMethod,
      'gift_card_type': giftCardType,
      'ecode': ecode,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user.toJson(),
      'gift_card': giftCard.toJson(),
    };
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String walletBalance;
  final bool isVerified;
  final bool isAdmin;
  final DateTime dateJoined;
  final DateTime? lastLogin;
  final String? referralCode;
  final String? walletAddresses;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final WithdrawalBank? withdrawalBank;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.walletBalance,
    required this.isVerified,
    required this.isAdmin,
    required this.dateJoined,
    this.lastLogin,
    this.referralCode,
    this.walletAddresses,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.withdrawalBank,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      walletBalance: json['wallet_balance'] as String? ?? '0.00',
      isVerified: (json['is_verified'] as int? ?? 0) == 1,
      isAdmin: (json['is_admin'] as int? ?? 0) == 1,
      dateJoined: DateTime.parse(json['date_joined'] as String? ?? '1970-01-01T00:00:00Z'),
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login'] as String) : null,
      referralCode: json['referral_code'] as String?,
      walletAddresses: json['wallet_addresses'] as String?,
      status: json['status'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String? ?? '1970-01-01T00:00:00Z'),
      updatedAt: DateTime.parse(json['updated_at'] as String? ?? '1970-01-01T00:00:00Z'),
      withdrawalBank: json['withdrawal_bank'] != null
          ? WithdrawalBank.fromJson(json['withdrawal_bank'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'wallet_balance': walletBalance,
      'is_verified': isVerified ? 1 : 0,
      'is_admin': isAdmin ? 1 : 0,
      'date_joined': dateJoined.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
      'referral_code': referralCode,
      'wallet_addresses': walletAddresses,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'withdrawal_bank': withdrawalBank?.toJson(),
    };
  }
}

class WithdrawalBank {
  final String bankCode;
  final String bankName;
  final String accountNumber;

  WithdrawalBank({
    required this.bankCode,
    required this.bankName,
    required this.accountNumber,
  });

  factory WithdrawalBank.fromJson(Map<String, dynamic> json) {
    return WithdrawalBank(
      bankCode: json['bank_code'] as String? ?? '',
      bankName: json['bank_name'] as String? ?? '',
      accountNumber: json['account_number'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_code': bankCode,
      'bank_name': bankName,
      'account_number': accountNumber,
    };
  }
}

class GiftCard {
  final int id;
  final String name;
  final String category;
  final bool isEnabled;
  final int stock;
  final String image;
  final String cloudinaryPublicId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CountryRateModel> countries;

  GiftCard({
    required this.id,
    required this.name,
    required this.category,
    required this.isEnabled,
    required this.stock,
    required this.image,
    required this.cloudinaryPublicId,
    required this.createdAt,
    required this.updatedAt,
    required this.countries,
  });

  factory GiftCard.fromJson(Map<String, dynamic> json) {
    List<CountryRateModel> parsedCountries = [];
    if (json['countries'] != null) {
      try {
        if (json['countries'] is String) {
          parsedCountries = (jsonDecode(json['countries']) as List<dynamic>)
              .map((item) => CountryRateModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (json['countries'] is List) {
          parsedCountries = (json['countries'] as List<dynamic>)
              .map((item) => CountryRateModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      } catch (e) {
        print('Error parsing countries: $e');
      }
    }

    return GiftCard(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      isEnabled: (json['is_enabled'] as int? ?? 0) == 1,
      stock: json['stock'] as int? ?? 0,
      image: json['image'] as String? ?? '',
      cloudinaryPublicId: json['cloudinary_public_id'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String? ?? '1970-01-01T00:00:00Z'),
      updatedAt: DateTime.parse(json['updated_at'] as String? ?? '1970-01-01T00:00:00Z'),
      countries: parsedCountries,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'is_enabled': isEnabled ? 1 : 0,
      'stock': stock,
      'image': image,
      'cloudinary_public_id': cloudinaryPublicId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'countries': jsonEncode(countries.map((c) => c.toJson()).toList()),
    };
  }
}

class CountryRateModel {
  final String name;
  final String buyRate;
  final String sellRate;

  const CountryRateModel({
    required this.name,
    required this.buyRate,
    required this.sellRate,
  });

  factory CountryRateModel.fromJson(Map<String, dynamic> json) {
    return CountryRateModel(
      name: json['name'] as String? ?? '',
      buyRate: json['buy_rate'] as String? ?? '0',
      sellRate: json['sell_rate'] as String? ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'buy_rate': buyRate,
      'sell_rate': sellRate,
    };
  }
}