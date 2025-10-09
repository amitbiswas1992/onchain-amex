import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/big_int_extensions.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/dividers/app_divider.dart';
import '../../../../core/widgets/errors/when_error_widget.dart';
import '../../../../core/widgets/loaders/when_loading_widget.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../home/data/models/latest_transaction.dart';
import '../../../home/presentation/resources/home_strings.dart';
import '../../../home/presentation/widgets/latest_transaction_tile.dart';
import '../../../more/data/models/profile.dart';
import '../../../more/presentation/providers/more_providers.dart';
import '../providers/transaction_providers.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          final asyncProfile = ref.watch(profileProvider);

          return asyncProfile.when(
            loading: () => const WhenLoadingWidget(),
            error: (err, stack) => WhenErrorWidget(error: err),
            data: (result) {
              switch (result) {
                case Error<Profile?>():
                  return const SizedBox();
                case Ok<Profile?>():
                  if (result.data!.wallet == null) {
                    return const Center(
                      child: Text('You did not connected any wallet yet.'),
                    );
                  }

                  _scrollController.addListener(() {
                    if (_scrollController.position.pixels ==
                        _scrollController.position.maxScrollExtent) {
                      ref
                          .read(transactionHistoryProvider(result.data!.wallet?.address ?? '')
                              .notifier)
                          .getMoreData();
                    }
                  });

                  return Column(
                    children: [
                      VerticalSpace(padding.top),
                      const VerticalSpace(AppValues.paddingMedium),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppValues.paddingMedium,
                        ),
                        child: AppTextFormField(
                          borderRadius: 56,
                          hintText: search,
                          prefixIcon: const Icon(CupertinoIcons.search),
                          onChanged: (val) {
                            ref.read(transactionSearchKey.notifier).state = val;
                          },
                        ),
                      ),
                      // const VerticalSpace(20),
                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: Row(
                      //     children: [
                      //       ...['Date', 'Type', 'Category', 'Currency', 'Others'].map((e) {
                      //         return Container(
                      //           margin: const EdgeInsets.only(left: AppValues.paddingMedium),
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(56),
                      //             border: Border.all(
                      //               color: Colors.grey.shade300,
                      //             ),
                      //           ),
                      //           alignment: Alignment.center,
                      //           padding: const EdgeInsets.symmetric(
                      //             horizontal: 14,
                      //             vertical: AppValues.paddingSmall,
                      //           ),
                      //           child: Text(
                      //             e,
                      //             style: s14W500(context),
                      //           ),
                      //         );
                      //       }),
                      //     ],
                      //   ),
                      // ),
                      const VerticalSpace(20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppValues.paddingMedium),
                        child: AppDivider(),
                      ),
                      const VerticalSpace(AppValues.paddingMedium),
                      Expanded(
                        child: Consumer(builder: (context, ref, _) {
                          final transactionsState = ref.watch(
                              transactionHistoryProvider(result.data?.wallet?.address ?? ''));

                          if (transactionsState.isLoading &&
                              transactionsState.transactionHistory.isEmpty) {
                            return const WhenLoadingWidget(
                              message: 'Loading transactions...',
                            );
                          }

                          if (transactionsState.transactionHistory.isEmpty) {
                            return const Center(
                              child: Text('No transactions yet.'),
                            );
                          }

                          final searchKey = ref.watch(transactionSearchKey);

                          return ListView.builder(
                            itemCount: transactionsState.transactionHistory.length,
                            padding: const EdgeInsets.all(
                              AppValues.paddingMedium,
                            ),
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              final transaction = transactionsState.transactionHistory[index];
                              final merchantName = transaction.merchantName ?? '';
                              final merchantAddress = transaction.merchantAddress ?? '';
                              final amount =
                                  transaction.amount?.toBigInt().blockchainToActual() ?? 0.0;
                              const currency = '';
                              final date = transaction.timestamp == null
                                  ? ''
                                  : uiDateTimeFormat.format(
                                      transaction.timestamp!.toDateFromMillisecondsSinceEpoch()!);

                              if (searchKey.isNotEmpty) {
                                if (!merchantName.toLowerCase().contains(searchKey.toLowerCase()) &&
                                    !merchantAddress
                                        .toLowerCase()
                                        .contains(searchKey.toLowerCase()) &&
                                    !date.toLowerCase().contains(searchKey.toLowerCase())) {
                                  return const SizedBox();
                                }
                              }

                              return LatestTransactionTile(
                                latestTransaction: LatestTransaction(
                                  title: merchantName,
                                  address: merchantAddress,
                                  amount: amount,
                                  currency: '',
                                  date: date,
                                  match: searchKey,
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  );
              }
            },
          );
        },
      ),
    );
  }
}
