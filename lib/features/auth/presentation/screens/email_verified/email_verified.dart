import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../presentations/widgets/widgets.dart';
import '../../providers/providers_auth.dart';

class EmailVerifiedScreen extends ConsumerWidget {
  static const name = "email_verified_screen";
  const EmailVerifiedScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text("Email verificación"),
        // ),
        body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 10,
            ),
            customTitle(context,
                title1: "Recuerda", size1: 30, title2: "Fácil", size2: 30),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Luego de crear tu cuenta, estas a un paso de ser parte de Recuerda Fácil",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Por favor revisa tu correo y verifica tu cuenta",
              style: TextStyle(fontSize: 30),
            ),
            const Text(
              "En cuanto verifiques tu cuenta recarga esta pantalla",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 30,
            ),
            FilledButton.icon(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                ref.read(authProvider.notifier).verifiedEmail().then((value) {
                  if (value) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Correo correctamente verificado"),
                          content: const Text("Puedes continuar con tu cuenta"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text("Perfecto"))
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Aún no has verificado tu Email"),
                          content: const Text(
                              "Por favor revisa tu correo, y verifica tu cuenta"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text("Ok"))
                          ],
                        );
                      },
                    );
                  }
                });
              },
              label: const Text("Recargar"),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    ));
  }
}
