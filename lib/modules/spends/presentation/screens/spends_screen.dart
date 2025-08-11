import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';

class SpendsScreen extends ConsumerStatefulWidget {
  const SpendsScreen({super.key});

  @override
  ConsumerState createState() => _SpendsScreenState();
}

class _SpendsScreenState extends ConsumerState<SpendsScreen> with TickerProviderStateMixin{

  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      body: Column(
        children: [
          VerticalSpace(padding.top),
          const VerticalSpace(AppValues.paddingMedium),
          TabBar(
            tabs: [
              Tab(
                text: "",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
