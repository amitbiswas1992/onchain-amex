import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/resources/app_strings.dart';
import 'core/themes/app_themes.dart';
import 'infrastructure/di/get_it_service.dart';
import 'infrastructure/error/app_error_handler.dart';
import 'infrastructure/navigation/app_nav.dart';

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

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      themeMode: ThemeMode.dark,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      routerConfig: AppNav.goRouter,
      scaffoldMessengerKey: AppNav.scaffoldMessengerKey,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.9),
          ),
          child: child!,
        );
      },
    );
  }
}
