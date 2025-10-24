
import '../../../more/data/models/profile.dart';

class ScannedData {
  num? amount;
  String? walletAddress;
  String? merchantName;
  Profile? profile;

  ScannedData({this.amount, this.walletAddress, this.merchantName, this.profile});

  ScannedData.fromJson(Map<String, dynamic> json, this.profile) {
    amount = json['amount'];
    walletAddress = json['walletAddress'];
    merchantName = json['merchantName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['walletAddress'] = walletAddress;
    data['merchantName'] = merchantName;
    data['profile'] = profile.toString();
    return data;
  }

  String get getAbstractedAddress {
    final address = walletAddress; // Use a local variable for null-safety and readability
    if (address == null || address.length < 7) {
      return address ?? '-';
    }
    return '${address.substring(0, 3)}***********${address.substring(address.length - 4)}';
  }


}
