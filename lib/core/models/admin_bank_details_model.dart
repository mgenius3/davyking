class AdminBankDetailsModel {
  final int id;
  final String bankName;
  final String accountName;
  final String accountNumber;
  final String? ifscCode;
  final String? swiftCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdminBankDetailsModel({
    required this.id,
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    this.ifscCode,
    this.swiftCode,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an instance from JSON
  factory AdminBankDetailsModel.fromJson(Map<String, dynamic> json) {
    return AdminBankDetailsModel(
      id: json['id'] as int,
      bankName: json['bank_name'] as String,
      accountName: json['account_name'] as String,
      accountNumber: json['account_number'] as String,
      ifscCode: json['ifsc_code'] as String?,
      swiftCode: json['swift_code'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bank_name': bankName,
      'account_name': accountName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'swift_code': swiftCode,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
