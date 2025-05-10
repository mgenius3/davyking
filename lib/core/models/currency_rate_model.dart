class CurrencyRateModel {
  final int id;
  final String currencyCode;
  final String rate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CurrencyRateModel({
    required this.id,
    required this.currencyCode,
    required this.rate,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to create an instance from JSON
  factory CurrencyRateModel.fromJson(Map<String, dynamic> json) {
    return CurrencyRateModel(
      id: json['id'] as int,
      currencyCode: json['currency_code'] as String,
      rate: json['rate'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currency_code': currencyCode,
      'rate': rate,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
