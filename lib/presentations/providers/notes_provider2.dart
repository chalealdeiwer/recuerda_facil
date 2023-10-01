import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/config/notes/app_notes.dart';

final noteNotifierProvider = StateNotifierProvider<AppNoteNotifier,AppNotes>((ref) => AppNoteNotifier());


class AppNoteNotifier extends StateNotifier<AppNotes> {

  //State= estado = new appTheme
  AppNoteNotifier() : super(AppNotes());

}