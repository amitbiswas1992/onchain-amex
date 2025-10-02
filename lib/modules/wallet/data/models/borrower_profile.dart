class BorrowerProfile {
  String? creditLimit;
  String? outstandingDebt;
  String? totalSpent;
  String? totalRepaid;
  String? spendingCount;
  String? repaymentCount;
  String? lastActivityTime;
  String? creditScore;
  bool? isActive;

  BorrowerProfile({
    this.creditLimit,
    this.outstandingDebt,
    this.totalSpent,
    this.totalRepaid,
    this.spendingCount,
    this.repaymentCount,
    this.lastActivityTime,
    this.creditScore,
    this.isActive,
  });

  BorrowerProfile.fromJson(Map<String, dynamic> json) {
    creditLimit = json['creditLimit'];
    outstandingDebt = json['outstandingDebt'];
    totalSpent = json['totalSpent'];
    totalRepaid = json['totalRepaid'];
    spendingCount = json['spendingCount'];
    repaymentCount = json['repaymentCount'];
    lastActivityTime = json['lastActivityTime'];
    creditScore = json['creditScore'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['creditLimit'] = creditLimit;
    data['outstandingDebt'] = outstandingDebt;
    data['totalSpent'] = totalSpent;
    data['totalRepaid'] = totalRepaid;
    data['spendingCount'] = spendingCount;
    data['repaymentCount'] = repaymentCount;
    data['lastActivityTime'] = lastActivityTime;
    data['creditScore'] = creditScore;
    data['isActive'] = isActive;
    return data;
  }
}
