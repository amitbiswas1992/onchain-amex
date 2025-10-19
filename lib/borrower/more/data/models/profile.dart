import 'package:flutter/foundation.dart';

class Profile {
  String? id;
  String? email;
  String? username;
  String? firstName;
  String? lastName;
  String? fullName;
  String? phoneNumber;
  String? dateOfBirth;
  String? profilePicture;
  String? address;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  String? kycStatus;
  String? kycProvider;
  String? kycVerificationId;
  String? kycDocuments;
  KycData? kycData;
  String? kycVerifiedAt;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  String? emailVerificationToken;
  String? passwordResetToken;
  String? passwordResetExpiry;
  bool? twoFactorEnabled;
  String? twoFactorSecret;
  List<dynamic>? backupCodes;
  String? walletAddress;
  String? walletType;
  String? userType;
  bool? isActive;
  bool? isBlocked;
  String? blockReason;
  String? createdAt;
  String? updatedAt;
  String? lastLoginAt;
  CreditAccountModel? creditAccount;
  YieldAccountModel? yieldAccount;
  Wallet? wallet;


  Profile({
    this.id,
    this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.fullName,
    this.phoneNumber,
    this.dateOfBirth,
    this.profilePicture,
    this.address,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.kycStatus,
    this.kycProvider,
    this.kycVerificationId,
    this.kycDocuments,
    this.kycData,
    this.kycVerifiedAt,
    this.isEmailVerified,
    this.isPhoneVerified,
    this.emailVerificationToken,
    this.passwordResetToken,
    this.passwordResetExpiry,
    this.twoFactorEnabled,
    this.twoFactorSecret,
    this.backupCodes,
    this.walletAddress,
    this.walletType,
    this.userType,
    this.isActive,
    this.isBlocked,
    this.blockReason,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
    this.creditAccount,
    this.yieldAccount,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    dateOfBirth = json['dateOfBirth'];
    profilePicture = json['profilePicture'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postalCode'];
    country = json['country'];
    kycStatus = json['kycStatus'];
    kycProvider = json['kycProvider'];
    kycVerificationId = json['kycVerificationId'];
    kycDocuments = json['kycDocuments'];
    kycData = KycData.fromJson(json['kycData'] ?? {});
    kycVerifiedAt = json['kycVerifiedAt'];
    isEmailVerified = json['isEmailVerified'];
    isPhoneVerified = json['isPhoneVerified'];
    emailVerificationToken = json['emailVerificationToken'];
    passwordResetToken = json['passwordResetToken'];
    passwordResetExpiry = json['passwordResetExpiry'];
    twoFactorEnabled = json['twoFactorEnabled'];
    twoFactorSecret = json['twoFactorSecret'];
    backupCodes = json['backupCodes'];
    walletAddress = json['walletAddress'];
    walletType = json['walletType'];
    userType = json['userType'];
    isActive = json['isActive'];
    isBlocked = json['isBlocked'];
    blockReason = json['blockReason'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    lastLoginAt = json['lastLoginAt'];
    creditAccount = json['creditAccount'] != null
        ? CreditAccountModel.fromJson(json['creditAccount'])
        : null;
    yieldAccount = json['yieldAccount'] != null
        ? YieldAccountModel.fromJson(json['yieldAccount'])
        : null;
    wallet = json['wallets'] != null && json['wallets'].isNotEmpty ? Wallet.fromJson(json['wallets'].first) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['username'] = username;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['fullName'] = fullName;
    data['phoneNumber'] = phoneNumber;
    data['dateOfBirth'] = dateOfBirth;
    data['profilePicture'] = profilePicture;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['postalCode'] = postalCode;
    data['country'] = country;
    data['kycStatus'] = kycStatus;
    data['kycProvider'] = kycProvider;
    data['kycVerificationId'] = kycVerificationId;
    data['kycDocuments'] = kycDocuments;
    data['kycData'] = kycData;
    data['kycVerifiedAt'] = kycVerifiedAt;
    data['isEmailVerified'] = isEmailVerified;
    data['isPhoneVerified'] = isPhoneVerified;
    data['emailVerificationToken'] = emailVerificationToken;
    data['passwordResetToken'] = passwordResetToken;
    data['passwordResetExpiry'] = passwordResetExpiry;
    data['twoFactorEnabled'] = twoFactorEnabled;
    data['twoFactorSecret'] = twoFactorSecret;
    data['backupCodes'] = backupCodes;
    data['walletAddress'] = walletAddress;
    data['walletType'] = walletType;
    data['userType'] = userType;
    data['isActive'] = isActive;
    data['isBlocked'] = isBlocked;
    data['blockReason'] = blockReason;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['lastLoginAt'] = lastLoginAt;
    if (creditAccount != null) {
      data['creditAccount'] = creditAccount!.toJson();
    }
    if (yieldAccount != null) {
      data['yieldAccount'] = yieldAccount!.toJson();
    }
    if (wallet != null) {
      data['wallets'] = [wallet!.toJson()];
    }
    return data;
  }

  bool isVerified() {
    return isEmailVerified == true || isPhoneVerified == true;
  }

  String getShortName() {
    try {
      return '${this.firstName?[0].toUpperCase() ?? ''}${this.lastName?[0].toUpperCase() ?? ''}';
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
      return '-';
    }
  }
}

class KycData {
  String? reason;
  String? status;
  String? sessionId;

  KycData({this.reason, this.status, this.sessionId});

  KycData.fromJson(Map<String, dynamic> json) {
    reason = json['reason'];
    status = json['status'];
    sessionId = json['sessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['sessionId'] = this.sessionId;
    return data;
  }
}


class CreditAccountModel {
  String? id;
  String? userId;
  String? creditLimit;
  String? availableCredit;
  String? usedCredit;
  String? currentBalance;
  String? minimumPayment;
  String? nextPaymentDue;
  String? paymentDueDate;
  int? paymentDueDay;
  String? lastPaymentAt;
  String? lastActivityAt;
  String? interestRate;
  int? xpTokens;
  String? riskScore;
  String? riskLevel;
  String? defaultStatus;
  int? daysOverdue;
  String? status;
  String? suspensionReason;
  String? suspendedAt;
  String? createdAt;
  String? updatedAt;

  CreditAccountModel({
    this.id,
    this.userId,
    this.creditLimit,
    this.availableCredit,
    this.usedCredit,
    this.currentBalance,
    this.minimumPayment,
    this.nextPaymentDue,
    this.paymentDueDate,
    this.paymentDueDay,
    this.lastPaymentAt,
    this.lastActivityAt,
    this.interestRate,
    this.xpTokens,
    this.riskScore,
    this.riskLevel,
    this.defaultStatus,
    this.daysOverdue,
    this.status,
    this.suspensionReason,
    this.suspendedAt,
    this.createdAt,
    this.updatedAt,
  });

  CreditAccountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    creditLimit = json['creditLimit'];
    availableCredit = json['availableCredit'];
    usedCredit = json['usedCredit'];
    currentBalance = json['currentBalance'];
    minimumPayment = json['minimumPayment'];
    nextPaymentDue = json['nextPaymentDue'];
    paymentDueDate = json['paymentDueDate'];
    paymentDueDay = json['paymentDueDay'];
    lastPaymentAt = json['lastPaymentAt'];
    lastActivityAt = json['lastActivityAt'];
    interestRate = json['interestRate'];
    xpTokens = json['xpTokens'];
    riskScore = json['riskScore'];
    riskLevel = json['riskLevel'];
    defaultStatus = json['defaultStatus'];
    daysOverdue = json['daysOverdue'];
    status = json['status'];
    suspensionReason = json['suspensionReason'];
    suspendedAt = json['suspendedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['creditLimit'] = creditLimit;
    data['availableCredit'] = availableCredit;
    data['usedCredit'] = usedCredit;
    data['currentBalance'] = currentBalance;
    data['minimumPayment'] = minimumPayment;
    data['nextPaymentDue'] = nextPaymentDue;
    data['paymentDueDate'] = paymentDueDate;
    data['paymentDueDay'] = paymentDueDay;
    data['lastPaymentAt'] = lastPaymentAt;
    data['lastActivityAt'] = lastActivityAt;
    data['interestRate'] = interestRate;
    data['xpTokens'] = xpTokens;
    data['riskScore'] = riskScore;
    data['riskLevel'] = riskLevel;
    data['defaultStatus'] = defaultStatus;
    data['daysOverdue'] = daysOverdue;
    data['status'] = status;
    data['suspensionReason'] = suspensionReason;
    data['suspendedAt'] = suspendedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class YieldAccountModel {
  String? id;
  String? userId;
  String? balance;
  String? depositBalance;
  String? yieldBalance;
  String? totalBalance;
  String? totalDeposited;
  String? totalWithdrawn;
  String? currentApy;
  String? totalYieldEarned;
  String? lastYieldCalculation;
  String? lastYieldDistribution;
  String? lastActivityAt;
  String? blockchainAddress;
  String? lastBlockchainSync;
  String? status;
  bool? autoReinvest;
  String? createdAt;
  String? updatedAt;

  YieldAccountModel({
    this.id,
    this.userId,
    this.balance,
    this.depositBalance,
    this.yieldBalance,
    this.totalBalance,
    this.totalDeposited,
    this.totalWithdrawn,
    this.currentApy,
    this.totalYieldEarned,
    this.lastYieldCalculation,
    this.lastYieldDistribution,
    this.lastActivityAt,
    this.blockchainAddress,
    this.lastBlockchainSync,
    this.status,
    this.autoReinvest,
    this.createdAt,
    this.updatedAt,
  });

  YieldAccountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    balance = json['balance'];
    depositBalance = json['depositBalance'];
    yieldBalance = json['yieldBalance'];
    totalBalance = json['totalBalance'];
    totalDeposited = json['totalDeposited'];
    totalWithdrawn = json['totalWithdrawn'];
    currentApy = json['currentApy'];
    totalYieldEarned = json['totalYieldEarned'];
    lastYieldCalculation = json['lastYieldCalculation'];
    lastYieldDistribution = json['lastYieldDistribution'];
    lastActivityAt = json['lastActivityAt'];
    blockchainAddress = json['blockchainAddress'];
    lastBlockchainSync = json['lastBlockchainSync'];
    status = json['status'];
    autoReinvest = json['autoReinvest'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['balance'] = balance;
    data['depositBalance'] = depositBalance;
    data['yieldBalance'] = yieldBalance;
    data['totalBalance'] = totalBalance;
    data['totalDeposited'] = totalDeposited;
    data['totalWithdrawn'] = totalWithdrawn;
    data['currentApy'] = currentApy;
    data['totalYieldEarned'] = totalYieldEarned;
    data['lastYieldCalculation'] = lastYieldCalculation;
    data['lastYieldDistribution'] = lastYieldDistribution;
    data['lastActivityAt'] = lastActivityAt;
    data['blockchainAddress'] = blockchainAddress;
    data['lastBlockchainSync'] = lastBlockchainSync;
    data['status'] = status;
    data['autoReinvest'] = autoReinvest;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}


class Wallet {
  String? id;
  String? userId;
  String? address;
  String? network;
  String? walletType;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Wallet(
      {this.id,
        this.userId,
        this.address,
        this.network,
        this.walletType,
        this.isActive,
        this.createdAt,
        this.updatedAt});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    address = json['address'];
    network = json['network'];
    walletType = json['walletType'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['address'] = address;
    data['network'] = network;
    data['walletType'] = walletType;
    data['isActive'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
