import '../constants/app_constants.dart';

extension BigIntExtensions on BigInt {
  double blockchainToActual () {
    if (this == BigInt.zero) {
      return 0.0;
    }
    return this / BigInt.from(oneMillion);
  }
}

extension DoubleExtension on double {
  BigInt toBlockchainValue() {
    return BigInt.from(this * oneMillion);
  }
}