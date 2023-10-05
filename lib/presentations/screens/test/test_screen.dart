import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/config/notes/app_notes.dart';
import 'package:recuerda_facil/presentations/providers/list_notes_provider.dart';
import 'package:recuerda_facil/presentations/providers/notes_provider2.dart';

import '../screens.dart';

class TestScreen extends ConsumerStatefulWidget {
  static const name = 'test_screen';
  const TestScreen({super.key});

  @override
  ConsumerState<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen> {
  @override
  Widget build(BuildContext context) {
    final AppNotes appNotes = ref.watch(noteNotifierProvider);
    final notesAsyncValue = ref.watch(miStreamProvider);
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          title: const Text('TestScreen'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recuerda",
              style: TextStyle(
                  fontFamily: 'SpicyRice-Regular',
                  fontSize: 70,
                  color: colors.primary),
            ),
            Text(
              "Fácil",
              style: TextStyle(
                  fontFamily: 'SpicyRice-Regular',
                  fontSize: 70,
                  color: colors.secondary),
            ),
          ],
        )));
  }
}
