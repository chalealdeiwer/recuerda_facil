import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final miStreamProvider = StreamProvider.autoDispose<List>((ref) {
  final container = ProviderContainer();
  ref.onDispose(() {
    container.dispose();
  });

  return container.read(getNotesStreamProvider(FirebaseAuth.instance.currentUser!.uid.toString(), "Sin Categoría"));
});

Provider<Stream<List>> getNotesStreamProvider(String user, String category) {
  return Provider<Stream<List>>((ref) {
    final StreamController<List> controller = StreamController<List>();
    var db = FirebaseFirestore.instance;

    var subscription = db.collection("notes")
      .where("user", arrayContains: user)
      .where("category", isEqualTo: category)
      .orderBy("date_create", descending: true)
      .snapshots()
      .listen((querySnapshot) {
        List notes = [];
        querySnapshot.docs.forEach((element) {
          final data = element.data() as Map<String, dynamic>;
          final Timestamp timestamp = data['date_create'];
          final Timestamp timestamp2 = data['date_finish'];
          final datec = timestamp.toDate();
          final datef= timestamp2.toDate();
          final note = {
            "title": data['title'],
            "content": data['content'],
            "user": data['user'],
            "key": element.id,
            "date_create": datec,
            "date_finish": datef,
            "state": data['state'],
            "category": data['category']
          };
          notes.add(note);
        });
        controller.add(notes);
      });

    ref.onDispose(() {
      subscription.cancel();
      controller.close();
    });

    return controller.stream;
  });
}