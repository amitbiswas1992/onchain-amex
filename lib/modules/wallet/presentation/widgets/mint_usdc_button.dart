// Helper widget for mint USDC button
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../business/services/wallet_service.dart';

class MintUsdcButton extends ConsumerStatefulWidget {
  final WalletService walletService;

  const MintUsdcButton({required this.walletService});

  @override
  ConsumerState<MintUsdcButton> createState() => _MintUsdcButtonState();
}

class _MintUsdcButtonState extends ConsumerState<MintUsdcButton> {
  bool _isMinting = false;

  Future<void> _mintUsdc() async {
    setState(() {
      _isMinting = true;
    });

    try {
      final txHash = await widget.walletService.mintUsdc(1000.0);

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Minting 1000 USDC... Tx: ${txHash.substring(0, 10)}...',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Wait a bit for transaction confirmation
      await Future.delayed(const Duration(seconds: 3));

      // Refresh balances
      if (mounted) {
        // ref.invalidate(usdcBalanceProvider);
      }
    } catch (e) {
      if (!mounted) return;
      print('Error minting USDC: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to mint USDC: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isMinting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isMinting ? null : _mintUsdc,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: AppColors.primaryLight.withOpacity(0.5),
        ),
        child: _isMinting
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Text(
          'Mint 1000 USDC (Test)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}