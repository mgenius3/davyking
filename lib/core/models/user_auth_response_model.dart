class UserAuthResponse {
  final User user;
  final String token;

  UserAuthResponse({
    required this.user,
    required this.token,
  });

  factory UserAuthResponse.fromJson(Map<String, dynamic> json) {
    return UserAuthResponse(
      user: User.fromJson(json['user']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'token': token};
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
  final String dateJoined;
  final String? lastLogin;
  final String? referralCode;
  final dynamic walletAddresses;
  final WithdrawalBank? withdrawalBank;
  final String status;
  final String createdAt;
  final String updatedAt;

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
    this.withdrawalBank,
    required this.status,
    required this.createdAt,
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
      dateJoined: json['date_joined'],
      lastLogin: json['last_login'],
      referralCode: json['referral_code'],
      walletAddresses: json['wallet_addresses'],
      withdrawalBank: json['withdrawal_bank'] != null
          ? WithdrawalBank.fromJson(json['withdrawal_bank'])
          : null,
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
      'date_joined': dateJoined,
      'last_login': lastLogin,
      'referral_code': referralCode,
      'wallet_addresses': walletAddresses,
      'withdrawal_bank': withdrawalBank?.toJson(),
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
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
      bankCode: json['bank_code'],
      bankName: json['bank_name'],
      accountNumber: json['account_number'],
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

