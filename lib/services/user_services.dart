import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recuerda_facil/models/note.dart';
import 'package:recuerda_facil/models/user.dart';
import 'package:recuerda_facil/models/user_account.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<UserAccount>> getUsers() async {
  List<UserAccount> users = [];
  QuerySnapshot queryusers = await db.collection("users").get();

  queryusers.docs.forEach((element) {
    final Map<String, dynamic> data = element.data() as Map<String, dynamic>;
    final UserAccount user = UserAccount.fromMap(data);
    users.add(user);
  });
  return users;
}

Future<void> addUserCategory(String uid, String newCategory) async {
  final DocumentReference userDocRef = db.collection("users").doc(uid);
  final DocumentSnapshot userDocSnapshot = await userDocRef.get();

  if (userDocSnapshot.exists) {
    final Map<String, dynamic> data =
        userDocSnapshot.data() as Map<String, dynamic>;
    List<dynamic> arrayCategories = data['categories'] ?? [];
    arrayCategories.add(newCategory);
    await userDocRef.update({"categories": arrayCategories});
  } else {
    print('User document not found');
  }
}

Future<void> removeUserCategory(String uid, String categoryToRemove) async {
  final DocumentReference userDocRef = db.collection("users").doc(uid);
  final DocumentSnapshot userDocSnapshot = await userDocRef.get();

  if (userDocSnapshot.exists) {
    final Map<String, dynamic> data =
        userDocSnapshot.data() as Map<String, dynamic>;
    List<dynamic> arrayCategories = data['categories'] ?? [];
    // Eliminar la categoría especificada de la lista
    arrayCategories.remove(categoryToRemove);
    // Actualizar la lista de categorías en la base de datos
    await userDocRef.update({"categories": arrayCategories});

    // Obtener todas las notas que pertenecen a la categoría que se va a eliminar
    final QuerySnapshot noteSnapshot = await db
        .collection("notes")
        .where("category", isEqualTo: categoryToRemove)
        .get();

    List<Future<void>> updateOperations = [];

    for (DocumentSnapshot noteDoc in noteSnapshot.docs) {
      DocumentReference noteRef = db.collection("notes").doc(noteDoc.id);
      updateOperations.add(noteRef.update({"category": ""}));
    }

    await Future.wait(updateOperations);
  } else {
    print('User document not found');
  }
}

// Future<UserAccount?> getUser(String uid) async {
//  await Future.delayed(Duration(seconds: 2));
//   try {
//   final QuerySnapshot<Map<String,  dynamic>> userDoc = await db
//         .collection("users")
//         .where("uid", isEqualTo: uid)
//         .get();
//      final user= UserAccount.fromMap(userDoc.docs.first.data());
//         return user;
//   } catch (e) {
//     print("Error al obtener los datos del usuario: $e");
//     return null;
//   }
// }
Stream<UserAccount?> getUserStream(String uid) {
  return db.collection("users").doc(uid).snapshots().map((snapshot) {
    if (snapshot.exists) {
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return UserAccount.fromMap(data);
    }
    return null;
  });
}

// Future<List<Note>> getRemindersOfUser(String userId) async {
//   // Obtener todas las notas que contienen al usuario especificado
//   QuerySnapshot queryNotes =
//       await db.collection("notes").where("user", arrayContains: userId).get();

//   List<Note> reminders = [];

//   // Iterar sobre cada nota
//   for (var noteDoc in queryNotes.docs) {
//     // Crear un objeto Note usando el método fromJson
//     final note =
//         Note.fromJson(noteDoc.data() as Map<String, dynamic>, noteDoc.id);

//     // (Opcional) Puedes añadir una condición para filtrar las notas basadas en una propiedad específica, como date_remember
    
//       reminders.add(note);
    
//   }

//   return reminders;
// }

// Future<List<String>> getUserCategories(String uid) async {

//   if(uid.isEmpty){
//     return ['Sin Categoría'];
//   }
//   // Inicializar con la categoría predeterminada
//   List<String> categories = ['Sin Categoría'];
//   // Intentar obtener las categorías del usuario de Firestore
//   try {
//     final QuerySnapshot querySnapshot = await db
//         .collection('users')
//         .where('uid', isEqualTo: uid)
//         .get();

//     // Verificar si se obtuvieron documentos
//     if (querySnapshot.docs.isNotEmpty) {
//       querySnapshot.docs.forEach((element) {
//         final Map<String, dynamic> data = element.data() as Map<String, dynamic>;

//         // Verificar si las categorías están presentes y no son nulas
//         if (data.containsKey('categories') && data['categories'] != null) {
//           final userCategories = data['categories'] as List<dynamic>;

//           // Asegurarse de que la lista de categorías no esté vacía
//           if (userCategories.isNotEmpty) {
//             categories.addAll(userCategories.cast<String>());
//           }
//         }
//       });
//     }
//   } catch (e) {
//     print('Error obteniendo categorías: $e');
//     // Opcionalmente, manejar el error según sea necesario
//   }

//   return categories;
// }
//funcionando

// Future<void> addUser(String displayName,String email, bool emailVerified, String uid, String photoURL)async{
//   await db.collection("users").add(
//     {"displayName": displayName,
//     "email":email,
//     "emailVerified":emailVerified,
//     "uid":uid,
//     "categories":['Salud','Medicamentos','Trabajo','Cumpleaños','Aniversarios','Personal'],
//     "photoURL":photoURL,
//     "created":Timestamp.now(),
//     "private":true
//     }
//     );

// }

Future<bool> getPrivate(String uid) async {
  try {
    final QuerySnapshot userDoc = await db
        .collection("users")
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();
    if (userDoc.docs.isNotEmpty) {
      final Map<String, dynamic> data =
          userDoc.docs.first.data() as Map<String, dynamic>;
      final bool private = data['private'] as bool;
      return private;
    } else {
      return false;
    }
  } catch (e) {
    print("Error al obtener los datos del usuario: $e");
    return false;
  }
}

Future<bool> searchUserUid(String uid) async {
  try {
    final QuerySnapshot querySnapshot = await db
        .collection('users')
        .where('uid', isEqualTo: uid)
        .limit(1)
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


