import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../presentations/providers/providers.dart';
import '../../../../../services/services.dart';
import '../../../shared/widgets/custom_text_form_field.dart';
import '../../providers/providers_auth.dart';

class CreateUserScreen extends ConsumerStatefulWidget {
  static const name = "create_user_screen";

  const CreateUserScreen({super.key});

  @override
  ConsumerState<CreateUserScreen> createState() => CreateUserScreenState();
}

class CreateUserScreenState extends ConsumerState<CreateUserScreen> {
  String error = '';
  @override
  Widget build(BuildContext context) {
    final loginForm = ref.watch(loginFormProvider);

    final colors = Theme.of(context).colorScheme;
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
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
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Creación de Usuario",
                      style: TextStyle(
                        fontFamily: 'SpicyRice-Regular',
                        fontSize: 28,
                      )),
                ),
                Offstage(
                  offstage: error == '',
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: formulario(ref, loginForm),
                ),
              ],
            ),
            buttonCreate(ref,loginForm),
            const SizedBox(
              height: 10,
            ),
            privacy(),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

 Widget buttonCreate(WidgetRef ref, loginForm) {
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: FilledButton(
          onPressed: loginForm.isPosting
              ? null
              : () {
                  ref.read(loginFormProvider.notifier).onFormCreateUser();
                },
          child: const Text(
            "Crear Cuenta",
            style: TextStyle(fontSize: 25),
          )),
    );
  }
  // Widget buttonCreate() {
  //   return FractionallySizedBox(
  //     widthFactor: 0.6,
  //     child: FilledButton(
  //         onPressed: () async {
  //           if (_formkey.currentState!.validate()) {
  //             _formkey.currentState!.save();
  //             UserCredential? credenciales = await crear(email, password);
  //             if (credenciales != null) {
  //               await credenciales.user!.sendEmailVerification();
  //               await FirebaseAuth.instance.signOut().then((value) => {
  //               context.pop()
  //               });
  //             }
  //           } else {
  //             error = "No se ha creado la cuenta, formato no válido";
  //           }
  //         },
  //         child: const Text(
  //           "Crear",
  //           style: TextStyle(fontSize: 25),
  //         )),
  //   );
  // }

  // Future<UserCredential?> crear(String email, String passwd) async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(email: email, password: password);
  //     return userCredential;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'email-already-in-use') {
  //       setState(() {
  //         error = "El correo ya se encuentra en uso";
  //       });
  //     } else {
  //       if (e.code == 'weak-password') {
  //         setState(() {
  //           error = "Contraseña débil";
  //         });
  //       }
  //     }
  //   }
  //   return null;
  // }
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
      label: 'Usa tu correo',
      keyboardType: TextInputType.emailAddress,
      onChanged: ref.read(loginFormProvider.notifier).onEmailChange,
      errorMessage:
          loginForm.isFormPosted ? loginForm.email.errorMessage : null,
    );
  }

  Widget buildPassword(WidgetRef ref, loginForm) {
    return CustomTextFormField(
        label: 'Crea una contraseña',
        obscureText: false,
        onChanged: ref.read(loginFormProvider.notifier).onPasswordChange,
        onFieldSubmitted: (_) {
          ref.read(loginFormProvider.notifier).onFormSubmit();
        },
        errorMessage:
            loginForm.isFormPosted ? loginForm.password.errorMessage : null);
  }
}

  Widget privacy() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          "Al registrarte aceptas nuestros ",
          style: TextStyle(fontSize: 18),
        ),
        TextButton(onPressed: (){
          launchUrlService("https://recuerdafaciltu.deiwerchaleal.com/");
        }, child: const Text("Términos de uso",style: TextStyle(fontSize: 18, color: Colors.blue, decoration: TextDecoration.underline, decorationColor: Colors.blue))),
        const Text("y"),
        TextButton(
            onPressed: () {
          launchUrlService("https://recuerdafacilpp.deiwerchaleal.com/");
              
            },
            child: const Text(
              "Política de Privacidad",
              style: TextStyle(fontSize: 18, color: Colors.blue, decoration: TextDecoration.underline, decorationColor: Colors.blue),
            ))
      ],
    );
  }
