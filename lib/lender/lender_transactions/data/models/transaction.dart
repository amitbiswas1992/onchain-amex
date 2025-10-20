class Transaction {
  String? borrowerAddress;
  String? merchantAddress;
  String? borrowerName;
  String? merchantName;
  String? amount;
  String? timestamp;
  String? txHash;

  Transaction({
    this.borrowerAddress,
    this.merchantAddress,
    this.borrowerName,
    this.merchantName,
    this.amount,
    this.timestamp,
    this.txHash,
  });

  Transaction.fromJson(Map<String, dynamic> json) {
    borrowerAddress = json['borrowerAddress'];
    merchantAddress = json['merchantAddress'];
    borrowerName = json['borrowerName'];
    merchantName = json['merchantName'];
    amount = json['amount'];
    timestamp = json['timestamp'];
    txHash = json['txHash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['borrowerAddress'] = borrowerAddress;
    data['merchantAddress'] = merchantAddress;
    data['borrowerName'] = borrowerName;
    data['merchantName'] = merchantName;
    data['amount'] = amount;
    data['timestamp'] = timestamp;
    data['txHash'] = txHash;
    return data;
  }
}
