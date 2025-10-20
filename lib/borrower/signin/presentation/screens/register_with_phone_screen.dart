import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/buttons/app_secondary_button.dart';
import '../../../../core/widgets/phone_number_text_field.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../controllers/sign_in_controller.dart';
import '../providers/sign_in_providers.dart';
import '../resources/signin_strings.dart';
import '../widgets/amex_text_app_bar.dart';
import '../widgets/user_consent_text.dart';
import 'role_tabs.dart';

class RegisterWithPhoneScreen extends ConsumerStatefulWidget {
  const RegisterWithPhoneScreen({super.key});

  @override
  ConsumerState createState() => _RegisterWithPhoneScreenState();
}

class _RegisterWithPhoneScreenState
    extends ConsumerState<RegisterWithPhoneScreen>
    with SingleTickerProviderStateMixin {
  late final SignInController _controller;
  late final TabController tabController;

  final _formKey = GlobalKey<FormState>();
  final _phoneNode = FocusNode();
  final _passwordNode = FocusNode();
  final _firstNameNode = FocusNode();
  final _lastNameNode = FocusNode();
  String _firstName = '';
  String _lastName = '';
  String _password = '';
  String _phone = '';

  // Add local role state
  final _UserRole _selectedRole = _UserRole.borrower;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    _controller = SignInController(
      context: context,
      ref: ref,
      signInRepo: ref.read(signInRepoProvider),
      deviceInfoService: ref.read(deviceInfoService),
    );
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    _phoneNode.dispose();
    _passwordNode.dispose();
    _firstNameNode.dispose();
    _lastNameNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.paddingMedium,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AmexTextAppBar(),
                  const VerticalSpace(AppValues.paddingMedium),
                  const VerticalSpace(36),
                  const TitleText(
                    text: letsGetYouRegistered,
                    textAlign: TextAlign.start,
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  RoleTabWidget(tabController: tabController),
                  Consumer(
                    builder: (context, ref, _) {
                      final countryCode =
                          ref.watch(selectedCountryCodeProvider);

                      return PhoneNumberTextField(
                        focusNode: _phoneNode,
                        countryCode: countryCode,
                        onCountryCodeChanged: (code) {
                          ref.read(selectedCountryCodeProvider.notifier).state =
                              code;
                        },
                        prefixIcon: const Icon(
                          CupertinoIcons.device_phone_portrait,
                          size: 20,
                        ),
                        autoFocus: true,
                        onFieldSubmitted: (val) {
                          _passwordNode.requestFocus();
                        },
                        onSave: (val) {
                          _phone = '${countryCode.dialCode}${val ?? ' '}';
                          _phone = _phone.replaceAll('-', '');
                          _phone = _phone.replaceAll(' ', '');
                          _phone = _phone.replaceAll(')', '');
                          _phone = _phone.replaceAll('(', '');
                        },
                      );
                    },
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  AppTextFormField(
                    focusNode: _passwordNode,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      size: 20,
                    ),
                    hintText: password,
                    maxLines: 1,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onSave: (val) {
                      _password = val ?? '';
                    },
                    // validator: (val) {
                    //   if (val == null || val.isEmpty) {
                    //     return inputRequired;
                    //   }
                    //   if (val.length < 8) {
                    //     return 'Password should be 8 character long';
                    //   }
                    //   return null;
                    // },
                    validator: validatePassword,
                    onFieldSubmitted: (val) {
                      _passwordNode.unfocus();
                      _firstNameNode.requestFocus();
                    },
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  AppTextFormField(
                    focusNode: _firstNameNode,
                    hintText: firstName,
                    prefixIcon: const Icon(CupertinoIcons.person),
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    onFieldSubmitted: (value) {
                      _lastNameNode.requestFocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return inputRequired;
                      }
                      return null;
                    },
                    onSave: (val) {
                      _firstName = val ?? '';
                    },
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  AppTextFormField(
                    focusNode: _lastNameNode,
                    hintText: lastName,
                    prefixIcon: const Icon(CupertinoIcons.person),
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    onFieldSubmitted: (value) {
                      _lastNameNode.unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return inputRequired;
                      }
                      return null;
                    },
                    onSave: (val) {
                      _lastName = val ?? '';
                    },
                  ),
                  const VerticalSpace(32),
                  Row(
                    children: [
                      Expanded(
                        child: AppSecondaryButton(
                          title: useEmail,
                          onTap: () {
                            AppNav.goRouter
                                .pushReplacement(RtNm.registerWithEmailScreen);
                          },
                        ),
                      ),
                      const HorizontalSpace(AppValues.paddingMedium),
                      Expanded(
                        child: AppPrimaryButton(
                          title: continuee,
                          onTap: () async {
                            final valid = _formKey.currentState!.validate();
                            if (valid) {
                              _formKey.currentState!.save();
                              _controller.register(
                                email: _phone,
                                password: _password,
                                firstName: _firstName,
                                lastName: _lastName,
                                isEmail: false,
                                userType: tabController.index == 0
                                    ? 'BORROWER'
                                    : tabController.index == 1
                                        ? 'LENDER'
                                        : 'MERCHANT',
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpace(AppValues.paddingLarge),
                  RichText(
                    text: TextSpan(
                      text: "Already have an account?  ",
                      style: s14W400(context),
                      children: [
                        TextSpan(
                          text: "Login.",
                          style: s14W500(context)
                              .copyWith(color: AppColors.primaryLight),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              AppNav.goRouter.push(RtNm.loginWithPhoneScreen);
                            },
                        ),
                      ],
                    ),
                  ),
                  const VerticalSpace(82),
                  const UserConsentText(),
                  const VerticalSpace(40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Simple role enum
enum _UserRole { borrower, merchant, lender }

// Tabs widget
class RoleTabs extends StatelessWidget {
  final _UserRole selected;
  final ValueChanged<_UserRole> onChanged;

  const RoleTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      (_UserRole.borrower, 'Borrower'),
      (_UserRole.merchant, 'Merchant'),
      (_UserRole.lender, 'Lender'),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final isSelected = selected == item.$1;
        return ChoiceChip(
          label: Text(
            item.$2,
            style: s14W500(context, fontFamily: interFontFamily).copyWith(
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).iconTheme.color,
            ),
          ),
          selected: isSelected,
          onSelected: (_) => onChanged(item.$1),
          selectedColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: StadiumBorder(
            side: BorderSide(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade300,
            ),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }
}
