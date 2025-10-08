import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../infrastructure/network/result.dart';
import '../../data/models/transaction.dart';
import 'transaction_history_state.dart';
import 'transaction_providers.dart';

class TransactionHistoryNotifier extends StateNotifier<TransactionHistoryState> {
  final Ref ref;
  final String publicAddress;
  int skipItem = 0;
  int perPage = 1;
  bool allDataLoaded = false;


  TransactionHistoryNotifier(this.ref, this.publicAddress)
      : super(
          const TransactionHistoryState(transactionHistory: [], isLoading: true),
        ) {
    _init();
  }

  Future<void> _init() async {
    getMoreData();
  }

  Future<void> getMoreData() async {
    if (allDataLoaded) {
      return;
    }
    final result = await ref.read(transactionRepo).getTransactions(
          publicAddress: publicAddress,
          skipItem: skipItem,
          perPage: perPage,
        );

    skipItem+=perPage;

    switch (result) {
      case Ok<List<Transaction>?>():
        if (result.data!.length < perPage) {
          allDataLoaded = true;
        }
        state = TransactionHistoryState(
          transactionHistory: [...state.transactionHistory, ...result.data!],
          isLoading: false,
        );
      case Error<List<Transaction>?>():
    }
  }
}
