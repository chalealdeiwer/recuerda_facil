import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/presentations/screens/screens.dart';

import '../../../../features/auth/presentation/providers/providers_auth.dart';
import '../../../../services/services.dart';

class BoardsSCreen extends ConsumerWidget {
  static const name = 'boards_screen';
  const BoardsSCreen({super.key});

  void deleteChat(chat, userActive, snapshot, context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Información"),
          content: const Text(
              "¿Está seguro de que desea eliminar el chat con esta persona, el chat se eliminará para ambas partes?"),
          actions: [
            TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text("Cancelar")),
            TextButton(
                onPressed: () async {
                  ChatService().deleteChat(
                      chat.id, userActive.uid!, snapshot.data!.uid!);
                  context.pushReplacement('/more/chats');
                },
                child: const Text("Aceptar")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, ref) {
    final userActive = ref.watch(authProvider).user;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          const BoardScreen().showCreateBoardDialog(context, userActive);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Tableros Colaborativos'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: BoardService().streamUserBoards(userActive!.uid!),
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar los tableros'));
            } else {
              final boards = snapshot.data ?? [];
              if (boards.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        const Text(
                          'No hay tableros disponibles. Puedes crear uno nuevo.',
                          style: TextStyle(fontSize: 28),
                        ),
                        FilledButton.icon(
                          onPressed: () {
                            const BoardScreen()
                                .showCreateBoardDialog(context, userActive);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Crear Tablero"),
                        )
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: boards.length,
                itemBuilder: (BuildContext context, int index) {
                  final board = boards[index];
                  return GestureDetector(
                    onTap: () {
                      context.push(
                          '/more/boards/boards_list/board/${board['id']}');
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.primaries[index % Colors.primaries.length]
                            .shade500,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${board['name']} (${board['id']})",
                                style: const TextStyle(
                                    fontSize: 25, color: Colors.white),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                "Usuarios: ${board['users'].length}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                          IconButton(
                              iconSize: 40,
                              onPressed: () {
                                showLeaveBoardDialog(context, board, userActive);
                              },
                              icon: const Icon(Icons.delete))
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  static Future<bool?> showLeaveBoardDialog(
      BuildContext context, board, userActive) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro de que quieres salir del tablero?',style: TextStyle(fontSize: 28)),
          content: const Text("Al salir del tablero perderás el acceso, igualmente puedes volver a unirte al tablero si lo deseas con el código. ",style: TextStyle(fontSize: 23),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No salir del tablero
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                BoardService().removeUserFromBoard(
                    board['id'], userActive.uid!); 
                context.pop();// Sí, salir del tablero
              },
              child: const Text('Salir del Tablero'),
            ),
          ],
        );
      },
    );
  }
}
