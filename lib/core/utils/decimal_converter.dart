class DecimalConverter {
  DecimalConverter._();

  // Both USDC and Vault Shares use 6 decimals
  static const int decimals = 6;
  static final BigInt decimalFactor = BigInt.from(1000000); // 10^6

  /// Convert UI amount to contract amount
  /// Example: 1000 USDC (UI) -> 1000000000 (contract)
  static BigInt toContractAmount(double uiAmount) {
    try {
      final amountInSmallestUnit = (uiAmount * decimalFactor.toDouble())
          .round();
      return BigInt.from(amountInSmallestUnit);
    } catch (e) {
      print('Error converting to contract amount: $e');
      return BigInt.zero;
    }
  }

  /// Convert contract amount to UI amount
  /// Example: 1000000000 (contract) -> 1000 USDC (UI)
  static double toUiAmount(BigInt contractAmount) {
    try {
      return contractAmount.toDouble() / decimalFactor.toDouble();
    } catch (e) {
      print('Error converting to UI amount: $e');
      return 0.0;
    }
  }

  /// Format amount for display
  static String formatAmount(double amount, {int decimalsToShow = 2}) {
    try {
      return amount.toStringAsFixed(decimalsToShow);
    } catch (e) {
      return '0.00';
    }
  }

  /// Format contract amount for display
  static String formatContractAmount(
    BigInt contractAmount, {
    int decimalsToShow = 2,
  }) {
    final uiAmount = toUiAmount(contractAmount);
    return formatAmount(uiAmount, decimalsToShow: decimalsToShow);
  }

  /// Parse string to contract amount
  static BigInt parseToContractAmount(String amountString) {
    try {
      final double amount = double.parse(amountString);
      return toContractAmount(amount);
    } catch (e) {
      print('Error parsing amount: $e');
      return BigInt.zero;
    }
  }
}
