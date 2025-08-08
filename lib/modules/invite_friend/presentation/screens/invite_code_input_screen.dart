import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/functions.dart';

class InviteCodeInputScreen extends ConsumerStatefulWidget {
  const InviteCodeInputScreen({super.key});

  @override
  ConsumerState createState() => _InviteCodeInputScreenState();
}

class _InviteCodeInputScreenState extends ConsumerState<InviteCodeInputScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(

      ),
    );
  }
}
