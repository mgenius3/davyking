import 'dart:convert'; // Import for JSON decoding

class GiftcardsListModel {
  final int id;
  final String name;
  final String category;
  final String denomination;
  final String buyRate;
  final String sellRate;
  final int isEnabled;
  final int stock;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<RateModel> rates;
  final List<String> ranges;

  const GiftcardsListModel({
    required this.id,
    required this.name,
    required this.category,
    required this.denomination,
    required this.buyRate,
    required this.sellRate,
    required this.isEnabled,
    required this.stock,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.rates,
    required this.ranges,
  });

  factory GiftcardsListModel.fromJson(Map<String, dynamic> json) {
    // Parse ranges as a JSON string
    List<String> parsedRanges = [];
    if (json['ranges'] != null) {
      try {
        if (json['ranges'] is String) {
          // Decode the JSON string into a List<String>
          parsedRanges =
              List<String>.from(jsonDecode(json['ranges'] as String));
        } else if (json['ranges'] is List) {
          // If it's already a List, cast it directly
          parsedRanges = (json['ranges'] as List<dynamic>)
              .map((range) => range as String)
              .toList();
        }
      } catch (e) {
        print('Error parsing ranges: $e');
      }
    }

    return GiftcardsListModel(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      denomination: json['denomination'] as String,
      buyRate: json['buy_rate'] as String,
      sellRate: json['sell_rate'] as String,
      isEnabled: json['is_enabled'] as int,
      stock: json['stock'] as int,
      image: json['image'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      rates: (json['rates'] as List<dynamic>?)
              ?.map((rate) => RateModel.fromJson(rate as Map<String, dynamic>))
              .toList() ??
          [],
      ranges: parsedRanges, // Use the parsed ranges
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'denomination': denomination,
      'buy_rate': buyRate,
      'sell_rate': sellRate,
      'is_enabled': isEnabled,
      'stock': stock,
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'rates': rates.map((rate) => rate.toJson()).toList(),
      'ranges': ranges // Serialize as a List<String>
    };
  }
}

class RateModel {
  final int id;
  final int giftCardId;
  final String currency;
  final String buyRate;
  final String sellRate;
  final int updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RateModel({
    required this.id,
    required this.giftCardId,
    required this.currency,
    required this.buyRate,
    required this.sellRate,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      id: json['id'] as int,
      giftCardId: json['gift_card_id'] as int,
      currency: json['currency'] as String,
      buyRate: json['buy_rate'] as String,
      sellRate: json['sell_rate'] as String,
      updatedBy: json['updated_by'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gift_card_id': giftCardId,
      'currency': currency,
      'buy_rate': buyRate,
      'sell_rate': sellRate,
      'updated_by': updatedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String()
    };
  }
}
