import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../infrastructure/network/result.dart';
import '../../data/models/transaction.dart';
import 'transaction_history_state.dart';
import 'transaction_providers.dart';

class TransactionHistoryNotifier extends StateNotifier<TransactionHistoryState> {
  final Ref ref;
  final String publicAddress;
  int page = 1;
  int perPage = 10;

  TransactionHistoryNotifier(this.ref, this.publicAddress)
      : super(
          const TransactionHistoryState(transactionHistory: [], isLoading: true),
        ) {
    _init();
  }

  Future<void> _init() async {
    final result = await ref.read(transactionRepo).getTransactions(
          publicAddress: publicAddress,
          page: page,
          perPage: perPage,
        );

    page++;

    switch (result) {
      case Ok<List<Transaction>?>():
        state = TransactionHistoryState(transactionHistory: [...result.data!], isLoading: false);
      case Error<List<Transaction>?>():
    }
  }

  Future<void> getMoreData() async {
    final result = await ref.read(transactionRepo).getTransactions(
          publicAddress: publicAddress,
          page: page,
          perPage: perPage,
        );

    page++;

    switch (result) {
      case Ok<List<Transaction>?>():
        state = TransactionHistoryState(
          transactionHistory: [...state.transactionHistory, ...result.data!],
          isLoading: false,
        );
      case Error<List<Transaction>?>():
    }
  }
}
