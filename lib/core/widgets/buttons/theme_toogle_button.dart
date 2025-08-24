import 'package:flutter/material.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggle;

  const ThemeToggleButton({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onToggle,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) {
          final offsetAnim = Tween<Offset>(
            begin: const Offset(0.0, 0.5), // slide up from bottom
            end: Offset.zero,
          ).animate(anim);

          return SlideTransition(
            position: offsetAnim,
            child: child,
          );
        },
        child: Icon(
          isDarkMode ? Icons.dark_mode : Icons.wb_sunny,
          key: ValueKey(isDarkMode),
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
