import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/services/note_service.dart';

import '../../models/note.dart';

final noteNotifierProvider =
    StateNotifierProvider<AppNoteNotifier, AppNotesState>(
        (ref) => AppNoteNotifier());

class AppNotesState {
  final bool isPosting;
  final bool isUpdating;
  AppNotesState({this.isPosting = false, this.isUpdating = false});

  AppNotesState copyWith({bool? isPosting, bool? isUpdating}) => AppNotesState(
      isPosting: isPosting ?? this.isPosting,
      isUpdating: isUpdating ?? this.isUpdating);
}

class AppNoteNotifier extends StateNotifier<AppNotesState> {
  //State= estado = new appTheme
  AppNoteNotifier() : super(AppNotesState());

  FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<int> getNotesLengthStream(String user) {
    final StreamController<int> controller = StreamController<int>();
    db
        .collection("notes")
        .where("user", arrayContains: user)
        .snapshots()
        .listen((querySnapshot) {
      final length = querySnapshot.docs.length;
      controller.add(length); // Emite la longitud de la lista de notas
    });

    return controller.stream;
  }

  Future<int> getNotesLengthFuture(String user) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("notes")
        .where("user",
            isEqualTo:
                user) // Cambiado de 'arrayContains' a 'isEqualTo' ya que estamos filtrando por un solo usuario
        .get();

    return querySnapshot.docs.length;
  }

  Stream<List<Note>> getNotesStream(String user, String category) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final StreamController<List<Note>> controller =
        StreamController<List<Note>>(); // Ajustado aquí

    Query query;
    if (category == "Todos") {
      query = db
          .collection("notes")
          .where("user", arrayContains: user)
          .orderBy("date_create", descending: true);
    } else if (category == "Sin Categoría") {
      query = db
          .collection("notes")
          .where("user", arrayContains: user)
          .where("category", isEqualTo: "")
          .orderBy("date_create", descending: true);
    } else {
      query = db
          .collection("notes")
          .where("user", arrayContains: user)
          .where("category", isEqualTo: category)
          .orderBy("date_create", descending: true);
    }

    query.snapshots().listen(
      (querySnapshot) {
        List<Note> notes = []; // Asegúrate de que sea List<Note>
        for (var element in querySnapshot.docs) {
          final note = Note.fromJson(
              element.data() as Map<String, dynamic>,
              element
                  .id); // Asegúrate de que el tipo de data sea Map<String, dynamic>
          notes.add(note);
        }
        controller.add(notes);
        // print("notas cargadas");  // Agrega la lista de notas al stream
      },
      onError: (error) {
        // Opcional: manejar errores
        // print('Error al obtener las notas: $error');
        controller.addError(error);
      },
    );

    // Opcional: cerrar el StreamController cuando ya no lo necesites
    // controller.close();

    return controller
        .stream; // Asegúrate de que el tipo de retorno sea Stream<List<Note>>
  }
//funcionando

  Future<void> addNote(
      String title,
      String content,
      String user,
      DateTime dateCreate,
      bool stateDone,
      String category,
      DateTime dateFinish,
      DateTime dateRemember,
      String icon) async {
    if (category == "Sin Categoría" || category == "Todos") {
      category = "";
    }
    try {
      state = state.copyWith(isPosting: true);

      await db.collection("notes").add({
        "title": title,
        "content": content,
        "user": {user},
        "date_create": dateCreate,
        "stateDone": stateDone,
        "category": category,
        "date_finish": dateFinish,
        "date_remember": dateRemember,
        "icon": icon,
      });
      state = state.copyWith(isPosting: false);
      // print("Nota añadida con éxito");
    } catch (error) {
      // print("Error al añadir nota: $error");
      throw Exception(); // Lanza el error nuevamente para que pueda ser manejado por el código que llama a esta función
    }
  }

  Future<void> addUserNote(String user) async {
    // Obtener la instancia actual de Firebase Auth y el usuario actual
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // print('No user is signed in.');
      return;
    }

    // Obtener el UID del usuario actual
    final currentUserId = currentUser.uid;

    // Obtener todas las notas que contienen al usuario especificado
    QuerySnapshot queryNotes =
        await db.collection("notes").where("user", arrayContains: user).get();

    // Iterar sobre cada nota
    for (var noteDoc in queryNotes.docs) {
      final Map<String, dynamic> noteData =
          noteDoc.data() as Map<String, dynamic>;
      List<dynamic> noteUsers = noteData['user'] ?? [];
      final noteCategory = noteData['category'];

      // Añadir el usuario actual a la lista de usuarios de la nota
      noteUsers.add(currentUserId);
      await db.collection("notes").doc(noteDoc.id).update({"user": noteUsers});

      // Verificar si el usuario actual ya tiene esta categoría
      final userDocRef = db.collection("users").doc(currentUserId);
      final userDoc = await userDocRef.get();
      if (userDoc.exists) {
        final Map<String, dynamic> userData =
            userDoc.data() as Map<String, dynamic>;
        List<dynamic> userCategories = userData['categories'] ?? [];

        // Si el usuario no tiene esta categoría y la categoría no es una cadena vacía, añadirla
        if (!userCategories.contains(noteCategory) && noteCategory != "") {
          userCategories.add(noteCategory);
          await userDocRef.update({"categories": userCategories});
        }
      } else {
        // print('User document not found');
      }
    }
  }

//actualizar en la base de datos
  Future<void> updateNote(
    String uid,
    String newNote,
    String newContent,
  ) async {
    try {
      state = state.copyWith(isUpdating: true);
      await db
          .collection("notes")
          .doc(uid)
          .update({"title": newNote, "content": newContent});
      state = state.copyWith(isUpdating: true);
    } catch (error) {
      throw Exception();
    }
  }

  Future<void> toggleNoteState(String uid, bool currentState) async {
    await db.collection("notes").doc(uid).update({"stateDone": !currentState});
  }

  Future<void> updateNoteDateFinish(String uid, DateTime dateFinish) async {
    await db.collection("notes").doc(uid).update({
      "date_finish": dateFinish,
    });
  }

  Future<void> deleteNote(String uid) async {
    try {
      await db.collection("notes").doc(uid).delete();
      // print("Nota eliminada con éxito");
    } catch (error) {
      // print("Error al eliminar nota: $error");
      rethrow; // Lanza el error nuevamente para que pueda ser manejado por el código que llama a esta función
    }
  }
}

final remindersProvider =
    FutureProvider.family.autoDispose<List<Note>, String>((ref, userId) async {
  final notesService = ref.read(notesServiceProvider);
  return await notesService.getRemindersOfUser(userId);
});
