import 'package:recuerda_facil/models/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getUsers() async {
  List users = [];
  QuerySnapshot queryusers = await db.collection("users").get();
  queryusers.docs.forEach((element) {
    final Map<String, dynamic> data=element.data() as Map<String,dynamic>;
    final people ={
      "displayName": data['displayName'],
      "email":data['email'],
      "emailVerified":data['emailVerified'],
      "uid":element.id,
      "categories":data['categories']

    };
    users.add(people); });
  return users;
}

Future<Map<String, dynamic>?> getUser(String uid) async {
  try {
    final DocumentSnapshot userDoc = await db
        .collection("users")
        .doc(uid)
        .get();
      print(userDoc.data().toString());

    if (userDoc.exists) {
      print("el usuario existe");
      return userDoc.data() as Map<String, dynamic>;
    } else {
      print("el usuario no existe");
      return null; // El usuario no existe
    }
  } catch (e) {
    print("Error al obtener los datos del usuario: $e");
    return null;
  }
}
Future<List<String>> getUserCategories(String uid) async {
  List<String> categories = [];

  final QuerySnapshot querySnapshot = await db
      .collection('users')
      .where('uid', isEqualTo: uid)
      .get();

  querySnapshot.docs.forEach((element) {
    final Map<String, dynamic> data = element.data() as Map<String, dynamic>;
    final userCategories = data['categories'] as List<dynamic>;
    userCategories.toList();
    categories.addAll(userCategories.cast<String>());
    // Agregar las categorías del usuario a la lista
    
  });

  return categories;
}
//funcionando

Future<void> addUser(String displayName,String email, bool emailVerified, String uid)async{
  await db.collection("users").add({"displayName": displayName,"email":email,"emailVerified":emailVerified,"uid":uid,"categories":['Sin Categoría','Salud','Medicamentos','Trabajo','Cumpleaños','Aniversarios','Personal']});

}

Future<bool> searchUserUid(String uid) async {
  try {
    final QuerySnapshot querySnapshot = await db.collection('users').where('uid', isEqualTo: uid).limit(1) 
.get();
    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      // No se encontró un usuario con ese UID
      return false;
    }
  } catch (error) {
    // Maneja cualquier error que pueda ocurrir durante la consulta
    print('Error al buscar el usuario: $error');
    return false;
  }
}
//actualizar en la base de datos

//  Future<void> updateNote(String uid,String newnote, String newcontent) async{
//  await db.collection("notes").doc(uid).set({"title": newnote, "content":newcontent});
//  }

// Future<void> deleteNote(String uid) async{
//   await db.collection("notes").doc(uid).delete();
//   print("entra aqui??");
// }


