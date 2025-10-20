import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debouce_query_controller.g.dart';

/// A notifier class to keep track of the search query (with debouncing)
@riverpod
class DebouceQueryController extends _$DebouceQueryController {
  /// Used to debounce the input queries
  Timer? _debounceTimer;

  @override
  double build() {
    // don't forget to close the StreamController and cancel the subscriptions on dispose
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    // by default, return an empty query
    return 0.00;
  }

  void setAmount(double amount) {
    // Cancel the timer if it is active
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      // only update the state once the query has been debounced
      state = amount;
    });
  }
}
