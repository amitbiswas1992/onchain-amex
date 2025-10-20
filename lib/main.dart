import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'borrower/home/presentation/providers/home_providers.dart';
import 'core/resources/app_strings.dart';
import 'core/themes/app_themes.dart';
import 'infrastructure/error/app_error_handler.dart';
import 'infrastructure/navigation/app_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Handle errors
  final errorHandler = AppErrorHandler();
  errorHandler.handleAllErrorsGlobally();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final asyncThemeMode = ref.watch(savedThemeModeProvider);

    return asyncThemeMode.when(
      data: (savedThemeMode) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: appTitle,
          themeMode: themeMode ?? savedThemeMode,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          routerConfig: AppNav.goRouter,
          scaffoldMessengerKey: AppNav.scaffoldMessengerKey,
          // builder: (context, child) {
          //   return MediaQuery(
          //     data: MediaQuery.of(context).copyWith(
          //       textScaler: const TextScaler.linear(1.9),
          //     ),
          //     child: child!,
          //   );
          // },
        );
      },
      error: (err, stack) => const SizedBox(),
      loading: () => const SizedBox(),
    );
  }
}
