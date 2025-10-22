import 'tokens_model.dart';

class RegisterModel {
  final User user;
  final TokensModel tokens;

  RegisterModel({
    required this.user,
    required this.tokens,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      user: User.fromJson(json['user']),
      tokens: TokensModel.fromJson(json['tokens']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'tokens': tokens.toJson(),
    };
  }
}

class User {
  final String id;
  final String? email;
  final String username;
  final String firstName;
  final String lastName;
  final String fullName;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? profilePicture;
  final String? address;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  final String kycStatus;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool twoFactorEnabled;
  final String? walletAddress;
  final String? walletType;
  final String userType;
  final bool isActive;
  final bool isBlocked;
  final String createdAt;
  final String updatedAt;
  final String? lastLoginAt;
  final CreditAccount? creditAccount;
  final YieldAccount? yieldAccount;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    this.phoneNumber,
    this.dateOfBirth,
    this.profilePicture,
    this.address,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    required this.kycStatus,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.twoFactorEnabled,
    this.walletAddress,
    this.walletType,
    required this.userType,
    required this.isActive,
    required this.isBlocked,
    required this.createdAt,
    required this.updatedAt,
    required this.lastLoginAt,
    this.creditAccount,
    this.yieldAccount,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: json['dateOfBirth'],
      profilePicture: json['profilePicture'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      country: json['country'],
      kycStatus: json['kycStatus'],
      isEmailVerified: json['isEmailVerified'],
      isPhoneVerified: json['isPhoneVerified'],
      twoFactorEnabled: json['twoFactorEnabled'],
      walletAddress: json['walletAddress'],
      walletType: json['walletType'],
      userType: json['userType'],
      isActive: json['isActive'],
      isBlocked: json['isBlocked'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      lastLoginAt: json['lastLoginAt'],
      creditAccount: json['creditAccount'] != null
          ? CreditAccount.fromJson(json['creditAccount'])
          : null,
      yieldAccount: json['yieldAccount'] != null
          ? YieldAccount.fromJson(json['yieldAccount'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'profilePicture': profilePicture,
      'address': address,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'kycStatus': kycStatus,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'twoFactorEnabled': twoFactorEnabled,
      'walletAddress': walletAddress,
      'walletType': walletType,
      'userType': userType,
      'isActive': isActive,
      'isBlocked': isBlocked,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lastLoginAt': lastLoginAt,
      'creditAccount': creditAccount?.toJson(),
      'yieldAccount': yieldAccount?.toJson(),
    };
  }
}

class CreditAccount {
  final String id;
  final String userId;
  final String creditLimit;
  final String availableCredit;
  final String usedCredit;
  final String currentBalance;
  final String minimumPayment;
  final String? nextPaymentDue;
  final String? paymentDueDate;
  final int paymentDueDay;
  final String? lastPaymentAt;
  final String? lastActivityAt;
  final String interestRate;
  final int xpTokens;
  final String riskScore;
  final String riskLevel;
  final String defaultStatus;
  final int daysOverdue;
  final String status;
  final String createdAt;
  final String updatedAt;

  CreditAccount({
    required this.id,
    required this.userId,
    required this.creditLimit,
    required this.availableCredit,
    required this.usedCredit,
    required this.currentBalance,
    required this.minimumPayment,
    this.nextPaymentDue,
    this.paymentDueDate,
    required this.paymentDueDay,
    this.lastPaymentAt,
    this.lastActivityAt,
    required this.interestRate,
    required this.xpTokens,
    required this.riskScore,
    required this.riskLevel,
    required this.defaultStatus,
    required this.daysOverdue,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CreditAccount.fromJson(Map<String, dynamic> json) {
    return CreditAccount(
      id: json['id'],
      userId: json['userId'],
      creditLimit: json['creditLimit'],
      availableCredit: json['availableCredit'],
      usedCredit: json['usedCredit'],
      currentBalance: json['currentBalance'],
      minimumPayment: json['minimumPayment'],
      nextPaymentDue: json['nextPaymentDue'],
      paymentDueDate: json['paymentDueDate'],
      paymentDueDay: json['paymentDueDay'],
      lastPaymentAt: json['lastPaymentAt'],
      lastActivityAt: json['lastActivityAt'],
      interestRate: json['interestRate'],
      xpTokens: json['xpTokens'],
      riskScore: json['riskScore'],
      riskLevel: json['riskLevel'],
      defaultStatus: json['defaultStatus'],
      daysOverdue: json['daysOverdue'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'creditLimit': creditLimit,
      'availableCredit': availableCredit,
      'usedCredit': usedCredit,
      'currentBalance': currentBalance,
      'minimumPayment': minimumPayment,
      'nextPaymentDue': nextPaymentDue,
      'paymentDueDate': paymentDueDate,
      'paymentDueDay': paymentDueDay,
      'lastPaymentAt': lastPaymentAt,
      'lastActivityAt': lastActivityAt,
      'interestRate': interestRate,
      'xpTokens': xpTokens,
      'riskScore': riskScore,
      'riskLevel': riskLevel,
      'defaultStatus': defaultStatus,
      'daysOverdue': daysOverdue,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class YieldAccount {
  final String id;
  final String userId;
  final String balance;
  final String depositBalance;
  final String yieldBalance;
  final String totalBalance;
  final String totalDeposited;
  final String totalWithdrawn;
  final String currentApy;
  final String totalYieldEarned;
  final String? lastYieldCalculation;
  final String? lastYieldDistribution;
  final String? lastActivityAt;
  final String? blockchainAddress;
  final String? lastBlockchainSync;
  final String status;
  final bool autoReinvest;
  final String createdAt;
  final String updatedAt;

  YieldAccount({
    required this.id,
    required this.userId,
    required this.balance,
    required this.depositBalance,
    required this.yieldBalance,
    required this.totalBalance,
    required this.totalDeposited,
    required this.totalWithdrawn,
    required this.currentApy,
    required this.totalYieldEarned,
    this.lastYieldCalculation,
    this.lastYieldDistribution,
    this.lastActivityAt,
    this.blockchainAddress,
    this.lastBlockchainSync,
    required this.status,
    required this.autoReinvest,
    required this.createdAt,
    required this.updatedAt,
  });

  factory YieldAccount.fromJson(Map<String, dynamic> json) {
    return YieldAccount(
      id: json['id'],
      userId: json['userId'],
      balance: json['balance'],
      depositBalance: json['depositBalance'],
      yieldBalance: json['yieldBalance'],
      totalBalance: json['totalBalance'],
      totalDeposited: json['totalDeposited'],
      totalWithdrawn: json['totalWithdrawn'],
      currentApy: json['currentApy'],
      totalYieldEarned: json['totalYieldEarned'],
      lastYieldCalculation: json['lastYieldCalculation'],
      lastYieldDistribution: json['lastYieldDistribution'],
      lastActivityAt: json['lastActivityAt'],
      blockchainAddress: json['blockchainAddress'],
      lastBlockchainSync: json['lastBlockchainSync'],
      status: json['status'],
      autoReinvest: json['autoReinvest'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'balance': balance,
      'depositBalance': depositBalance,
      'yieldBalance': yieldBalance,
      'totalBalance': totalBalance,
      'totalDeposited': totalDeposited,
      'totalWithdrawn': totalWithdrawn,
      'currentApy': currentApy,
      'totalYieldEarned': totalYieldEarned,
      'lastYieldCalculation': lastYieldCalculation,
      'lastYieldDistribution': lastYieldDistribution,
      'lastActivityAt': lastActivityAt,
      'blockchainAddress': blockchainAddress,
      'lastBlockchainSync': lastBlockchainSync,
      'status': status,
      'autoReinvest': autoReinvest,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
