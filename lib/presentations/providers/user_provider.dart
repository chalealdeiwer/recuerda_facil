// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:recuerda_facil/models/user.dart';

// final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
//   return UserNotifier();
// });

// class UserNotifier extends StateNotifier<User?> {
//   final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

//   UserNotifier() : super(null) {
//     _firebaseAuth.authStateChanges().listen((firebaseUser) async {
//       if (firebaseUser == null) {
//         state = null;
//       } else {
//         final user = _firebaseAuth.currentUser;
//         final db = FirebaseFirestore.instance;
//         final userRef = db.collection('users').doc(user!.uid);
//         // Verificar si el documento del usuario ya existe
//         final doc = await userRef.get();
//         state = User.fromFirebase(firebaseUser);

//         if (!doc.exists) {
//           // Si el documento del usuario no existe, crear uno nuevo
//           await userRef.set({
//             'email': user.email,
//             'displayName': user.displayName,
//             'created': Timestamp.now(),
//             "emailVerified": user.emailVerified,
//             "categories": [
//               'Todos',
//               'Sin Categoría',
//               'Salud',
//               'Medicamentos',
//               'Trabajo',
//               'Cumpleaños',
//               'Aniversarios',
//               'Personal'
//             ],
//             "usersCarer":[],  
//             "photoURL": user.photoURL,
//             "private": false,
//             "uid": user.uid
//           });
//           // print("usuario añadido a la base de datos");
//         } else {
//           // print("el usuario ya esta en la base de datos");
//         }
//       }
//     });
//   }

//   // Future<void> signInWithGoogle() async {
    
//   //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//   //     if (googleUser == null) return;

//   //     final GoogleSignInAuthentication googleAuth =
//   //         await googleUser.authentication;
//   //     final credential = auth.GoogleAuthProvider.credential(
//   //       accessToken: googleAuth.accessToken,
//   //       idToken: googleAuth.idToken,
//   //     );

//   //     await _firebaseAuth.signInWithCredential(credential);
      
//   //     // El estado se actualizará automáticamente a través del authStateChanges listener
    
//   // }

//   // Future<void> signInWithEmailPassword(String email, String password) async {
//   //   try {
//   //     await _firebaseAuth.signInWithEmailAndPassword(
//   //         email: email, password: password);
//   //     // El estado se actualizará automáticamente a través del authStateChanges listener
//   //   } catch (e) {
//   //     // Gestiona el error
//   //   }
//   // }

//   Future<void> signUpWithEmailPassword(String email, String password) async {
//     try {
//       await _firebaseAuth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       // Aquí puedes agregar un método para enviar un correo de verificación si es necesario
//     } catch (e) {
//       // Gestiona el error
//     }
//   }

//   // Future<void> signOut() async {
//   //   await _firebaseAuth.signOut();
//   //   // El estado se actualizará automáticamente a través del authStateChanges listener
//   // }
//   // Agregar otros métodos según sea necesario, como restablecer la contraseña, verificar el correo electrónico, etc.
// }
