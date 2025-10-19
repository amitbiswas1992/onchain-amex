import '../../data/models/transaction.dart';

class TransactionHistoryState {
  final List<Transaction> transactionHistory;
  final bool isLoading;

  const TransactionHistoryState({
    required this.transactionHistory,
    required this.isLoading,
  });
}
