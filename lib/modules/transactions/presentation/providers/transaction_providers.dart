import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../infrastructure/di/global_providers.dart';
import '../../data/models/transaction.dart';
import '../../data/repositories/transaction_repo.dart';
import 'transaction_hintory_notifier.dart';
import 'transaction_history_state.dart';

final transactionRepo = Provider<TransactionRepo>(
  (ref) => TransactionRepo(dioService: ref.read(dioService)),
);

final transactionHistoryProvider = StateNotifierProvider.family<TransactionHistoryNotifier, TransactionHistoryState ,String>((ref, publicAddress) {
  return TransactionHistoryNotifier(ref, publicAddress);
});