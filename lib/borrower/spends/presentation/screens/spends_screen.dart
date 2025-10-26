import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/loaders/when_loading_widget.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../more/data/models/profile.dart';
import '../../../more/presentation/providers/more_providers.dart';
import '../../data/models/scanned_data.dart';
import '../resources/spends_strings.dart';
import '../widgets/spends_nfc_page.dart';
import 'manual_payment_screen.dart';

class SpendsScreen extends ConsumerStatefulWidget {
  const SpendsScreen({super.key});

  @override
  ConsumerState createState() => _SpendsScreenState();
}

class _SpendsScreenState extends ConsumerState<SpendsScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController _pageController;
  Profile? profile;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _disposeNfc();
    super.dispose();
  }

  Future<void> _disposeNfc() async {
    if (await NfcManager.instance.checkAvailability() ==
        NfcAvailability.enabled) {
      NfcManager.instance.stopSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      body: ref.watch(profileProvider).when(
            data: (profileResult) {
              switch (profileResult) {
                case Ok<Profile?>():
                  dev.log('setting the profile');
                  profile = profileResult.data;
                case Error<Profile?>():
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.paddingMedium,
                    ),
                    child: Column(
                      children: [
                        VerticalSpace(padding.top),
                        const VerticalSpace(AppValues.paddingMedium),
                        SizedBox(
                          height: 40,
                          child: TabBar(
                            controller: _tabController,
                            labelStyle:
                                s14W500(context).copyWith(color: Colors.white),
                            labelPadding: const EdgeInsets.only(
                              left: AppValues.paddingLarge,
                              right: AppValues.paddingLarge,
                              top: 5,
                            ),
                            unselectedLabelStyle: s14W500(context),
                            indicator: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(56),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerHeight: 0,
                            tabAlignment: TabAlignment.start,
                            isScrollable: true,
                            physics: const NeverScrollableScrollPhysics(),
                            tabs: const [
                              Tab(
                                text: pay,
                              ),
                              Tab(
                                text: nfc,
                              ),
                              Tab(
                                text: scanAndPay,
                              ),
                            ],
                            onTap: (index) async {
                              if (index == 1) {
                                _handleNfcTap();
                              }
                              if (index == 2) {
                                _handleQrScan();
                              }
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                        const VerticalSpace(AppValues.paddingLarge),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (page) {
                        _tabController.animateTo(page);
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const ManualPaymentScreen(),
                        const SpendsNfcPage(),
                        // ScanAndPayPage(),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  _handleQrScan();
                                },
                                child: Image.asset(
                                  'assets/icons/qr.png',
                                  height: 80,
                                  width: 80,
                                  color: isLightTheme(context)
                                      ? null
                                      : Colors.white,
                                ),
                              ),
                              const VerticalSpace(AppValues.paddingSmall),
                              Text(
                                'Tap to scan',
                                style: s18W600(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            error: (error, stck) => const SizedBox(),
            loading: () => const WhenLoadingWidget(
              message: 'Getting user information...',
            ),
          ),
    );
  }

  void _handleNfcTap() async {
    try {
      print('nfc tapped');
      NfcAvailability availability =
          await NfcManager.instance.checkAvailability();
      if (availability == NfcAvailability.unsupported) {
        // AppSettings.openAppSettingsPanel(AppSettingsPanelType.nfc);
        print('NFC may not be supported or may be temporarily disabled.');
        return;
      } else if (availability == NfcAvailability.disabled) {
        print('NFC is disabled');
        // AppSettings.openAppSettingsPanel(AppSettingsPanelType.nfc);
        return;
      }
      print('NFC is available');
      NfcManager.instance.startSession(
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
          NfcPollingOption.iso18092,
        },
        onDiscovered: (NfcTag tag) async {
          print('NFC tag discovered');
          print(tag);
          final ndef = Ndef.from(tag);
          if (ndef == null) {
            print('Tag is not NDEF formatted');
            NfcManager.instance.stopSession();
            return;
          }
          final ndefMessage = await ndef.read();
          if (ndefMessage == null) {
            print('NDEF message is null');
            NfcManager.instance.stopSession();
            return;
          }
          print('NDEF message read: $ndefMessage');
          final record = ndefMessage.records.first;
          final payload = record.payload;
          final uri = Uri.parse(utf8.decode(payload));
          final dataStr =
              utf8.decode(base64Url.decode(uri.queryParameters['data']!));
          dev.log('data => ${dataStr.runtimeType} => $dataStr');
          // showInfoDialog(context: context, message: dataStr, dismissible: false);
          if (profile == null) {
            dev.log('profile is null');
          } else {
            dev.log('profile is not null');
          }
          AppNav.goRouter.push(
            RtNm.paymentScreen,
            extra: ScannedData.fromJson(jsonDecode(dataStr), profile),
          );
        },
      );
    } catch (e) {
      print('Error handling NFC tap: $e');
      NfcManager.instance.stopSession();
    }
  }

  void _handleQrScan() async {
    final dcc = await AppNav.goRouter.push(RtNm.qrCodeScannerScreen);
    if (dcc == null) {
      return null;
    }
    await Future.delayed(const Duration(seconds: 1));
    try {
      final uri = Uri.tryParse(dcc.toString());
      if (uri == null) {
        return;
      }
      final dataStr =
          utf8.decode(base64Url.decode(uri.queryParameters['data']!));
      dev.log('data => ${dataStr.runtimeType} => $dataStr');
      // showInfoDialog(context: context, message: dataStr, dismissible: false);
      if (profile == null) {
        dev.log('profile is null');
      } else {
        dev.log('profile is not null');
      }
      AppNav.goRouter.push(
        RtNm.paymentScreen,
        extra: ScannedData.fromJson(jsonDecode(dataStr), profile),
      );
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
      showErrorDialog(
        context: context,
        message: 'Failed to process the QR code,',
      );
    }
  }
}
