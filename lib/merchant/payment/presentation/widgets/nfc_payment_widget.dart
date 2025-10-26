import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../borrower/more/presentation/providers/more_providers.dart';
import '../../../../borrower/spends/presentation/resources/spends_strings.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/animated_ring_loader.dart';
import '../../../../core/widgets/dialogs.dart';

class NfcPaymentWidget extends ConsumerStatefulWidget {
  final String paymentUrl;

  const NfcPaymentWidget({super.key, required this.paymentUrl});

  @override
  ConsumerState<NfcPaymentWidget> createState() => _NfcPaymentWidgetState();
}

class _NfcPaymentWidgetState extends ConsumerState<NfcPaymentWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startEmulation();
    });
  }

  void _startEmulation() async {
    try {
      final value = await ref.read(nfcHceProvider).startNfcHce(
            widget.paymentUrl,
            mimeType: 'application/com.nodecard.xyz',
          );
      print('value $value');
    } catch (e) {
      print('NFC HCE start error: $e');
      showErrorDialog(context: context, message: 'Could not start NFC HCE.');
    }
  }

  void _stopEmulation() async {
    try {
      await ref.read(nfcHceProvider).stopNfcHce();
    } catch (e) {
      print('NFC HCE stop error: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _stopEmulation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // NFC Animation
          SvgPicture.asset('assets/icons/nfc_card.svg'),
          const VerticalSpace(AppValues.paddingMedium),
          const Text(holdYourPhoneNearThePOS),
          const VerticalSpace(AppValues.paddingLarge),
          InkWell(
            onTap: () {
              // AppNav.goRouter.push(RtNm.spendAfterScanAmountInputScreen);
            },
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppValues.borderRadiusMedium,
                ),
                gradient: const RadialGradient(
                  colors: [
                    Color(0xFF464646), // Light color in center
                    Color(0xFF1E1E1E), // Dark color outside
                  ],
                  center: Alignment.center,
                  radius: 0.8, // Increase for wider light area
                ),
              ),
              child: AnimatedRingLoader(
                child: SvgPicture.asset('assets/icons/buzzing.svg'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NfcRipplePainter extends CustomPainter {
  final Animation<double> animation;

  NfcRipplePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.white.withValues(alpha: 0.3);

    // Draw 3 expanding circles
    for (int i = 0; i < 3; i++) {
      final progress = (animation.value + (i * 0.33)) % 1.0;
      final radius = maxRadius * progress;
      final opacity = (1.0 - progress) * 0.5;

      canvas.drawCircle(
        center,
        radius,
        paint..color = Colors.white.withValues(alpha: opacity),
      );
    }
  }

  @override
  bool shouldRepaint(NfcRipplePainter oldDelegate) => true;
}
