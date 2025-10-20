class LatestTransaction {
  String? title;
  String? address;
  double? amount;
  String? currency;
  String? date;
  String? match;

  LatestTransaction({
    this.title,
    this.address,
    this.amount,
    this.currency,
    this.date,
    this.match,
  });

  LatestTransaction.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    address = json['address'];
    amount = json['amount'] != null ? (json['amount'] as num).toDouble() : null;
    currency = json['currency'];
    date = json['date'];
    match = json['match'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'address': address,
      'amount': amount,
      'currency': currency,
      'date': date,
      'match': match,
    };
  }
}
