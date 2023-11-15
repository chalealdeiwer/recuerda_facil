import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../presentations/providers/providers.dart';

class CreateUserScreen extends ConsumerStatefulWidget {
  static const name = "create_user_screen";

  const CreateUserScreen({super.key});

  @override
  ConsumerState<CreateUserScreen> createState() => CreateUserScreenState();
}

class CreateUserScreenState extends ConsumerState<CreateUserScreen> {
  late String email, password;
  final _formkey = GlobalKey<FormState>();
  String error = '';
  @override
  Widget build(BuildContext context) {
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
                  child: formulario(),
                ),
              ],
            ),
            buttonCreate(),
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

  Widget formulario() {
    return Form(
        key: _formkey,
        child: Column(
          children: [
            buildEmail(),
            const Padding(padding: EdgeInsets.only(top: 12)),
            buildPassword()
          ],
        ));
  }

  Widget buildEmail() {
    return TextFormField(
      style: const TextStyle(fontSize: 30),
      decoration: InputDecoration(
          labelText: "Correo",
          labelStyle: const TextStyle(fontSize: 25),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black))),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
      onSaved: (String? value) {
        email = value!;
      },
    );
  }

  Widget buildPassword() {
    return TextFormField(
      style: const TextStyle(fontSize: 30),
      decoration: InputDecoration(
          labelText: "Contraseña",
          labelStyle: const TextStyle(fontSize: 25),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black))),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
      onSaved: (String? value) {
        password = value!;
      },
    );
  }

  Widget buttonCreate() {
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: FilledButton(
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              _formkey.currentState!.save();
              UserCredential? credenciales = await crear(email, password);
              if (credenciales != null) {
                await credenciales.user!.sendEmailVerification();
                await FirebaseAuth.instance.signOut().then((value) => {
                context.pop()
                });
              }
            } else {
              error = "No se ha creado la cuenta, formato no válido";
            }
          },
          child: const Text(
            "Crear",
            style: TextStyle(fontSize: 25),
          )),
    );
  }

  Future<UserCredential?> crear(String email, String passwd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          error = "El correo ya se encuentra en uso";
        });
      } else {
        if (e.code == 'weak-password') {
          setState(() {
            error = "Contraseña débil";
          });
        }
      }
    }
    return null;
  }

  Widget privacy() {
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
}
