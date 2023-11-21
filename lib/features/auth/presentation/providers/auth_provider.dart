import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recuerda_facil/models/models.dart';
import 'package:recuerda_facil/services/preferences_user.dart';

import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final firstInit = PreferencesUser();
  return AuthNotifier(
    authRepository: authRepository,
    firstInit: firstInit,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final PreferencesUser firstInit;
  // final KeyValueStorageService  keyValueStorageService;
  AuthNotifier({
    required this.authRepository,
    required this.firstInit,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    try {
      final user = await authRepository.login(email, password);
      if(user.firstSignIn == true){
        firstSignIn();}
        else{
          _setLoggedUser(user);
        }
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout("Error desconocido $e");
    }
  }

  Future<void> loginUserWithGoogle() async {
    try {
      final user = await authRepository.loginWithGoogle();
      if(user.firstSignIn == true){
        firstSignIn();}
        else{
          _setLoggedUser(user);
        }
    
    } catch (e) {
      logout("Fallido, intentar de nuevo");
    }

  }
  void defaultCreateUser()async{
    final user = await authRepository.createUserDefault();
    _setLoggedUser(user);
  }
  void createUser(UserAccount user)async{
    final userS = await authRepository.createUser(user);
    _setLoggedUser(userS);
  }

  void registerUser(String email, String password) async {}

  void checkAuthStatus() async {
    final firstInitValue = await firstInit.getValue<bool>('firstInit');
    if (firstInitValue == null) {
      return firstInitApp();
    } else {
      try {
        final user = await authRepository.checkAuthStatus();
        _setLoggedUser(user);
      } catch (e) {
        logout("Error al iniciar sesión");
      }
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
  Future<void> firstSignIn() async {

    state = state.copyWith(authStatus: AuthStatus.firstSignIn);
  }
  

  Future<void> firstInitApp() async {
    await firstInit.setValue<bool>('firstInit', true);
    state = state.copyWith(authStatus: AuthStatus.firstInit);
  }

  Future<void> endFirstInitApp() async {
    await FirebaseFirestore.instance.terminate();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    state = state.copyWith(authStatus: AuthStatus.notAuthenticated);
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated, firstInit,firstSignIn }

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
