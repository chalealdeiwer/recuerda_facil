import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recuerda_facil/models/models.dart';

import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  // final keyValueStorageService= KeyValueStorageServiceImpl();
  return AuthNotifier(
    authRepository: authRepository,
    // keyValueStorageService: keyValueStorageService
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  // final KeyValueStorageService  keyValueStorageService;
  AuthNotifier({
    required this.authRepository,
    // required this.keyValueStorageService
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout("Error desconocido $e");
    }
  }

  Future<void> loginUserWithGoogle() async {
    try {
      final user = await authRepository.loginWithGoogle();
      _setLoggedUser(user);
    } catch (e) {
      logout("Cancelado");
    }
  }

  void registerUser(String email, String password) async {}

  void checkAuthStatus() async {
    try {
      await authRepository.checkAuthStatus().then((user) {
        _setLoggedUser(user);
      });
    } catch (e) {
      logout("Error al iniciar sesión");
    }
  }

  void _setLoggedUser(UserAccount user) async {
    state = state.copyWith(
        authStatus: AuthStatus.authenticated, user: user, errorMessage: '');
  }

  Future<void> logout([String? errorMessage]) async {
    await FirebaseFirestore.instance.terminate();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    // await keyValueStorageService.removeKey('token');
    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final UserAccount? user;
  final String? errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith(
          {AuthStatus? authStatus, UserAccount? user, String? errorMessage}) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage);
}
