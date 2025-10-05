import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_values.dart';
import '../../utils/sizebox_util.dart';
import 'text_styles.dart';

// Enum must be declared at top level
enum CopyState { idle, loading, copied }

class TransactionHashText extends StatefulWidget {
  final String text;

  const TransactionHashText({super.key, required this.text});

  @override
  State<TransactionHashText> createState() => _TransactionHashTextState();
}

class _TransactionHashTextState extends State<TransactionHashText> {
  CopyState _state = CopyState.idle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Transaction Hash', style: s12W600(context)),
              const VerticalSpace(6),
              Text(widget.text, style: s14W400(context),),
            ],
          ),
        ),
        const HorizontalSpace(AppValues.paddingSmall),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: _buildIcon(),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    switch (_state) {
      case CopyState.idle:
        return InkResponse(
          key: const ValueKey('copy'),
          onTap: () async {
            setState(() => _state = CopyState.loading);
            await FlutterClipboard.copy(widget.text);
            setState(() => _state = CopyState.copied);

            // Optional: revert back to idle after 1.5 seconds
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) setState(() => _state = CopyState.idle);
          },
          child: const Icon(Icons.copy),
        );

      case CopyState.loading:
        return const SizedBox(
          key: ValueKey('loading'),
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        );

      case CopyState.copied:
        return const Icon(
          Icons.check,
          key: ValueKey('check'),
          color: AppColors.primaryLight,
        );
    }
  }
}
