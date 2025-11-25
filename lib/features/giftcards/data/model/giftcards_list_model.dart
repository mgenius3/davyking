import 'dart:convert';

import 'package:davyking/core/utils/helper.dart';

class GiftcardsListModel {
  final int id;
  final String name;
  final String category;
  final int isEnabled;
  final int stock;
  final String image;
  final String cloudinaryPublicId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CountryRateModel> countries;

  const GiftcardsListModel({
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

  factory GiftcardsListModel.fromJson(Map<String, dynamic> json) {
    List<CountryRateModel> parsedCountries = [];
    if (json['countries'] != null) {
      try {
        if (json['countries'] is String) {
          parsedCountries = (jsonDecode(json['countries']) as List<dynamic>)
              .map((item) =>
                  CountryRateModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (json['countries'] is List) {
          parsedCountries = (json['countries'] as List<dynamic>)
              .map((item) =>
                  CountryRateModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      } catch (e) {
        print('Error parsing countries: $e');
      }
    }

    return GiftcardsListModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      // isEnabled: json['is_enabled'] as int? ?? 0,
      isEnabled: parseInt(json['is_enabled']),
      // stock: json['stock'] as int? ?? 0,
      stock: parseInt(json['stock']),
      image: json['image'] as String? ?? '',
      cloudinaryPublicId: json['cloudinary_public_id'] as String? ?? '',
      createdAt: DateTime.parse(
          json['created_at'] as String? ?? '1970-01-01T00:00:00Z'),
      updatedAt: DateTime.parse(
          json['updated_at'] as String? ?? '1970-01-01T00:00:00Z'),
      countries: parsedCountries,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'is_enabled': isEnabled,
      'stock': stock,
      'image': image,
      'cloudinary_public_id': cloudinaryPublicId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'countries': countries.map((c) => c.toJson()).toList(),
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
