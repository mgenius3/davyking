class PaystackBankModel {
  final int id;
  final String name;
  final String slug;
  final String code;
  final String? longcode;
  final String? gateway;
  final bool payWithBank;
  final bool supportsTransfer;
  final bool active;
  final String country;
  final String currency;
  final String type;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaystackBankModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.code,
    this.longcode,
    this.gateway,
    required this.payWithBank,
    required this.supportsTransfer,
    required this.active,
    required this.country,
    required this.currency,
    required this.type,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaystackBankModel.fromJson(Map<String, dynamic> json) {
    return PaystackBankModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      code: json['code'].toString(),
      longcode: json['longcode'],
      gateway: json['gateway'],
      payWithBank: json['pay_with_bank'],
      supportsTransfer: json['supports_transfer'],
      active: json['active'],
      country: json['country'],
      currency: json['currency'],
      type: json['type'],
      isDeleted: json['is_deleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'code': code,
      'longcode': longcode,
      'gateway': gateway,
      'pay_with_bank': payWithBank,
      'supports_transfer': supportsTransfer,
      'active': active,
      'country': country,
      'currency': currency,
      'type': type,
      'is_deleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
