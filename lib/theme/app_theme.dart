import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
        inputDecorationTheme: _input,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
        inputDecorationTheme: _input,
      );

  static const InputDecorationTheme _input = InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
  );
}

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.surface.withOpacity(0.55),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: child,
        ),
      ),
    );
  }
}
