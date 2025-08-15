import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/dividers/app_divider.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../home/data/models/latest_transaction.dart';
import '../../../home/presentation/resources/home_strings.dart';
import '../../../home/presentation/widgets/latest_transaction_tile.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final _latestTransactions = [
    LatestTransaction(
      title: 'Starbucks',
      address: '0xuywet7687y8jhw876hhbtxa3456',
      amount: 5.0,
      currency: 'USDC',
      date: '11 Jul,25 : 03:55 PM',
    ),
    LatestTransaction(
      title: 'Book Worm',
      address: '0xuywet7687y8jhw876hhbtxa3456',
      amount: 2.3,
      currency: 'USDC',
      date: '11 Jul,25 : 03:55 PM',
    ),
    LatestTransaction(
      title: 'J&G Cinema',
      address: '0xuywet7687y8jhw876hhbtxa3456',
      amount: 8.5,
      currency: 'USDC',
      date: '11 Jul,25 : 03:55 PM',
    ),
    LatestTransaction(
      title: 'Starbucks',
      address: '0xuywet7687y8jhw876hhbtxa3456',
      amount: 5.0,
      currency: 'USDC',
      date: '11 Jul,25 : 03:55 PM',
    ),
    LatestTransaction(
      title: 'Starbucks',
      address: '0x................3456',
      amount: 5.0,
      currency: 'USDC',
      date: '11 Jul,25 : 03:55 PM',
    ),
    LatestTransaction(
      title: 'J&G Cinema',
      address: '0xuywet7687y8jhw876hhbtxa3456',
      amount: 8.5,
      currency: 'USDC',
      date: '11 Jul,25 : 03:55 PM',
    ),
    LatestTransaction(
      title: 'Starbucks',
      address: '0xuywet7687y8jhw876hhbtxa3456',
      amount: 5.0,
      currency: 'USDC',
      date: '11 Jul,25 : 03:55 PM',
    ),
    LatestTransaction(
      title: 'Starbucks',
      address: '0x................3456',
      amount: 5.0,
      currency: 'USDC',
      date: '11 Jul,25 : 03:55 PM',
    ),
    LatestTransaction(
      title: 'Starbucks',
      address: '0xuywet7687y8jhw876hhbtxa3456',
      amount: 5.0,
      currency: 'USDC',
      date: '11 Jul,25 : 03:55 PM',
    ),
    LatestTransaction(
      title: 'Starbucks',
      address: '0x................3456',
      amount: 5.0,
      currency: 'USDC',
      date: '11 Jul,25 : 03:55 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: Column(
        children: [
          VerticalSpace(padding.top),
          const VerticalSpace(AppValues.paddingMedium),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppValues.paddingMedium,
            ),
            child: AppTextFormField(
              borderRadius: 56,
              hintText: search,
              prefixIcon: Icon(CupertinoIcons.search),
            ),
          ),
          const VerticalSpace(20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...['Date', 'Type', 'Category', 'Currency', 'Others'].map((e) {
                  return Container(
                    margin: const EdgeInsets.only(left: AppValues.paddingMedium),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(56),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: AppValues.paddingSmall,
                    ),
                    child: Text(
                      e,
                      style: s14W500(context),
                    ),
                  );
                }),
              ],
            ),
          ),
          const VerticalSpace(20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppValues.paddingMedium),
            child: AppDivider(),
          ),
          const VerticalSpace(AppValues.paddingMedium),
          Expanded(
            child: ListView.builder(
              itemCount: _latestTransactions.length,
              padding: const EdgeInsets.all(
                AppValues.paddingMedium,
              ),
              itemBuilder: (context, index) {
                return LatestTransactionTile(
                  latestTransaction: _latestTransactions[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
