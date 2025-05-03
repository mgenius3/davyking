class GiftCardTransactionModel {
  final int id;
  final int userId;
  final int giftCardId;
  final String type;
  final String amount;
  final String status;
  final String? proofFile;
  final String? txHash;
  final String? adminNotes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;
  final GiftCard giftCard;

  GiftCardTransactionModel({
    required this.id,
    required this.userId,
    required this.giftCardId,
    required this.type,
    required this.amount,
    required this.status,
    this.proofFile,
    this.txHash,
    this.adminNotes,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.giftCard,
  });

  factory GiftCardTransactionModel.fromJson(Map<String, dynamic> json) {
    return GiftCardTransactionModel(
      id: json['id'],
      userId: json['user_id'],
      giftCardId: json['gift_card_id'],
      type: json['type'],
      amount: json['amount'],
      status: json['status'],
      proofFile: json['proof_file'],
      txHash: json['tx_hash'],
      adminNotes: json['admin_notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: User.fromJson(json['user']),
      giftCard: GiftCard.fromJson(json['gift_card']),
    );
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
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.walletBalance,
    required this.isVerified,
    required this.isAdmin,
    required this.dateJoined,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      walletBalance: json['wallet_balance'],
      isVerified: json['is_verified'] == 1,
      isAdmin: json['is_admin'] == 1,
      dateJoined: DateTime.parse(json['date_joined']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class GiftCard {
  final int id;
  final String name;
  final String category;
  final String denomination;
  final String buyRate;
  final String sellRate;
  final bool isEnabled;
  final int stock;
  final String? ranges;
  final String image;

  GiftCard({
    required this.id,
    required this.name,
    required this.category,
    required this.denomination,
    required this.buyRate,
    required this.sellRate,
    required this.isEnabled,
    required this.stock,
    this.ranges,
    required this.image,
  });

  factory GiftCard.fromJson(Map<String, dynamic> json) {
    return GiftCard(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      denomination: json['denomination'],
      buyRate: json['buy_rate'],
      sellRate: json['sell_rate'],
      isEnabled: json['is_enabled'] == 1,
      stock: json['stock'],
      ranges: json['ranges'],
      image: json['image'],
    );
  }
}
