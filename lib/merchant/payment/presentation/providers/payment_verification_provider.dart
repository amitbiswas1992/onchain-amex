import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/string_extension.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../../lender/lender_transactions/data/models/transaction.dart';
import '../../../../lender/lender_transactions/presentation/providers/transaction_providers.dart';

enum PaymentVerificationStatus { waiting, success, failed, timeout }

class PaymentVerificationState {
  final PaymentVerificationStatus status;
  final Transaction? matchedTransaction;
  final String? errorMessage;

  const PaymentVerificationState({
    required this.status,
    this.matchedTransaction,
    this.errorMessage,
  });

  PaymentVerificationState copyWith({
    PaymentVerificationStatus? status,
    Transaction? matchedTransaction,
    String? errorMessage,
  }) {
    return PaymentVerificationState(
      status: status ?? this.status,
      matchedTransaction: matchedTransaction ?? this.matchedTransaction,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class PaymentVerificationNotifier
    extends StateNotifier<PaymentVerificationState> {
  final Ref ref;
  final double expectedAmount;
  final DateTime paymentStartTime;
  Timer? _pollingTimer;
  int _pollCount = 0;
  static const int maxPolls = 60; // Poll for 2 minutes (60 * 2 seconds)
  static const Duration pollingInterval = Duration(seconds: 2);

  PaymentVerificationNotifier({
    required this.ref,
    required this.expectedAmount,
    required this.paymentStartTime,
  }) : super(
          const PaymentVerificationState(
            status: PaymentVerificationStatus.waiting,
          ),
        ) {
    _startPollingWithDelay();
  }

  void _startPollingWithDelay() {
    log(
      'Payment verification will start in 10 seconds for amount: \$${expectedAmount.toStringAsFixed(2)}',
    );
    // Wait 10 seconds before starting to poll
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        _startPolling();
      }
    });
  }

  void _startPolling() {
    log('Starting payment verification polling');
    _pollingTimer = Timer.periodic(pollingInterval, (_) => _checkForPayment());
  }

  Future<void> _checkForPayment() async {
    if (_pollCount >= maxPolls) {
      log('Payment verification timeout after ${maxPolls * 2} seconds');
      state = state.copyWith(
        status: PaymentVerificationStatus.timeout,
        errorMessage: 'Payment verification timeout. Please try again.',
      );
      _stopPolling();
      return;
    }

    _pollCount++;
    log('Payment verification poll #$_pollCount');

    try {
      // Fetch latest transactions
      final result = await ref.read(transactionRepo).getTransactions(
            skipItem: 0,
            perPage: 10, // Get last 10 transactions
          );

      switch (result) {
        case Ok<List<Transaction>?>():
          final transactions = result.data ?? [];

          // Check if any transaction matches the expected amount and is after payment start time
          for (var transaction in transactions) {
            final txAmount = double.tryParse(transaction.amount ?? '0') ?? 0.0;
            final txDateTime = (transaction.timestamp ?? '0.0')
                    .toDateFromMillisecondsSinceEpoch() ??
                DateTime.fromMillisecondsSinceEpoch(0);

            log(
              'Checking transaction: amount=\$${txAmount.toStringAsFixed(2)}, '
              'timestamp=$txDateTime, txHash=${transaction.txHash}',
            );

            // Check if transaction amount matches and is after payment start time
            if (_amountsMatch(txAmount, expectedAmount) &&
                txDateTime.isAfter(paymentStartTime)) {
              log('Payment verified! Transaction found: ${transaction.txHash}');
              state = state.copyWith(
                status: PaymentVerificationStatus.success,
                matchedTransaction: transaction,
              );
              _stopPolling();
              return;
            }
          }

          log('No matching transaction found yet');
          break;

        case Error<List<Transaction>?>():
          log('Error fetching transactions: ${result.error}');
          // Don't stop polling on error, continue trying
          break;
      }
    } catch (e, stackTrace) {
      log('Exception during payment verification: $e', stackTrace: stackTrace);
      // Continue polling even on exception
    }
  }

  bool _amountsMatch(double amount1, double amount2) {
    // Compare amounts with a small tolerance for floating point precision
    const tolerance = 0.01;
    return (amount1 - amount2 * 1000000).abs() < tolerance;
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void manualCancel() {
    log('Payment verification manually cancelled');
    state = state.copyWith(
      status: PaymentVerificationStatus.failed,
      errorMessage: 'Payment verification cancelled by user',
    );
    _stopPolling();
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }
}

final paymentVerificationProvider = StateNotifierProvider.autoDispose.family<
    PaymentVerificationNotifier,
    PaymentVerificationState,
    Map<String, dynamic>>((ref, params) {
  return PaymentVerificationNotifier(
    ref: ref,
    expectedAmount: params['amount'] as double,
    paymentStartTime: params['startTime'] as DateTime,
  );
});
