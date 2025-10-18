import '../constants/app_constants.dart';

extension BigIntExtensions on BigInt {
  double dividedByMillion () {
    if (this == BigInt.zero) {
      return 0.0;
    }
    return this / BigInt.from(oneMillion);
  }
}

extension DoubleExtension on double {
  BigInt multiplyByMillion() {
    return BigInt.from(this * oneMillion);
  }
}