import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recuerda_facil/models/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteProvider with ChangeNotifier{
  FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getNotes(String user) async {
  List notes = [];
  QuerySnapshot querynotes = await db.collection("notes").where("user", arrayContains: user).get();
  querynotes.docs.forEach((element) {
    final Map<String, dynamic> data=element.data() as Map<String,dynamic>;
      final Timestamp timestamp = data['date_create'];
      final date = timestamp.toDate();
    final note ={
      "title": data['title'],
      "content":data['content'],
      "user":data['user'],
      "key":element.id,
      "date_create":date

      
    };
    notes.add(note); });
    // notifyListeners();
  return notes;
  
}

Stream<int> getNotesLengthStream(String user) {
  final StreamController<int> controller = StreamController<int>();

  // Escucha los cambios en la lista de notas y emite la longitud
  db.collection("notes").where("user", arrayContains: user).snapshots().listen((querySnapshot) {

    final length = querySnapshot.docs.length;
    controller.add(length); // Emite la longitud de la lista de notas
  });

  return controller.stream;
}


Stream<List> getNotesStream(String user) {
  final StreamController<List> controller = StreamController<List>();

  // Configura la consulta Firestore con orderBy
  db.collection("notes")
    .where("user", arrayContains: user)
    .orderBy("date_create", descending: true) // Ordenar por date_create en orden descendente
    .snapshots()
    .listen((querySnapshot) {
      List notes = [];
      querySnapshot.docs.forEach((element) {
        final Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        final Timestamp timestamp = data['date_create'];
        final date = timestamp.toDate();
        final note = {
          "title": data['title'],
          "content": data['content'],
          "user": data['user'],
          "key": element.id,
          "date_create": date,
          "state":data['state'],
          "category":data['category']
        };
        notes.add(note);
      });

      controller.add(notes); // Agregar los datos al stream
    });
    print("notas cargadas");

  return controller.stream;
}
//funcionando



Future<void> addNote(String title, String content, String user, DateTime date_create, String state, String category, DateTime date_finish) async {
  try {
    await db.collection("notes").add({
      "title": title,
      "content": content,
      "user": {user},
      "date_create": date_create,
      "state": state,
      "category": category,
      "date_finish": date_finish,
    });
    print("Nota añadida con éxito");
  } catch (error) {
    print("Error al añadir nota: $error");
    throw error; // Lanza el error nuevamente para que pueda ser manejado por el código que llama a esta función
  }
}



Future<void> addUserNote(String user)async {
  QuerySnapshot querynotes = await db.collection("notes").where("user", arrayContains: user).get();
  querynotes.docs.forEach((element) async{
    final Map<String, dynamic> data=element.data() as Map<String,dynamic>;
    List<dynamic> arrayUsuarios =data['user'] ?? [];
    arrayUsuarios.add(FirebaseAuth.instance.currentUser!.uid);
    await db.collection("notes").doc(element.id).update({"user":arrayUsuarios});
  });
  notifyListeners();
  
}

//actualizar en la base de datos
Future<void> updateNote(String uid,String newnote, String newcontent,) async{
await db.collection("notes").doc(uid).update({"title": newnote, "content":newcontent});
notifyListeners();
}


Future<void> deleteNote(String uid) async {
  try {
    await db.collection("notes").doc(uid).delete();
    print("Nota eliminada con éxito");
  } catch (error) {
    print("Error al eliminar nota: $error");
    throw error; // Lanza el error nuevamente para que pueda ser manejado por el código que llama a esta función
  }
}

}



