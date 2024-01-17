import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/services/chat_service.dart';

import '../../../features/auth/presentation/providers/providers_auth.dart';
import '../../../services/services.dart';

class ChatsScreen extends ConsumerWidget {
  static const name = 'chats_screen';
  const ChatsScreen({super.key});

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
      appBar: AppBar(
        title: const Text('Mensajes'),
      ),
      body: Center(
          child: StreamBuilder(
              stream: ChatService().loadAllChats(userActive!.uid!),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar los chats'));
                } else {
                  final chats = snapshot.data?.docs ?? [];
                  if(snapshot.data?.docs.length==0){
                    return  Center(
                      
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 100,),
                            const Text('No hay chats disponibles, entra en "Personas" y encuentra la comunidad de recuerda fácil ',style: TextStyle(fontSize: 25),),
                            FilledButton.icon(onPressed: (){
                              context.push('/community');
                            }, icon: const Icon(Icons.person  ), label: const Text("Ir a personas"))
                          ],
                        ),
                      ));
                  }

                  return ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (BuildContext context, int index) {
                        final chat = chats[index];
                        return FutureBuilder(
                          future: ChatService()
                              .getOtherUserIdInChat(chat.id, userActive.uid!),
                          builder: (context, snapshot) {
                            return FutureBuilder(
                              future: getUser(snapshot.data.toString()),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                    width: 10,
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData) {
                                  return const Text('Usuario no encontrado.');
                                } else {
                                  return ListTile(
                                    trailing: IconButton(
                                        onPressed: () {
                                          deleteChat(chat, userActive, snapshot,
                                              context);
                                        },
                                        icon: const Icon(Icons.delete)),
                                    leading: CircleAvatar(
                                      minRadius: 25,
                                      maxRadius: 25,
                                      backgroundImage: NetworkImage(
                                          snapshot.data!.photoURL!),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    title: Text(
                                      "${snapshot.data!.displayName}",
                                      style: const TextStyle(fontSize: 25),
                                    ),
                                    onTap: () {
                                      context
                                          .push('/more/chats/chat/${chat.id}');
                                    },
                                  );
                                }
                              },
                            );
                          },
                        );
                      });
                }
              })),
    );
  }
}
