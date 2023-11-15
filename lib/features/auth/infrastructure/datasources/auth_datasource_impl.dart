import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recuerda_facil/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:recuerda_facil/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../domain/domain.dart';

class AuthDataSourceImpl extends AuthDataSource {
  // final userNull = UserAccount(displayName: "No has iniciado sesión");
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
      // print("el usuario ya esta en la base de datos y se recupero por checking");

      return user;
    } catch (e) {
      throw Exception();
    }

    //revisar status en firebase
    // try {
    //   final response = await dio.get('/auth/check-status',
    //       options: Options(headers: {'Authorization': 'Bearer $token'}));
    //   final user = UserMapper.userJsonToEntity(response.data);
    //   return user;
    // } on DioError catch (e) {
    //   if (e.response?.statusCode == 401) {
    //     throw CustomError('token no es válido');
    //   }
    //   if (e.type == DioErrorType.connectionTimeout) {
    //     throw CustomError('Revisar conexión a internet');
    //   }

    //   throw Exception();
    // } catch (e) {
    //   throw Exception();
    // }
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
          // Si el documento del usuario no existe, crear uno nuevo
          await userRef.set({
            'email': user.email,
            'displayName': user.displayName,
            'created': Timestamp.now(),
            "emailVerified": user.emailVerified,
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
            "photoURL": user.photoURL,
            "private": false,
            "uid": user.uid
          });

          // print("usuario añadido a la base de datos por login normal");
        } else {
          try {
            final QuerySnapshot<Map<String, dynamic>> userDoc = await db
                .collection("users")
                .where("uid", isEqualTo: credential.user!.uid)
                .get();
            final user = UserAccount.fromMap(userDoc.docs.first.data());
            // print("el usuario ya estaba en la base de datos por el login normal ");

            return user;
          } catch (e) {
            // print("Error al obtener los datos del usuario: $e");
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
    //login en firebase

    //   try {
    //     final response = await dio
    //         .post('/auth/login', data: {'email': email, 'password': password});

    //     final user = UserMapper.userJsonToEntity(response.data);
    //     return user;
    //   } on DioError catch (e) {
    //     if (e.response?.statusCode == 401) {
    //       throw CustomError(
    //           e.response?.data['message'] ?? 'Credenciales incorrectas');
    //     }
    //     if (e.type == DioErrorType.connectionTimeout) {
    //       throw CustomError('Revisar conexión a internet');
    //     }

    //     throw Exception();
    //   } catch (e) {
    //     throw Exception();
    //   }
    throw Exception();
  }

  @override
  Future<UserAccount> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return throw CustomError("Ingreso de sesión cancelado");
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final access = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final credential = await firebaseAuth.signInWithCredential(access);
      if (credential.user == null) return throw Exception();
      if (credential.user != null) {
        final user = firebaseAuth.currentUser;
        final db = FirebaseFirestore.instance;
        final userRef = db.collection('users').doc(user!.uid);
        // Verificar si el documento del usuario ya existe
        final doc = await userRef.get();
        if (!doc.exists) {
          // Si el documento del usuario no existe, crear uno nuevo
          await userRef.set({
            'email': user.email,
            'displayName': user.displayName,
            'created': Timestamp.now(),
            "emailVerified": user.emailVerified,
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
            "photoURL": user.photoURL,
            "private": false,
            "uid": user.uid
          });

          // print("usuario añadido a la base de datos");
        } else {
          try {
            final QuerySnapshot<Map<String, dynamic>> userDoc = await db
                .collection("users")
                .where("uid", isEqualTo: credential.user!.uid)
                .get();
            final user = UserAccount.fromMap(userDoc.docs.first.data());
            // print("el usuario ya esta en la base de datos");

            return user;
          } catch (e) {
            // print("Error al obtener los datos del usuario: $e");
            throw CustomError("Error por aquí $e");
          }
        }
      }
    } catch (e) {
      throw CustomError("Inicio de sesión cancelado");
    }
    throw CustomError("Error desconocido con google");
  }

  @override
  Future<UserAccount> register(String email, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
