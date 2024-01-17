import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recuerda_facil/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:recuerda_facil/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../domain/domain.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
  @override
  Future<UserAccount> checkAuthStatus() async {
    final db = FirebaseFirestore.instance;
    try {
      final userActually = firebaseAuth.currentUser;
      if (userActually == null) return throw Exception();
      final QuerySnapshot<Map<String, dynamic>> userDoc = await db
          .collection("users")
          .where("uid", isEqualTo: userActually.uid)
          .get();
      final user = UserAccount.fromMap(userDoc.docs.first.data());
      print(
          "el usuario ya esta en la base de datos y se recupero por checking");
      return user;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<UserAccount> login(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user == null) return throw Exception();

      if (credential.user != null) {
        final user = firebaseAuth.currentUser;
        final db = FirebaseFirestore.instance;
        final userRef = db.collection('users').doc(user!.uid);
        // Verificar si el documento del usuario ya existe
        final doc = await userRef.get();
        if (!doc.exists) {
          if (credential.user!.emailVerified == false) {
            return UserAccount(firstSignIn: true, emailVerified: false);
          } else {
            return UserAccount(firstSignIn: true,emailVerified: true);
          }
        } else {
          try {
            final QuerySnapshot<Map<String, dynamic>> userDoc = await db
                .collection("users")
                .where("uid", isEqualTo: credential.user!.uid)
                .get();
            final user = UserAccount.fromMap(userDoc.docs.first.data());
            print(
                "el usuario ya estaba en la base de datos por el login normal ");

            return user;
          } catch (e) {
            print("Error al obtener los datos del usuario: $e");
            throw Exception();
          }
          // print("el usuario ya esta en la base de datos");
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw CustomError("Usuario No encontrado");
      }
      if (e.code == 'wrong-password') {
        throw CustomError("Contraseña Incorrecta");
      }
      if (e.code == 'user-disabled') {
        throw CustomError("Usuario deshabilitado");
      }
    } catch (e) {
      // Gestiona el error
    }
    throw CustomError("Inicio de sesión fallido, intenta otra vez");
  }

  @override
  Future<UserAccount> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final access = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final credential = await firebaseAuth.signInWithCredential(access);
      if (credential.user == null) {
        return throw CustomError("Error con la credencial");
      }
      if (credential.user != null) {
        final user = firebaseAuth.currentUser;
        final db = FirebaseFirestore.instance;
        final userRef = db.collection('users').doc(user!.uid);
        // Verificar si el documento del usuario ya existe
        final doc = await userRef.get();
        if (!doc.exists) {
          return UserAccount(firstSignIn: true);
        } else {
          final QuerySnapshot<Map<String, dynamic>> userDoc = await db
              .collection("users")
              .where("uid", isEqualTo: credential.user!.uid)
              .get();
          final user = UserAccount.fromMap(userDoc.docs.first.data());
          print(
              "el usuario ya esta en la base de datos por el login de google");

          return user;
        }
      }
    } catch (e) {
      throw CustomError("Inicio de sesión fallido, intenta otra vez");
    }
    throw CustomError("Inicio de sesión fallido, intenta otra vez");
  }

  @override
  Future<UserAccount> register(String email, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.sendEmailVerification();

      if (credential.user!.emailVerified == false) {
        return UserAccount(firstSignIn: true, emailVerified: false);
// return throw CustomError("Por favor verifica tu correo electrónico");
      }
      if (credential.user != null) {
        final user = firebaseAuth.currentUser;
        final db = FirebaseFirestore.instance;
        final userRef = db.collection('users').doc(user!.uid);
        // Verificar si el documento del usuario ya existe
        final doc = await userRef.get();
        if (!doc.exists) {
          return UserAccount(firstSignIn: true,emailVerified: true);
        } else {
          try {
            final QuerySnapshot<Map<String, dynamic>> userDoc = await db
                .collection("users")
                .where("uid", isEqualTo: credential.user!.uid)
                .get();
            final user = UserAccount.fromMap(userDoc.docs.first.data());
            print(
                "el usuario ya estaba en la base de datos por el login normal ");

            return user;
          } catch (e) {
            print("Error al obtener los datos del usuario: $e");
            throw Exception();
          }
          // print("el usuario ya esta en la base de datos");
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw CustomError("El correo ya se encuentra en uso");
      } else {
        if (e.code == 'weak-password') {
          throw CustomError("La contraseña es muy débil");
        }
      }
    } catch (e) {}
    //
    throw CustomError("Por favor verifica tu correo electrónico");
  }

  @override
  Future<UserAccount> createUserDefault() async {
    final user = firebaseAuth.currentUser;
    final db = FirebaseFirestore.instance;
    final userRef = db.collection('users').doc(user!.uid);

    await userRef.set({
      'email': user.email,
      'displayName': user.displayName,
      'created': Timestamp.now(),
      "emailVerified": user.emailVerified,
      "phoneNumber": user.phoneNumber,
      "categories": [
        'Todos',
        'Sin Categoría',
        'Salud',
        'Medicamentos',
        'Trabajo',
        'Cumpleaños',
        'Aniversarios',
        'Personal'
      ],
      "usersCarer": [],
      "chats": [],
      "photoURL": user.photoURL,
      "private": false,
      "uid": user.uid,
      "firstSignIn": false,
      "dateBirthday": Timestamp.fromDate(DateTime(1, 1, 1))
    });
    final QuerySnapshot<Map<String, dynamic>> userDoc =
        await db.collection("users").where("uid", isEqualTo: user.uid).get();
    final userR = UserAccount.fromMap(userDoc.docs.first.data());
    print("el usuario se creo por default y se retorno ");

    return userR;
  }

  @override
  Future<UserAccount> createUser(UserAccount user) async {
    final userF = firebaseAuth.currentUser;

    final db = FirebaseFirestore.instance;
    final userRef = db.collection('users').doc(userF!.uid);
    await userRef.set({
      'email': user.email,
      'displayName': user.displayName,
      'created': Timestamp.now(),
      "emailVerified": user.emailVerified,
      "phoneNumber": user.phoneNumber,
      "categories": user.categories,
      "usersCarer": user.usersCarer,
      "photoURL": user.photoURL,
      "private": user.private,
      "uid": user.uid,
      "firstSignIn": false,
      "dateBirthday": user.dateBirthday,
      "chats": user.chats
    });
    final QuerySnapshot<Map<String, dynamic>> userDoc =
        await db.collection("users").where("uid", isEqualTo: user.uid).get();
    final userR = UserAccount.fromMap(userDoc.docs.first.data());
    print("el usuario se creo con características y se retorno");

    return userR;
  }
}
