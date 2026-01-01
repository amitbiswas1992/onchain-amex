import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../controllers/blockchain_controller.dart';

class WithdrawHeaderWidget extends ConsumerWidget {
  const WithdrawHeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockchainService = ref.watch(blockchainServiceProvider);

    return FutureBuilder<bool>(
      future: blockchainService.isConnected,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? false;

        return InkWell(
          onTap: !isConnected
              ? () {
                  // Navigate to wallet screen (cards tab)
                  AppNav.goRouter.go(RtNm.cardsScreen);
                }
              : null,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
              border: !isConnected
                  ? Border.all(color: Colors.orange.shade300, width: 2)
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: SvgPicture.asset('assets/icons/metamask.svg'),
                ),
                const HorizontalSpace(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isConnected ? 'Wallet Connected' : 'Connect Wallet',
                        style: s16W600(context),
                      ),
                      const VerticalSpace(4),
                      Text(
                        isConnected
                            ? 'Web3 wallet ready'
                            : 'Tap to connect your wallet',
                        style: s14W400(context).copyWith(
                          color: isConnected
                              ? AppColors.c757575
                              : Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isConnected)
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: Colors.orange.shade700,
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 24,
                      color: Colors.green.shade600,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
