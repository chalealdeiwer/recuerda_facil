// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// enum AuthStatus {
//   Uninitialized,
//   Authenticated,
//   Authenticating,
//   Unauthenticated,
// }

// class AuthService with ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   AuthStatus _status = AuthStatus.Uninitialized;
//   User _user;

//   AuthService().instance {
//     _auth.authStateChanges().listen(_onAuthStateChanged as void Function(User? event)?);
//   }

//   Future<void> _onAuthStateChanged(User firebaseUser) async {
//     if (firebaseUser == null) {
//       _status = AuthStatus.Unauthenticated;
//     } else {
//       final DocumentSnapshot userSnap = await _db
//           .collection('users')
//           .doc(firebaseUser.uid)
//           .get();

//       _user = User.fromMap(userSnap.data());
//       _status = AuthStatus.Authenticated;
//     }

//     notifyListeners();
//   }

//   Future<User> googleSignIn() async {
//     try {
//       _status = AuthStatus.Authenticating;
//       notifyListeners();

//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       final GoogleSignInAuthentication? googleAuth =
//           await googleUser?.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth!.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final UserCredential authResult =
//           await _auth.signInWithCredential(credential);
//       final User? user = authResult.user;

//       if (user != null) {
//         await updateUserData(user);
//         return user;
//       } else {
//         _status = AuthStatus.Unauthenticated;
//         notifyListeners();
//         return null;
//       }
//     } catch (e) {
//       _status = AuthStatus.Unauthenticated;
//       notifyListeners();
//       return null;
//     }
//   }

//   Future<void> updateUserData(User user) async {
//     final DocumentReference userRef = _db.collection('users').doc(user.uid);

//     await userRef.set({
//       'uid': user.uid,
//       'email': user.email,
//       'lastSign': FieldValue.serverTimestamp(),
//       'photoURL': user.photoURL,
//       'displayName': user.displayName,
//     }, SetOptions(merge: true));
//   }

//   Future<void> signOut() async {
//     await _auth.signOut();
//     _status = AuthStatus.Unauthenticated;
//     _user = null;
//     notifyListeners();
//   }

//   AuthStatus get status => _status;
//   User get user => _user;
// }