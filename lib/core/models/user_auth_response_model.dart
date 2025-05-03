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
    return {
      'user': user.toJson(),
      'token': token,
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
  final String dateJoined;
  final String? lastLogin;
  final String? referralCode;
  final dynamic walletAddresses;
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
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
