import '../constants/app_constants.dart';

extension NumExtensions on BigInt {
  double blockchainToActual () {
    if (this == BigInt.zero) {
      return 0.0;
    }
    return this / BigInt.from(oneMillion);
  }

  BigInt toBlockchainValue() {
    return this * BigInt.from(oneMillion);
  }
}