class WalletInfo {
  final String publicAddress;
  final String network;
  final String walletName;

  WalletInfo({
    required this.publicAddress,
    required this.network,
    required this.walletName,
  });

  Map<String, dynamic> toJson() {
    return {
      'publicAddress': publicAddress,
      'network': network,
      'walletName': walletName,
    };
  }
}