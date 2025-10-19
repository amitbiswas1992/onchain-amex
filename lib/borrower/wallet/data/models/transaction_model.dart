class TransactionModel {
  String? transactionHash;
  int? blockNumber;
  String? gasUsed;
  String? status;

  TransactionModel({
    this.transactionHash,
    this.blockNumber,
    this.gasUsed,
    this.status,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    transactionHash = json['transactionHash'];
    blockNumber = json['blockNumber'];
    gasUsed = json['gasUsed'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transactionHash'] = transactionHash;
    data['blockNumber'] = blockNumber;
    data['gasUsed'] = gasUsed;
    data['status'] = status;
    return data;
  }
}
