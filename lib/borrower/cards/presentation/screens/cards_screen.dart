import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../home/presentation/resources/home_strings.dart';
import '../../../more/presentation/widgets/menu_section.dart';
import '../providers/card_providers.dart';
import '../resources/cards_strings.dart';
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
    final padding = MediaQuery.of(context).padding;

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
