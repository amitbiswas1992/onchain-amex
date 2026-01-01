class WalletState {
  final String? address;
  final String? balance;
  final bool hasWallet;
  final bool isLoading;

  const WalletState({
    this.address,
    this.balance,
    this.hasWallet = false,
    this.isLoading = false,
  });

  WalletState copyWith({
    String? address,
    String? balance,
    bool? hasWallet,
    bool? isLoading,
  }) {
    return WalletState(
      address: address ?? this.address,
      balance: balance ?? this.balance,
      hasWallet: hasWallet ?? this.hasWallet,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
