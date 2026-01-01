import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/web3_service.dart';
import '../../../../infrastructure/di/global_providers.dart';
import 'wallet_state.dart';

part 'wallet_controller.g.dart';

@Riverpod(keepAlive: true)
class WalletController extends _$WalletController {
  @override
  Future<WalletState> build() async {
    return _init();
  }

  Future<WalletState> _init() async {
    state = const AsyncValue.loading();
    try {
      final web3Service = ref.read(web3ServiceProvider);
      final hasWallet = await web3Service.hasWallet();

      String? address;
      String? balance;

      if (hasWallet) {
        address = await web3Service.getStoredWalletAddress();
        if (address != null) {
          final credentials = await web3Service.getCredentials();
          if (credentials != null) {
            balance =
                await web3Service.getBalanceFormatted(credentials.address);
          }
        }
      }

      return WalletState(
        hasWallet: hasWallet,
        address: address,
        balance: balance,
      );
    } catch (e, st) {
      // Return empty state on error or handle gracefully
      return const WalletState();
    }
  }

  Future<String> createWallet() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final web3Service = ref.read(web3ServiceProvider);
      final credentials = await web3Service.generateNewWallet();
      final address = await credentials.extractAddress();

      // Web3Service handles storage now

      final balance = await web3Service.getBalanceFormatted(address);

      return WalletState(
        hasWallet: true,
        address: address.hex,
        balance: balance,
      );
    });
    return state.value?.address ?? '';
  }

  Future<String> importWallet(String privateKeyHex) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final web3Service = ref.read(web3ServiceProvider);
      final credentials =
          await web3Service.importWalletFromPrivateKey(privateKeyHex);
      final address = credentials.address;

      // Web3Service handles storage now

      final balance = await web3Service.getBalanceFormatted(address);

      return WalletState(
        hasWallet: true,
        address: address.hex,
        balance: balance,
      );
    });
    return state.value?.address ?? '';
  }

  Future<void> deleteWallet() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final web3Service = ref.read(web3ServiceProvider);
      await web3Service.clearWallet();

      return const WalletState(hasWallet: false);
    });
  }

  Future<void> refreshBalance() async {
    final currentState = state.value;
    if (currentState == null || !currentState.hasWallet) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final web3Service = ref.read(web3ServiceProvider);
      final address = await web3Service.getWalletAddress();

      if (address != null) {
        final balance = await web3Service.getBalanceFormatted(address);
        return currentState.copyWith(balance: balance);
      }
      return currentState;
    });
  }

  Future<String?> getPrivateKey() async {
    final web3Service = ref.read(web3ServiceProvider);
    return await web3Service.getStoredPrivateKey();
  }
}
