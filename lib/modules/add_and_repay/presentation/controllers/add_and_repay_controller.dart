import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../../core/widgets/dialogs.dart';
import '../../../wallet/business/services/wallet_service_interface.dart';

class AddAndRepayController {
  final BuildContext context;
  final WidgetRef ref;
  final WalletServiceInterface walletService;

  const AddAndRepayController({required this.context, required this.ref, required this.walletService});

  Future<void> repay(String input) async {
    final amount = double.tryParse(input);
    if (amount == null) {
      showWarningDialog(context: context, message: 'Invalid amount');
      return;
    }
    if (amount <= 0) {
      showWarningDialog(context: context, message: 'Amount must be greater than 0');
      return;
    }

    return walletService.repay(amount);

  }

}
