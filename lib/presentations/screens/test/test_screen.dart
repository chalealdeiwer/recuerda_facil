import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/config/notes/app_notes.dart';
import 'package:recuerda_facil/presentations/providers/list_notes_provider.dart';
import 'package:recuerda_facil/presentations/providers/notes_provider2.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('TestScreen'),
      ),
      body: notesAsyncValue.when(
        data: (notes) => ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return ListTile(
              title: Text(note['title']),
              subtitle: Text(note['content']),
              // Agrega más campos según sea necesario
            );
          },
        ),
        loading: () => CircularProgressIndicator(),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
