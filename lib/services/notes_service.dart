import 'package:firebase_auth/firebase_auth.dart';
import 'package:recuerda_facil/models/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getNotes(String user) async {
  List notes = [];
  QuerySnapshot querynotes = await db.collection("notes").where("user", arrayContains: user).get();
  querynotes.docs.forEach((element) {
    final Map<String, dynamic> data=element.data() as Map<String,dynamic>;
      final Timestamp timestamp = data['date_create'] as Timestamp;
      final date = timestamp.toDate();
    final note ={
      "title": data['title'],
      "content":data['content'],
      "user":data['user'],
      "key":element.id,
      "date_create":date
      

    };
    notes.add(note); });
  return notes;
}
//funcionando

Future<void> addNote(String title,String content, String user, DateTime date_create)async{
  await db.collection("notes").add({"title": title,"content":content,"user":{user},"date_create":date_create});

}

Future<void> addUserNote(String user)async {
  QuerySnapshot querynotes = await db.collection("notes").where("user", arrayContains: user).get();
  querynotes.docs.forEach((element) async{
    final Map<String, dynamic> data=element.data() as Map<String,dynamic>;
    List<dynamic> arrayUsuarios =data['user'] ?? [];
    arrayUsuarios.add(FirebaseAuth.instance.currentUser!.uid);
    await db.collection("notes").doc(element.id).update({"user":arrayUsuarios});
  });
  
}

//actualizar en la base de datos
Future<void> updateNote(String uid,String newnote, String newcontent) async{
await db.collection("notes").doc(uid).set({"title": newnote, "content":newcontent});
}

Future<void> deleteNote(String uid) async{
  await db.collection("notes").doc(uid).delete();
  print("nota borrada");
}


