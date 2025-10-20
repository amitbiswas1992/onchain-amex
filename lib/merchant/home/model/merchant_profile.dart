class MerchantProfile {
  final String merchantAddress;
  final String name;
  final bool isAuthorized;
  final List<String> transactionIds;
  final String balance;

  MerchantProfile({
    required this.merchantAddress,
    required this.name,
    required this.isAuthorized,
    required this.transactionIds,
    required this.balance,
  });

  factory MerchantProfile.fromJson(Map<String, dynamic> json) {
    return MerchantProfile(
      merchantAddress: json['merchantAddress'] as String,
      name: json['name'] as String,
      isAuthorized: json['isAuthorized'] as bool,
      transactionIds: List<String>.from(json['transactionIds'] as List),
      balance: json['balance'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchantAddress': merchantAddress,
      'name': name,
      'isAuthorized': isAuthorized,
      'transactionIds': transactionIds,
      'balance': balance,
    };
  }

  MerchantProfile copyWith({
    String? merchantAddress,
    String? name,
    bool? isAuthorized,
    List<String>? transactionIds,
    String? balance,
  }) {
    return MerchantProfile(
      merchantAddress: merchantAddress ?? this.merchantAddress,
      name: name ?? this.name,
      isAuthorized: isAuthorized ?? this.isAuthorized,
      transactionIds: transactionIds ?? this.transactionIds,
      balance: balance ?? this.balance,
    );
  }
}
