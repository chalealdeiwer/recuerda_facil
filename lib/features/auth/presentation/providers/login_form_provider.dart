import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import '../../shared/inputs/inputs.dart';
import 'providers_auth.dart';

//! 3- stateNotifierProvider - consume afuera

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  final loginUserWithGoogleCallback=ref.watch(authProvider.notifier).loginUserWithGoogle;
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;
  return LoginFormNotifier(loginUserCallback: loginUserCallback,loginUserWithGoogleCallback: loginUserWithGoogleCallback,registerUserCallback: registerUserCallback);
});

//! 1-state de este provider

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure()});

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return '''
LoginFormState:
isPosting: $isPosting,
isFormPosted: $isFormPosted,
isValid: $isValid,
email: $email,
password: $password
''';
  }
}

//! 2- como implementamos un notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function() loginUserWithGoogleCallback;
  
  final Function(String, String) loginUserCallback;
  final Function(String, String) registerUserCallback;
  LoginFormNotifier({required this.loginUserCallback,required this.loginUserWithGoogleCallback,required this.registerUserCallback})
      : super(LoginFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email]),
    );
  }
  onFormCreateUser() async {
    _touchEveryField();
    if (!state.isValid) return;
    state=state.copyWith(isPosting: true);
    await registerUserCallback(state.email.value, state.password.value);
    state=state.copyWith(isPosting: false);
  }

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;
    state=state.copyWith(isPosting: true);
    await loginUserCallback(state.email.value, state.password.value);
    state=state.copyWith(isPosting: false);
  }
  signInGoogle()async{
    state=state.copyWith(isPosting: true);
    await loginUserWithGoogleCallback();
    state=state.copyWith(isPosting: false);
    }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email, password]),
    );
  }
}
