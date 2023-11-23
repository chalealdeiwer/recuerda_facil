import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/presentations/providers/appearance_provider2.dart';

class UsersGuideScreen extends ConsumerStatefulWidget {
  static const String name = '/users_guide';
  const UsersGuideScreen({super.key});

  @override
  ConsumerState<UsersGuideScreen> createState() => _UsersGuideScreenState();
}

class _UsersGuideScreenState extends ConsumerState<UsersGuideScreen> {
  @override
  Widget build(BuildContext context) {
    final preferencesNotifier = ref.watch(preferencesProvider.notifier);
    final preferences = ref.watch(preferencesProvider);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Aquí va ir la guía de usuario no se como hacer gifts'),
            SwitchListTile(
              value: preferences.isDarkMode,
              onChanged: (value) => preferencesNotifier.changeIsDarkMode(value),
              title: const Text('Modo oscuro'),
            ),
          ],
        ),
      ),
    );
  }
}
