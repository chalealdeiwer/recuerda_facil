import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/services/services.dart';

class BoardScreen extends StatelessWidget {
  static const name = 'board_screen';
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableros'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Tableros Colaborativos',
                style: TextStyle(fontSize: 20),
              ),
              Column(children: [
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colors.surfaceVariant,
                  ),
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showCreateBoardDialog(context, user);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: colors.primary.withOpacity(0.2),
                              ),
                              width: 150,
                              height: 150,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  FadeInRight(
                                    child: const Icon(
                                      Icons.plus_one,
                                      size: 100,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Crear Tablero",
                                    style: textStyle.titleLarge,
                                    textScaleFactor: 1,
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showAddUserToBoard(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: colors.primary.withOpacity(0.2),
                              ),
                              width: 150,
                              height: 150,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  FadeInRight(
                                    child: const Icon(
                                      Icons.add_task,
                                      size: 100,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Unirse",
                                    style: textStyle.titleLarge,
                                    textScaleFactor: 1,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.push('/more/boards/boards_list');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: colors.primary.withOpacity(0.2),
                              ),
                              width: 150,
                              height: 150,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  FadeInRight(
                                    child: const Icon(
                                      Icons.dashboard,
                                      size: 100,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Mis Tableros",
                                    style: textStyle.titleLarge,
                                    textScaleFactor: 1,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ])
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showAddUserToBoard(BuildContext context) async {
    String? code = await getCodeFromUser(context);

    if (code == null) {
      showAlert(context,
          'Error: Código inválido. Ingrese un código de 4 caracteres.');
    } else {
      bool boardExists = await BoardService().doesBoardExist(code);

      if (boardExists) {
        bool userExistsInBoard = await BoardService()
            .doesUserExistInBoard(code, FirebaseAuth.instance.currentUser!.uid);

        if (!userExistsInBoard) {
          // Agregar lógica para agregar el nuevo usuario al tablero
          await BoardService()
              .addUserToBoard(code, FirebaseAuth.instance.currentUser!.uid);
          showAlert(context, 'Agregado exitosamente al tablero.');

          context.pushReplacement('/more/boards/boards_list/board/$code');
        } else {
          showAlert(context, 'Ya estas en el tablero.');
        }
      } else {
        showAlert(context,
            'El tablero no existe. Verifique los datos, distingue minúsculas de mayúsculas.');
      }
    }
  }

  Future<String?> getCodeFromUser(BuildContext context) async {
    String? code;
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ingrese el código de 4 caracteres:'),
          content: TextField(
            onChanged: (value) {
              code = value.trim();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(code);
              },
              child: const Text('Continuar'),
            ),
          ],
        );
      },
    );
  }

  void showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Información'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showCreateBoardDialog(BuildContext context, user) async {
    String boardName = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Crear Tablero'),
          content: TextField(
            onChanged: (value) {
              boardName = value;
            },
            decoration: const InputDecoration(labelText: 'Nombre del Tablero'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () async {
                context.pop();
              },
            ),
            FilledButton(
              child: const Text('Crear'),
              onPressed: () async {
                if (boardName.trim().isNotEmpty) {
                  await BoardService()
                      .createBoard(
                          boardName, user.uid, user.displayName, user.photoURL)
                      .then((value) => context
                          .push('/more/boards/boards_list/board/$value'));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Por favor, ingrese un nombre válido para el tablero.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
