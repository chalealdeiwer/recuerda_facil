import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/config/notes/app_notes.dart';
import 'package:recuerda_facil/services/note_service.dart';

import '../../models/note.dart';

final noteNotifierProvider = StateNotifierProvider<AppNoteNotifier,AppNotes>((ref) => AppNoteNotifier());


class AppNotesState{

  final bool isPosting;
  AppNotesState({this.isPosting=false});

  
}

class AppNoteNotifier extends StateNotifier<AppNotes> {

  //State= estado = new appTheme
  AppNoteNotifier() : super(AppNotes());
  onPosting(){
    state = AppNotes();

  }

}




final remindersProvider = FutureProvider.family.autoDispose<List<Note>, String>((ref, userId) async {
  final notesService = ref.read(notesServiceProvider);
  return await notesService.getRemindersOfUser(userId);
});

