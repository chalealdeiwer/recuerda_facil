import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/models/note.dart';

final notesServiceProvider = Provider<NotesService>((ref) => NotesService());

class NotesService {
FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<Note>> getRemindersOfUser(String userId) async {
  // Obtener todas las notas que contienen al usuario especificado
  QuerySnapshot queryNotes =
      await db.collection("notes").where("user", arrayContains: userId).get();

  List<Note> reminders = [];

  // Iterar sobre cada nota
  for (var noteDoc in queryNotes.docs) {
    // Crear un objeto Note usando el método fromJson
    final note =
        Note.fromJson(noteDoc.data() as Map<String, dynamic>, noteDoc.id);

    // (Opcional) Puedes añadir una condición para filtrar las notas basadas en una propiedad específica, como date_remember
    
      reminders.add(note);
    
  }

  return reminders;
}
}