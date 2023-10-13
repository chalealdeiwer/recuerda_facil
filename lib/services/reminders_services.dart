import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/models/note.dart';
import 'package:recuerda_facil/services/note_service.dart';

class NotesStateNotifier extends StateNotifier<List<Note>> {
  final NotesService _notesService;

  NotesStateNotifier(this._notesService) : super([]);

  Future<void> fetchNotes(String userId) async {
    final notes = await _notesService.getRemindersOfUser(userId);
    state = notes; 
  }

}