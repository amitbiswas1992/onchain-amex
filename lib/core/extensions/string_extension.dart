import 'dart:developer' show log;

extension StringExtension on String {
  void show({required String tag}) {
    log('$tag=> $this');
  }

  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  BigInt toBigInt() {
    return BigInt.tryParse(this) ?? BigInt.zero;
  }

  DateTime? toDateFromMillisecondsSinceEpoch() {
    try {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(this) * 1000).toLocal();
    } catch (e) {
      return null;
    }
  }
}
