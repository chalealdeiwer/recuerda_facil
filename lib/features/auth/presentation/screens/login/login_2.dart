import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:go_router/go_router.dart';
import '../../../../../presentations/providers/providers.dart';
import '../../../shared/widgets/custom_text_form_field.dart';
import '../../providers/providers_auth.dart';

class Login2Screen extends StatelessWidget {
  static const name = "login_screen";
  const Login2Screen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const _LoginForm();
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();
  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context, ref) {
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final colors = Theme.of(context).colorScheme;
    final loginForm = ref.watch(loginFormProvider);
    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage!.isEmpty) return;
      showSnackbar(context, next.errorMessage!);
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Bienvenido a:",
                      style: TextStyle(
                        fontFamily: 'SpicyRice-Regular',
                        fontSize: 25,
                      )),
                )),
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recuerda",
                            style: TextStyle(
                                fontFamily: 'SpicyRice-Regular',
                                fontSize: 65,
                                color: colors.primary),
                          ),
                          Text(
                            "Fácil",
                            style: TextStyle(
                                fontFamily: 'SpicyRice-Regular',
                                fontSize: 60,
                                color: colors.secondary),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 90,
                        width: 90,
                        child: Image.asset(
                          isDarkMode
                              ? "assets/circleLogoWhite.png"
                              : "assets/circleLogo.png",
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  )),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Iniciar Sesión",
                        style: TextStyle(
                          fontFamily: 'SpicyRice-Regular',
                          fontSize: 28,
                        )))),
            Padding(
              padding: const EdgeInsets.all(8),
              child: formulario(ref, loginForm),
            ),
            buttonLogin(ref, loginForm),
            buildOrLine(),
            buttonGoogle(ref),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(),
            ),
            newUser(context),
            privacy(context),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonLogin(WidgetRef ref, loginForm) {
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: FilledButton(

          // UserCredential? credenciales = await login(email, password);
          // if (credenciales != null) {
          //   if (credenciales.user != null) {
          //     if (credenciales.user!.emailVerified) {
          //       Navigator.pushAndRemoveUntil(
          //           context,
          //           MaterialPageRoute(builder: (context) => HomeScreen()),
          //           (route) => false);
          //     } else {
          //       setState(() {
          //         error = "Debes verificar tu correo antes de acceder";
          //       });
          //     }
          // }
          // }
          onPressed: loginForm.isPosting
              ? null
              : () {
                  ref.read(loginFormProvider.notifier).onFormSubmit();
                },
          child: const Text(
            "Ingresar",
            style: TextStyle(fontSize: 25),
          )),
    );
  }

  Widget privacy(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          "Al registrarte aceptas el Tratamiento de Datos y ",
          style: TextStyle(fontSize: 18),
        ),
        TextButton(
            onPressed: () {
              context.push('/privacy');
            },
            child: const Text(
              "Política de Privacidad",
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ))
      ],
    );
  }

  Widget newUser(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          "¿Nuevo Aquí?",
          style: TextStyle(fontSize: 25),
        ),
        TextButton(
            onPressed: () {
              context.push('/createUser');
            },
            child: const Text(
              "Regístrate",
              style: TextStyle(fontSize: 25),
            ))
      ],
    );
  }

  Widget buildOrLine() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: Divider()),
          Text(
            "  ó  ",
            style: TextStyle(fontSize: 30),
          ),
          Expanded(child: Divider())
        ],
      ),
    );
  }

  Widget buttonGoogle(WidgetRef ref) {
    return Column(
      children: [
        SignInButton(
            padding: const EdgeInsets.only(left: 40),
            // mini: true,
            text: "Entrar con Google",
            Buttons.Google, onPressed: () async {
          ref.read(loginFormProvider.notifier).signInGoogle();
          // ref.read(userProvider.notifier).signInWithGoogle();

          // if (user!= null) {
          //   if( await searchUserUid(user.uid)){
          //     print("el usuario ya esta ene la base de datos");

          //   }else{
          //     print("el usuario se esta agregando a la base de datos");
          //         addUser(user.displayName.toString(), user.email.toString(),user.emailVerified, user.uid,user.photoURL.toString());
          //       // Navigator.pushAndRemoveUntil(
          //       // context,
          //       // MaterialPageRoute(builder: (context) => HomeScreen()),
          //       // (Route<dynamic> route) => false);

          //   }

          // }
        })
      ],
    );
  }

  Widget formulario(WidgetRef ref, loginForm) {
    return Form(
        child: Column(
      children: [
        buildEmail(ref, loginForm),
        const Padding(padding: EdgeInsets.only(top: 12)),
        buildPassword(ref, loginForm)
      ],
    ));
  }

  Widget buildEmail(WidgetRef ref, loginForm) {
    return CustomTextFormField(
      label: 'Correo',
      keyboardType: TextInputType.emailAddress,
      onChanged: ref.read(loginFormProvider.notifier).onEmailChange,
      errorMessage:
          loginForm.isFormPosted ? loginForm.email.errorMessage : null,
    );
  }

  Widget buildPassword(WidgetRef ref, loginForm) {
    return CustomTextFormField(
        label: 'Contraseña',
        obscureText: true,
        onChanged: ref.read(loginFormProvider.notifier).onPasswordChange,
        onFieldSubmitted: (_) {
          ref.read(loginFormProvider.notifier).onFormSubmit();
        },
        errorMessage:
            loginForm.isFormPosted ? loginForm.password.errorMessage : null);
  }
}
