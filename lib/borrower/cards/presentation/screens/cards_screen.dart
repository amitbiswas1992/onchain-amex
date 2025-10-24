import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/card_providers.dart';
import '../widgets/add_card_widget.dart';
import '../widgets/card_widget.dart';

class CardsScreen extends ConsumerStatefulWidget {
  const CardsScreen({super.key});

  @override
  ConsumerState createState() => _CardsScreenState();
}

class _CardsScreenState extends ConsumerState<CardsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          final cardAdded = ref.watch(cardAddedProvider);
          switch (cardAdded) {
            case true:
              return const CardWidget();
            case false:
              return const AddCardWidget();
          }
        },
      ),
    );
  }
}
