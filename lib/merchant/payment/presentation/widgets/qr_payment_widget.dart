import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/texts/text_styles.dart';

class QrPaymentWidget extends StatelessWidget {
  final String paymentUrl;

  const QrPaymentWidget({super.key, required this.paymentUrl});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Text('QR Payment', style: s18W600(context).copyWith(fontSize: 24)),
          const VerticalSpace(20),
          Text(
            'Ask the customer to scan the QR Code',
            style: s14W400(context).copyWith(color: AppColors.c757575),
            textAlign: TextAlign.center,
          ),
          const VerticalSpace(20),
          const VerticalSpace(40),
          // QR Code
          Container(
            width: 300,
            height: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: QrImageView(
              data: paymentUrl,
              version: QrVersions.auto,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.black,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Colors.black,
              ),
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(50, 50),
              ),
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            ),
          ),
          const VerticalSpace(32),

          const VerticalSpace(24),
        ],
      ),
    );
  }
}
