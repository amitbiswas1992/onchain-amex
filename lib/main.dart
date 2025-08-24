import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/resources/app_strings.dart';
import 'core/services/secured_storage_service.dart';
import 'core/themes/app_themes.dart';
import 'infrastructure/di/get_it_service.dart';
import 'infrastructure/error/app_error_handler.dart';
import 'infrastructure/navigation/app_nav.dart';
import 'modules/home/presentation/providers/home_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();

  /// Handle errors
  final errorHandler = AppErrorHandler();
  errorHandler.handleAllErrorsGlobally();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final savedThemeMode = await getIt<SecuredStorageService>().getThemeMode();

  runApp(
    ProviderScope(
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final ThemeMode savedThemeMode;

  const MyApp({super.key, required this.savedThemeMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

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
  }
}
