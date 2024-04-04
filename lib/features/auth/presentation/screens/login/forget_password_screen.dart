import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const name = "forget_password_screen";

  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final emailForgot = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recuperar contraseña'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ingrese su correo electrónico para restablecer su contraseña',
                  style: style.titleLarge,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: emailForgot,
                  // Campo para ingresar el correo electrónico
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      const InputDecoration(labelText: 'Correo electrónico'),
                ),
                const SizedBox(height: 20.0),
                FilledButton(
                  onPressed: () async {
                    String email = emailForgot.text;
                    if (_isValidEmail(email)) {
                      // Enviar correo de restablecimiento
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email);
                        // Mostrar alerta de éxito
                        _showAlertDialog2(
                            'Correo enviado',
                            'Se ha enviado un correo de restablecimiento a $email.',
                            context);
                      } catch (e) {
                        String errorMessage =
                            'Ocurrió un error al enviar el correo de restablecimiento. Por favor inténtelo de nuevo.';
                        if (e is FirebaseAuthException) {
                          if (e.code == 'user-not-found') {
                            errorMessage =
                                'No se encontró un usuario con el correo $email.';
                            _showAlertDialog('Error', errorMessage, context);
                          }
                          if (e.code == 'too-many-requests') {
                            errorMessage =
                                'Demasiados intentos. Por favor intente más tarde.';
                            _showAlertDialog('Error', errorMessage, context);
                          }
                        } else {
                          _showAlertDialog(
                              'Error',
                              'Ocurrió un error al enviar el correo de restablecimiento. Por favor inténtelo de nuevo.',
                              context);
                        }
                      }
                    } else {
                      // Mostrar alerta de correo electrónico inválido
                      _showAlertDialog(
                          'Correo inválido',
                          'Por favor ingrese un correo electrónico válido.',
                          context);
                    }
                  },
                  child: const Text('Enviar correo de restablecimiento'),
                ),
              ],
            ),
          ),
        ));
  }

  bool _isValidEmail(String email) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  void _showAlertDialog(String title, String content, BuildContext context) {
    final style=Theme.of(context).textTheme;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,style: style.titleLarge,),
          content: Text(content,style: style.titleMedium),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog2(String title, String content, BuildContext context) {
    final style=Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,style: style.titleLarge,),
          content: Text(content,style: style.titleMedium,),
          actions: [
            FilledButton(
              onPressed: () {
                context.push('/login');
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
