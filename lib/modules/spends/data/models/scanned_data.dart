class ScannedData {
  num? amount;
  String? walletAddress;
  String? merchantName;

  ScannedData({this.amount, this.walletAddress, this.merchantName});

  ScannedData.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    walletAddress = json['walletAddress'];
    merchantName = json['merchantName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['walletAddress'] = walletAddress;
    data['merchantName'] = merchantName;
    return data;
  }
}
