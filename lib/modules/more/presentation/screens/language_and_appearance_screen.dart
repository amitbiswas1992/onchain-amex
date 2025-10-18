import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/functions.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/theme_toogle_button.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../widgets/menu_section.dart';
import 'more_screen.dart';

class LanguageAndAppearanceScreen extends ConsumerWidget {
  const LanguageAndAppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: const PrimaryAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance section
          Container(
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: const Icon(
                Icons.brightness_6_rounded,
              ),
              title: const Text(
                "Appearance",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(isDarkMode ? "Dark mode" : "Light mode"),
              // trailing: Switch.adaptive(
              //   value: isDarkMode,
              //   onChanged: (value) {
              //     ref.read(themeModeProvider.notifier).state =
              //         value ? ThemeMode.dark : ThemeMode.light;
              //   },
              // ),
              trailing: ThemeToggleButton(
                isDarkMode: isLightTheme(context) == false,
                onToggle: () {
                  ref.read(themeModeProvider.notifier).state =
                  isLightTheme(context) ? ThemeMode.dark : ThemeMode.light;
                  ref
                      .read(securedStorageService)
                      .saveThemeMode(ref.read(themeModeProvider)!);
                },
              ),
            ),
          ),

          const DividerCustom(),

          // Language section
          Container(
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: const Icon(
                Icons.language_rounded,
              ),
              title: const Text(
                "Language",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text("English (Default)"),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
              ),
              onTap: () {
                // Optionally open a dialog or screen in the future
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Only English is supported right now")),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
